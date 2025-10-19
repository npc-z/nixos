{...}: {
  programs = {
    clash-verge = {
      # package = pkgs.clash-nyanpasu;
      enable = true;
      # autoStart = true;
      tunMode = true;
      serviceMode = true;
    };
  };

  networking = {
    firewall = {
      # Traffic coming in from these interfaces will be accepted unconditionally
      trustedInterfaces = [
        "mihomo"
      ];
    };
  };
}
