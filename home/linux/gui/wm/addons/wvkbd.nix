{pkgs, ...}: {
  home.packages = with pkgs; [
    wvkbd

    (writeShellScriptBin "wvkbd-toggle" ''
      if ${pkgs.procps}/bin/pgrep -x wvkbd-mobintl > /dev/null; then
        ${pkgs.procps}/bin/pkill -x wvkbd-mobintl
      else
        ${pkgs.wvkbd}/bin/wvkbd-mobintl -L 175 &
      fi
    '')
  ];
}
