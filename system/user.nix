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
    packages = with pkgs; [
      firefox
    ];
  };
}
