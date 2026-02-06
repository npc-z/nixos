{myvars, ...}: {
  # username
  home.username = "${myvars.username}";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
