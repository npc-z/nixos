{
  mylib,
  myvars,
  ...
}: let
  username = myvars.username;
  hostname = "work-macbook-pro";
in {
  imports = [
    (mylib.relativeToRoot "modules/darwin/configuration.nix")
  ];

  config = {
    networking.hostName = hostname;
    networking.computerName = hostname;
    system.defaults.smb.NetBIOSName = hostname;

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users."${username}" = {
      home = "/Users/${username}";
      description = username;
    };
  };
}
