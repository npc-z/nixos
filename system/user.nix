{pkgs, ...}: {
  users.defaultUserShell = pkgs.zsh;

  # forbid `useradd` to add user
  # users.mutableUsers = false;

  users.users.npc = {
    isNormalUser = true;
    description = "npc";
    hashedPassword = "$y$j9T$hzAVLzc8eIFShnzWJiye/0$Wo5QHjsi98zBMcUqlUZ8Ehe6JKcekiI/rBcWLgDCuh9";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGuIPjwGBy3kQ8TZRLO2vhiuY2UduMQQ+kQHYDx+LewZ"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJN3g8//Dn1L5pnoII2VxHDUQzt2n4gIKmvqtA//4JQK"
    ];
  };
}
