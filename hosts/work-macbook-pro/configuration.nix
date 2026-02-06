{mylib, ...}: let
  hostname = "work-macbook-pro";
in {
  imports = [
    (mylib.relativeToRoot "modules/darwin")
  ];

  config = {
    networking.hostName = hostname;
    networking.computerName = hostname;
    system.defaults.smb.NetBIOSName = hostname;

    # https://daiderd.com/nix-darwin/manual/index.html#opt-system.stateVersion
    system.stateVersion = 5;
  };
}
