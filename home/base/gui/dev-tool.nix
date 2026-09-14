{
  inputs,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # database tool
    # dbeaver-bin

    # inputs.nur-npc-z.packages.${pkgs.stdenv.hostPlatform.system}.dbx-desktop # 每次都触发编译
    inputs.dbx.packages.${pkgs.stdenv.hostPlatform.system}.dbx-desktop
  ];
}
