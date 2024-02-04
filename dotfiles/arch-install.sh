
https://arch.icekylin.online/guide/rookie/basic-install.html

https://zocoxx.com/archlinux-dwm-incomplete-guide.html

https://gist.github.com/npc-z/7e447311ab0e23ba249ef38445398394


# setfont ter-132n

# 禁用 reflector 服务
systemctl stop reflector.service

systemctl status reflector.service


# network
# ip link set wlan0 up #比如无线网卡看到叫 wlan0

# rfkill list
# rfkill unblock all

# iwctl
# device list
# station wlan0 scan
# station wlan0 connect "xxx"

# 在互联网连接之后，systemd-timesyncd 服务将自动校准系统时间
timedatectl status

# /etc/pacman.d/mirrorlist

# reflector --help

# 选出位于平均同步延迟在 3 小时以内的，位于中国的 https 软件源，并根据速度排序。指定 --completion-percent 95（默认为100）的目的是防止忽略可用的镜像源

reflector -p https -c china --delay 3 --completion-percent 95 --sort rate --save /etc/pacman.d/mirrorlist

# 也可以根据得分排序
# reflector -p https -c china --delay 3 --completion-percent 95 --sort score --save /etc/pacman.d/mirrorlist

# 手动编辑加入
# vim /etc/pacman.d/mirrorlist

# Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch
# Server = https://mirrors.ustc.edu.cn/archlinux/$repo/os/$arch


# vim /etc/pacman.conf
# enable Color and ParallelDownloads

pacman -Sy

# 分区
# lsblk
# cfdisk /dev/sda

# mkfs.fat -F 32 /dev/xxx efi 分区
# mkfs.ext4 /dev/xxx 主分区
# mkswap dev/xxx 交换分区
# swapon /dev/xxx

# 要先挂载根分区
# mount /dev/sda2 /mnt

# efi 分区
# mount --mkdir /dev/sda1 /mnt/boot


# 安装基础包

# 初始化密钥环
pacman-key --init
pacman-key --populate
pacman -Sy archlinux-keyring
# 如果报错则执行以下命令
# rm -rf /etc/pacman.d/gnupg

# 基础包 内核 驱动程序
# 安装 sof-firmware，否则可能没有声音
pacstrap -K /mnt base base-devel linux linux-firmware sof-firmware xorg-server xorg-xinit dhcpcd networkmanager sudo zsh bash-completion git vim alacritty neofetch net-tools openssh wget

# 生成 fstab 文件
# fstab 用来定义磁盘分区。它是 Linux 系统中重要的文件之一。使用 genfstab 自动根据当前挂载情况生成并写入 fstab 文件：

genfstab -U /mnt > /mnt/etc/fstab

# 查一下 /mnt/etc/fstab 确保没有错误：

# cat /mnt/etc/fstab


# chroot
# 使用 arch-chroot 工具切换到新安装的系统，以后的操作就可以在新安装的系统中完成

arch-chroot /mnt


# 生成 GRUB 所需的配置文件：
pacman -S grub efibootmgr os-prober



grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=ARCH

# --efi-directory=/boot —— 将 grubx64.efi 安装到之前的指定位置（EFI 分区）
# --bootloader-id=ARCH —— 取名为 ARCH


# vim /etc/default/grub

# 去掉 GRUB_CMDLINE_LINUX_DEFAULT 一行中最后的 quiet 参数
# 把 loglevel 的数值从 3 改成 5。这样是为了后续如果出现系统错误，方便排错
# 加入 nowatchdog 参数，这可以显著提高开关机速度
# 为了引导 win10，则还需要添加新的一行 GRUB_DISABLE_OS_PROBER=false

grub-mkconfig -o /boot/grub/grub.cfg








# vim /etc/hostname

# vim /etc/hosts

# 127.0.0.1   localhost
# ::1         localhost
# 127.0.1.1   myarch.localdomain myarch



ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

hwclock --systohc


# Locale 决定了软件使用的语言、书写习惯和字符集。
# vim /etc/locale.gen

# en_US.UTF-8 UTF-8
# zh_CN.UTF-8 UTF-8

locale-gen

echo 'LANG=en_US.UTF-8'  > /etc/locale.conf


# pacman -S intel-ucode # Intel
# pacman -S amd-ucode # AMD

# 编辑 /etc/pacman.conf


[archlinuxcn]
Server = https://mirrors.ustc.edu.cn/archlinuxcn/$arch
Server = http://mirrors.163.com/archlinux-cn/$arch

pacman -Sy archlinux-keyring
# 如果报错则执行以下命令
# rm -rf /etc/pacman.d/gnupg


# 安装 fcitx5 输入法
pacman -S fcitx5-im fcitx5-chinese-addons fcitx5-material-color

# sudo pacman -S fcitx5-im # 输入法基础包组
# sudo pacman -S fcitx5-chinese-addons # 官方中文输入引擎
# sudo pacman -S fcitx5-material-color # 输入法主题


# 编辑运行环境 使fcitx5输入法生效
EDITOR=vim sudoedit /etc/environment

# 输入以下内容
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
SDL_IM_MODULE=fcitx


# 设置 root 密码
passw

# 添加用户
useradd -m -G wheel npc

passwd npc

# 提升用户权限
EDITOR=vim visudo
# 去掉“%wheel ALL=(ALL:ALL) ALL”前面的“#”


# /usr/share/xsessions/dwm.desktop

[Desktop Entry]
Encoding=UTF-8
Name=Dwm
Comment=Dynamic window manager
Exec=dwm
Icon=dwm
Type=XSession



pacman -S yay alacritty ttf-jetbrains-mono-nerd man sddm

systemctl enable NetworkManager dhcpcd sddm sshd bluetooth
# nmcli



===================================================================================
pacman -S yay ttf-jetbrains-mono-nerd sddm vim zsh zsh-completion bash-completion git alacritty neofetch net-tools openssh wget xorg xorg-xinit dhcpcd networkmanager base-devel linux linux-firmware

chsh -s "$(which zsh)"

systemctl enable NetworkManager dhcpcd sddm sshd bluetooth

# 安装 fcitx5 输入法
pacman -S fcitx5-im fcitx5-chinese-addons fcitx5-material-color adobe-source-han-sans-cn-fonts adobe-source-han-serif-cn-fonts

# fcitx5-im # 输入法基础包组
# fcitx5-chinese-addons # 官方中文输入引擎
# fcitx5-material-color # 输入法主题

# 编辑运行环境 使fcitx5输入法生效
EDITOR=vim sudoedit /etc/environment

# 输入以下内容
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
SDL_IM_MODULE=fcitx

# /usr/share/xsessions/dwm.desktop
[Desktop Entry]
Encoding=UTF-8
Name=Dwm
Comment=Dynamic window manager
Exec=dwm
Icon=dwm
Type=XSession



# docker
sudo pacman -S docker docker-compose
sudo systemctl enable --now docker
#  若没有 docker 组, 就新建一个 docker 组
sudo groupadd docker
#  将当前用户加入 docker 组中
sudo usermod -aG docker ${USER}
#  刷新组缓存, 即时生效
newgrp ${USER}
#  更新 docker 组
newgrp docker
#  如果操作镜像时还是提示权限问题, 重启可解
#  验证 docker 服务运行状态
sudo systemctl status docker
#  登录
docker login
#  加速
curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://f1361db2.m.daocloud.io
sudo systemctl restart docker # 要正常拉取镜像需要重启
===================================================================================


热点
sudo pacman -S create_ap
# 查看网络接口
ip a

# 临时开启热点
sudo create_ap wlan0 enp3s0f3u2c2 MyAccessPoint MyPassPhrase

# 开机自启
sudo nvim /etc/create_ap.conf

# 至少修改这四项，其他的可以不用更改
# WIFI_IFACE=wlan0 #网卡名称
# INTERNET_IFACE=enp3s0f3u2c2 #网卡名称, 使用 usb 接口的更换 usb 接口后会发生改变
# SSID=AP_Ali #热点名称
# PASSPHRASE=apap_1234 #热点密码

sudo systemctl enable --now create_ap

# 查看服务日志
sudo journalctl -u create_ap



# touchpad  https://blog.csdn.net/qq_36390239/article/details/111350382
echo '
Section "InputClass"
        Identifier "MyTouchpad"
        MatchIsTouchpad "on"
        Driver "libinput"
        Option "Tapping" "on"
    Option "NaturalScrolling" "true"
    Option "AccelProfile" "adaptive"
    Option "AccelSpeed" "0.7"

EndSection
' | sudo tee /etc/X11/xorg.conf.d/30-touchpad.conf
