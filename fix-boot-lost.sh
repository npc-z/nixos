# fix nixos boot lost after windows update system

# 1, enter nixos live usb

# 2, mount partitions

# WARMING: fix these
# mount -o compress=zstd,subvol=root /dev/nvme0n1p5 /mnt
# mount -o compress=zstd,subvol=home /dev/nvme0n1p5 /mnt/home
# mount -o compress=zstd,subvol=vm /dev/nvme0n1p5 /mnt/vm
# mount -o compress=zstd,noatime,subvol=nix /dev/nvme0n1p5 /mnt/nix
# mount /dev/nvme0n1p1 /mnt/boot
# swapon /dev/nvme0n1p4

# 3, cp the minimal configuration file
# mkdir -p /mnt/nix/nixos

# cp /mnt/home/npc/.config/nixos/hosts/{host}/hardware-configuration.nix /mnt/nix/nixos/
# cp /mnt/home/npc/.config/nixos/hosts/start/start.nix /mnt/nix/nixos/

# 4 connect to network
# sudo systemctl start wpa_supplicant
# sudo wpa_cli
  # add_network
  # 0
  # set_network 0 ssid "你家 WIFI 的 SSID"
  # OK
  # set_network 0 psk "WIFI 密码"
  # OK
  # set_network 0 key_mgmt WPA-PSK
  # OK
  # enable_network 0
  # OK


# 4.1 consider proxy network
# cp /mnt/home/npc/.config/nixos/dotfiles/shell/basic.sh .

# 5, install
# sudo nixos-install --option substituters "https://mirror.sjtu.edu.cn/nix-channels/store"

# reboot

