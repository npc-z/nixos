{pkgs, ...}: {
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;
  hardware.bluetooth.settings = {
    General = {
      # 开启 BlueZ 实验性功能（解决“不显示电量”的关键）
      Experimental = true;
    };
  };

  environment.systemPackages = with pkgs; [
    blueman
  ];
}
