{
  mylib,
  myvars,
  ...
}: {
  imports = mylib.scanPaths ./.;

  home.homeDirectory = "/home/${myvars.username}";

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
