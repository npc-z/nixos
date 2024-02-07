{ config, lib, pkgs, ... }:

{
    users.defaultUserShell = pkgs.zsh;

    users.users.npc = {
        isNormalUser = true;
        description = "npc";
        extraGroups = [
            "networkmanager"
            "wheel"
            "docker"
        ];
        packages = with pkgs; [
            firefox
        ];
    };
}
