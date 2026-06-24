{
  inputs,
  pkgs,
  ...
}: {
  home.packages = [
    inputs.nur-npc-z.packages.${pkgs.stdenv.hostPlatform.system}.microneo
  ];
}
