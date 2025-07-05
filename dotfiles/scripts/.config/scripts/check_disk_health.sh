#!/usr/bin/env bash
set -e

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

# export DBUS_SESSION_BUS_ADDRESS=$(sudo -u npc echo $DBUS_SESSION_BUS_ADDRESS)
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"
export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS=$(sudo -u $SUDO_USER echo $DBUS_SESSION_BUS_ADDRESS)
echo "== $DBUS_SESSION_BUS_ADDRESS"


now=$(date "+%Y-%m-%d %H:%M:%S")
echo -e "${CYAN}硬盘健康检查时间: $now${NC}"
echo "========================================"

if ! command -v smartctl &>/dev/null || ! command -v jq &>/dev/null || ! command -v notify-send &>/dev/null; then
    echo -e "${RED}请先安装 smartmontools jq libnotify-bin${NC}"
    exit 1
fi

json_output="[]"
disks=$(lsblk -dn -o NAME,TYPE | awk '$2=="disk"{print "/dev/"$1}')

# 报警函数
function send_alert() {
    local title="$1"
    local message="$2"
    if [[ -n "$SUDO_USER" ]]; then
        sudo -u "$SUDO_USER" DISPLAY=$DISPLAY DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS notify-send -u critical "$title" "$message"
    else
        notify-send -u critical "$title" "$message"
    fi
}


for disk in $disks; do
    block_name=$(basename "$disk")
    is_removable=$(cat /sys/block/$block_name/removable 2>/dev/null)
    is_usb=$(udevadm info -q path -n "$disk" | grep -q "/usb" && echo 1 || echo 0)

    if [[ "$is_removable" == "1" || "$is_usb" == "1" ]]; then
        echo -e "${YELLOW}跳过 USB 设备或可移动设备: $disk${NC}"
        echo "----------------------------------------"
        continue
    fi

    echo -e "${CYAN}设备: $disk${NC}"
    echo "----------------------------------------"

    info=$(smartctl -i "$disk")
    if ! echo "$info" | grep -q "SMART support is: Enabled"; then
        echo "  SMART 未启用，尝试启用..."
        smartctl -s on "$disk" >/dev/null 2>&1
    else
        echo "  SMART 状态: 已启用"
    fi

    health_line=$(smartctl -H "$disk" | grep -E "PASSED|FAILED|OK" || echo "未知")
    if echo "$health_line" | grep -q "PASSED"; then
        echo -e "  健康状态: ${GREEN}$health_line${NC}"
    elif echo "$health_line" | grep -q "FAILED"; then
        echo -e "  健康状态: ${RED}$health_line${NC}"
        send_alert "硬盘健康告警: $disk" "健康状态 FAILED，请尽快检查硬盘！"
    else
        echo -e "  健康状态: ${YELLOW}$health_line${NC}"
    fi

    attributes=$(smartctl -A "$disk")

    temp=$(echo "$attributes" | grep -iE 'Temperature|Temp' | awk '{for(i=1;i<=NF;i++) if ($i ~ /^[0-9]+$/) print $i; exit}')
    if [[ -n "$temp" && "$temp" -gt 25 ]]; then
        echo -e "  当前温度: ${YELLOW}${temp}°C (偏高)${NC}"
        send_alert "硬盘温度告警: $disk" "温度达到 ${temp}°C，建议检查散热。"
    elif [[ -n "$temp" ]]; then
        echo -e "  当前温度: ${GREEN}${temp}°C${NC}"
    else
        temp="N/A"
        echo "  当前温度: N/A"
    fi

    reallocated=$(echo "$attributes" | grep -i "Reallocated_Sector_Ct" | awk '{print $10}')
    if [[ "$reallocated" -gt 0 ]]; then
        echo -e "  重映射扇区数: ${RED}$reallocated${NC}"
        send_alert "硬盘重映射扇区告警: $disk" "重映射扇区数为 $reallocated，硬盘可能有问题！"
    else
        reallocated="0"
        echo -e "  重映射扇区数: ${GREEN}0${NC}"
    fi

    wearout=$(echo "$attributes" | grep -iE "Wear_Leveling_Count|Media_Wearout_Indicator|Percentage_Used" | awk '{print $10}')
    wearout_clean="${wearout%\%}"
    if [[ -n "$wearout_clean" ]]; then
        if [[ "$wearout_clean" -gt 80 ]]; then
            echo -e "  磨损程度: ${RED}${wearout} (已严重磨损)${NC}"
            send_alert "硬盘磨损告警: $disk" "磨损程度达到 $wearout，建议备份数据并更换硬盘。"
        elif [[ "$wearout_clean" -gt 50 ]]; then
            echo -e "  磨损程度: ${YELLOW}${wearout} (中等磨损)${NC}"
        else
            echo -e "  磨损程度: ${GREEN}${wearout} (良好)${NC}"
        fi
    else
        wearout="N/A"
    fi

    data_written="N/A"
    data_read="N/A"
    percentage_used="N/A"

    if [[ "$disk" == /dev/nvme* ]]; then
        nvme_smart=$(smartctl -a "$disk")
        data_written=$(echo "$nvme_smart" | grep -i "Data Units Written" | head -n1 | awk -F':' '{print $2}' | xargs)
        data_read=$(echo "$nvme_smart" | grep -i "Data Units Read" | head -n1 | awk -F':' '{print $2}' | xargs)
        percentage_used=$(echo "$nvme_smart" | grep -i "Percentage Used" | awk -F':' '{print $2}' | xargs)

        echo -e "  写入量: ${CYAN}${data_written}${NC}"
        echo -e "  读取量: ${CYAN}${data_read}${NC}"

        used_pct="${percentage_used%\%}"
        if [[ "$used_pct" -gt 80 ]]; then
            echo -e "  使用寿命: ${RED}${percentage_used} (已严重磨损)${NC}"
            send_alert "NVMe 使用寿命告警: $disk" "使用寿命达到 $percentage_used，建议备份更换。"
        elif [[ "$used_pct" -gt 50 ]]; then
            echo -e "  使用寿命: ${YELLOW}${percentage_used} (中等磨损)${NC}"
        else
            echo -e "  使用寿命: ${GREEN}${percentage_used} (健康)${NC}"
        fi
    fi

    disk_json=$(jq -n \
        --arg name "$disk" \
        --arg health "$health_line" \
        --arg temp "$temp" \
        --arg reallocated "$reallocated" \
        --arg wearout "$wearout" \
        --arg data_written "$data_written" \
        --arg data_read "$data_read" \
        --arg pct_used "$percentage_used" \
        '{
            device: $name,
            health: $health,
            temperature_celsius: $temp,
            reallocated_sectors: $reallocated,
            wearout: $wearout,
            nvme_data_written: $data_written,
            nvme_data_read: $data_read,
            nvme_percentage_used: $pct_used
        }')

    json_output=$(echo "$json_output" | jq --argjson item "$disk_json" '. += [$item]')

    echo "========================================"
done

echo -e "\n${CYAN}JSON 输出结果:${NC}"
echo "$json_output" | jq .

