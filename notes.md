# Linux note

## Bluetooth keyboard

解决不能正常连接蓝牙键盘。可以通过终端进行连接。
按以下步骤进行连接：

1, 终端中进入 `bluetoothctl`
2, `agent on`
3, 扫描蓝牙设备 `scan on`
4, 发现目标设备之后停止扫描 `scan off`
5, 信任设备 `trust 34:...`
6, 配对设备 `pair 34:...`
7, 连接设备 `connect 34:...`
