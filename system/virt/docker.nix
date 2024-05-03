{
  pkgs,
  settings,
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
  };

  # User permissions
  users.users.${settings.user.username}.extraGroups = ["docker"];
}
