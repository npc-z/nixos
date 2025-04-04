{
  myvars,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    docker-compose
    kubectl
    minikube
  ];

  # Docker can also be run rootless
  virtualisation.docker = {
    enable = true;

    # start dockerd on boot.
    # This is required for containers which are created with the `--restart=always` flag to work.
    enableOnBoot = true;
  };

  # User permissions
  users.users.${myvars.username}.extraGroups = ["docker"];
}
