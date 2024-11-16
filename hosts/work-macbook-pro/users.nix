{settings, ...}: let
  username = settings.user.username;
  hostname = "work-macbook-pro";
in {
  #############################################################
  #
  #  Host & Users configuration
  #
  #############################################################

  networking.hostName = hostname;
  networking.computerName = hostname;
  system.defaults.smb.NetBIOSName = hostname;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."${username}" = {
    home = "/Users/${username}";
    description = username;
    hashedPassword = "$y$j9T$hzAVLzc8eIFShnzWJiye/0$Wo5QHjsi98zBMcUqlUZ8Ehe6JKcekiI/rBcWLgDCuh9";
  };

  nix.settings.trusted-users = [username];
}
