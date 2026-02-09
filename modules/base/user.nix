{myvars, ...}: {
  users.users.${myvars.username} = {
    description = myvars.userFullName;
  };
}
