{pkgs, ...}: {
  imports = [
    ./../base/home.nix
  ];

  config.home.packages = with pkgs; [
    jetbrains.idea-community-bin
  ];

  # for hypyland config
  config.hypr.settings = {
    enable = true;
    host = "thinkpad-e14";
  };
}
