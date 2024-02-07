{ config, lib, pkgs, ... }:

{
    i18n = {
        defaultLocale = "en_US.UTF-8";
        supportedLocales = [
            "zh_CN.UTF-8/UTF-8"
            "en_US.UTF-8/UTF-8"
        ];
        inputMethod = with pkgs; {
            enabled = "fcitx5";
            fcitx5 = {
                addons = [
                    fcitx5-chinese-addons
                    fcitx5-configtool
                    fcitx5-gtk
                ];
            };
        };
    };
}
