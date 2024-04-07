{ config, lib, pkgs, ... }:

{
    security.rtkit.enable = true;

    # TODO 以下行尝试解决不能弹出 dialog(没能解决)
    security.polkit.enable = true;
}
