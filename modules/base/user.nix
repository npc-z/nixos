{
  myvars,
  pkgs,
  ...
}: {
  users.defaultUserShell = pkgs.zsh;

  users.users.${myvars.username} = {
    description = myvars.userFullName;
  };
}
