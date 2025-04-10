{...}: {
  networking = {
    # firewall use nftables instea of iptables
    nftables.enable = false;
    firewall = {
      enable = true;
      allowedTCPPorts = [
        80
        443
        # for localsend
        53317
      ];
      allowedTCPPortRanges = [
        {
          from = 8000;
          to = 9000;
        }
      ];
      # allowedUDPPorts = [];
      allowedUDPPortRanges = [
        {
          from = 8000;
          to = 9000;
        }
      ];
    };
  };
}
