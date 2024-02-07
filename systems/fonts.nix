{ config, lib, pkgs, ... }:

{
    fonts.packages = with pkgs; [
        (nerdfonts.override {
            fonts = [
            "JetBrainsMono"
            "FiraCode"
            ];
        })

        noto-fonts noto-fonts-cjk noto-fonts-emoji
        liberation_ttf
        fira-code fira-code-symbols
        mplus-outline-fonts.githubRelease
        dina-font
        proggyfonts
    ];
}
