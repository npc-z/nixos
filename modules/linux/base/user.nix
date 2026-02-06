{myvars, ...}: {
  # forbid `useradd` to add user
  # users.mutableUsers = false;

  users.groups = {
    "${myvars.username}" = {};
    docker = {};
    podman = {};
  };

  users.users.${myvars.username} = {
    isNormalUser = true;
    # we have to use initialHashedPassword here when using tmpfs for /
    initialHashedPassword = myvars.initialHashedPassword;

    extraGroups = [
      myvars.username
      # for nmtui / nm-connection-editor
      "networkmanager"
      "wheel"
      "input"
      "libvirtd" # virt-viewer / qemu
      "podman"
      "docker"
      "users"
    ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGuIPjwGBy3kQ8TZRLO2vhiuY2UduMQQ+kQHYDx+LewZ"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJN3g8//Dn1L5pnoII2VxHDUQzt2n4gIKmvqtA//4JQK"
    ];
  };

  users.users.root = {
    initialHashedPassword = myvars.initialHashedPassword;
  };
}
