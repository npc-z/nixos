{mylib, ...}: {
  imports = [
    (mylib.relativeToRoot "modules/darwin/configuration.nix")
    ./users.nix
  ];
}
