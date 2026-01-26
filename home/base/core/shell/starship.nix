{config, ...}: {
  home = {
    sessionVariables = {
      STARSHIP_CACHE = "${config.xdg.cacheHome}/starship";
    };
  };

  programs.starship = {
    enable = true;
    enableIonIntegration = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };
}
