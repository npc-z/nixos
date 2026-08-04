{...}: let
  networkFunc = builtins.readFile ./scripts/network.sh;
in {
  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      bind 'set show-all-if-ambiguous on'
      bind 'TAB:menu-complete'

      ${networkFunc}

      eval "$(devenv hook bash)"
    '';
  };
}
