{mylib, ...}: {
  imports =
    [
      (mylib.relativeToRoot "modules/base")
    ]
    ++ (mylib.scanPaths ./.);
}
