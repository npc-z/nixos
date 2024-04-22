echo "load_monitor start" >> ~/debug.log

SER7_NIXOS="ser7-nixos"
R9000P_ARCH="arch"

HOSTNAME=$(cat /etc/hostname)

echo $HOSTNAME >> ~/debug.log

if [[ "$HOSTNAME" == "$SER7_NIXOS" ]]; then
    echo "Strings are equal SER7_NIXOS." >> ~/debug.log
elif [[ "$HOSTNAME" == "$R9000P_ARCH"  ]]; then
    echo "Strings are equal R9000P_ARCH." >> ~/debug.log
else
    echo "Strings are not equal." >> ~/debug.log
fi
