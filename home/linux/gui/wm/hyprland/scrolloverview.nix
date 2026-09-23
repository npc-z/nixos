{
  inputs,
  pkgs,
}:
# Build the scroll overview plugin against the nixpkgs Hyprland package
# (already on the system, no Hyprland source build needed) so its API
# version matches the running 0.56.2 release.
#
# mkHyprlandPlugin is the nixpkgs helper for exactly this job: it derives the
# plugin from hyprland's own stdenv and appends hyprland.buildInputs. That
# matters because Hyprland 0.56.2 is compiled with gcc 16.2.0 while the
# default stdenv here is gcc 15.x -- building the plugin with a different
# compiler than the compositor links a second, older libstdc++ (and its
# store path ends up in the plugin's RUNPATH, so it is the one the dynamic
# linker picks for hyprland's own dependencies too). Deriving from
# hyprland.stdenv keeps a single libstdc++ for the whole plugin closure.
pkgs.hyprlandPlugins.mkHyprlandPlugin (finalAttrs: {
  # pluginName becomes the derivation's pname, which home-manager turns into
  # the `lib${pname}.so` path it passes to hl.plugin.load.
  pluginName = "scrolloverview";
  version = inputs.hyprland-scroll-overview.shortRev or "unknown";
  src = inputs.hyprland-scroll-overview;

  # lua is a plugin-specific dependency; hyprland, its buildInputs and
  # pkg-config are all supplied by mkHyprlandPlugin.
  buildInputs = [
    pkgs.lua5_4
  ];

  # Upstream ships a hand-written Makefile next to CMakeLists.txt and
  # meson.build. Drive that Makefile from buildPhase, and keep cmake out of
  # nativeBuildInputs: its setup hook would add a configure phase, generate a
  # competing Makefile and link a different output name.

  buildPhase = ''
    runHook preBuild
    # generate-plugin-version.sh falls back to `git rev-parse` on the store
    # path; pass the revision explicitly so the plugin reports the same
    # version it is packaged as.
    export SCROLLOVERVIEW_BUILD_VERSION="${finalAttrs.version}"
    make all
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/lib"
    # keep in sync with the `-o` target in upstream's Makefile
    cp scrolloverview.so "$out/lib/libscrolloverview.so"
    runHook postInstall
  '';

  meta = {
    description = "Scrollable workspace overview plugin for Hyprland";
    homepage = "https://github.com/yayuuu/hyprland-scroll-overview";
    license = pkgs.lib.licenses.bsd3;
    platforms = pkgs.lib.platforms.linux;
  };
})
