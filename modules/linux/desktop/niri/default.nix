{
  inputs,
  pkgs,
  ...
}: {
  programs.niri.enable = true;

  # Or add to your packages
  environment.systemPackages = with pkgs; [
    niri
    xwayland-satellite

    inputs.noctalia.packages.${system}.default
  ];
}
