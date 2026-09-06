{pkgs, ...}: {
  home.packages = with pkgs; [
    telegram-desktop

    feishu

    qq
    wechat-uos
    # wechat # pr: https://github.com/NixOS/nixpkgs/pull/474257
    wemeet

    # email
    thunderbird
  ];
}
