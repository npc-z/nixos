{mylib, ...}: {
  imports = [
    (mylib.relativeToRoot "modules/base")
    (mylib.relativeToRoot "modules/linux/base")
  ];
}
