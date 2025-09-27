{pkgs, ...}: {
  programs = {
    clash-verge = {
      # package = pkgs.clash-nyanpasu;
      enable = true;
      # autoStart = true;
      tunMode = true;
      serviceMode = true;
    };
  };

  systemd.services.clash-verge-rev = {
    enable = true;
    description = "clash verge rev";
    serviceConfig = {
      ExecStart = "${pkgs.clash-verge-rev}/bin/clash-verge-service";
    };
    wantedBy = ["multi-user.target"];
  };
}
