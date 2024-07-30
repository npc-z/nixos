#! /usr/bin/env bash


exec_once() {
    xset -b                                   # 关闭蜂鸣器

    # syndaemon -i 1 -t -K -R -d >> /dev/null 2>&1 # 设置使用键盘时触控板短暂失效

	blueman-applet &
	nm-applet &
    numlockx on

    clipse -listen

    # fcitx5 -d --replace >> /dev/null 2>&1
    fcitx5 -d --replace

    feh --randomize --bg-fill ~/.config/wallpapers/* # 每300秒更新壁纸

    picom --config ~/.config/picom/picom.conf >> /dev/null 2>&1 & # 开启picom

	pkill -f xdg-desktop-portal-hyprland
	pkill -f xdg-desktop-portal-gnome

	echo "Xft.dpi: 96" | xrdb -merge                      #dpi缩放
	# fcitx &

	systemctl --user unmask xdg-desktop-portal-gnome
	systemctl --user mask xdg-desktop-portal-hyprland
	# /usr/libexec/xdg-desktop-portal &
}

exec_once


# 中英文适配
wifi_grep_keyword="已连接 到"
wifi_disconnected="未连接"
wifi_disconnected_notify="未连接到网络"
wifi_icon=" "
if [ "$LANG" != "zh_CN.UTF-8" ]; then
    wifi_grep_keyword="connected to"
    wifi_disconnected="disconnected"
    wifi_disconnected_notify="disconnected"
fi

status="current status"

update() {
    wifi_text=$(nmcli | grep "$wifi_grep_keyword" | awk -F "$wifi_grep_keyword" '{print $2}')
    [ "$wifi_text" = "" ] && wifi_text=$wifi_disconnected
    wifi_status="$wifi_icon$wifi_text"

    cur_date="$(date +'%Y-%m-%d %H:%M:%S')"

    cur_brightness=$(brightnessctl g)
    brightness=$(( (cur_brightness * 100) / 255))

    volume=$(pamixer --get-volume-human)

    status="$wifi_status  ${brightness}%  ${volume}  ${cur_date} "
}



while [[ true ]]; do
    update

    # echo $status

    xsetroot -name "${status}"
    sleep 1
done

