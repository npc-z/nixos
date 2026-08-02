{
  inputs,
  pkgs,
}:
# Build the scroll overview plugin against the nixpkgs Hyprland package
# (already on the system, no Hyprland source build needed) so its API
# version matches the running 0.56.0 release.
pkgs.stdenv.mkDerivation {
  # keep pname in sync with the plugin's own name so home-manager
  # generates the correct `lib${pname}.so` path for hl.plugin.load
  pname = "scrolloverview";
  version = inputs.hyprland-scroll-overview.shortRev or "unknown";
  src = inputs.hyprland-scroll-overview;

  inherit (pkgs.hyprland) buildInputs;
  nativeBuildInputs =
    pkgs.hyprland.nativeBuildInputs
    ++ [
      pkgs.hyprland
      pkgs.gcc14
      pkgs.pkg-config
      pkgs.lua5_4
    ];

  buildPhase = ''
    runHook preBuild
    make all
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/lib"
    cp libscrolloverview.so "$out/lib/libscrolloverview.so"
    runHook postInstall
  '';
}
