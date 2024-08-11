{
  pkgs,
  settings,
  ...
}: {
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [pkgs.OVMFFull.fd];
      };
    };
    spiceUSBRedirection.enable = true;
  };

  users.users.${settings.user.username}.extraGroups = ["libvirtd"];

  # fix 网络问题
  # https://www.reddit.com/r/NixOS/comments/18qtsoz/comment/kez0f1b/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_buttong
  networking.firewall.trustedInterfaces = [
    # find these names by cmd `ifconfig`
    "virbr0"
    "virbr1"
  ];

  environment.systemPackages = with pkgs; [
    spice
    spice-gtk
    spice-protocol
    virt-viewer
    virtio-win
    win-spice
  ];
  programs.virt-manager.enable = true;

  home-manager.users.${settings.user.username} = {
    dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = ["qemu:///system"];
        uris = ["qemu:///system"];
      };
    };
  };
}
