{pkgs, ...}: {
  services.dbus = {
    enable = true;
    packages = [pkgs.dconf];
  };

  # Why do I get an error message about ca.desrt.dconf or dconf.service?
  # https://nix-community.github.io/home-manager/index.xhtml#_why_do_i_get_an_error_message_about_literal_ca_desrt_dconf_literal_or_literal_dconf_service_literal
  programs.dconf = {
    enable = true;
  };
}
