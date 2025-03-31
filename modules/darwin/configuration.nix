{mylib, ...}: {
  imports = [
    (mylib.relativeToRoot "modules/base")
    (mylib.relativeToRoot "modules/darwin/base")
  ];
}
