{
  lib,
  mylib,
  ...
}: {
  imports = mylib.scanPaths ./.;

  options.modules.usrEnv = {
    isWayland = lib.mkOption {
      type = lib.types.bool;
      # TODO: default = with env.desktops; (sway.enable || hyprland.enable);
      default = false;
      defaultText = "This will default to true if a Wayland compositor has been enabled";
      description = ''
        Whether to enable Wayland exclusive modules, this contains a wariety
        of packages, modules, overlays, XDG portals and so on.

        Generally includes:
          - Wayland nixpkgs overlay
          - Wayland only services
          - Wayland only programs
          - Wayland compatible versions of packages as opposed
          to the defaults
      '';
    };
  };
}
