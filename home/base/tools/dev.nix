{pkgs, ...}: {
  config = {
    home.packages = with pkgs; [
      # Modern API client that lives in your terminal
      posting
      # Simple terminal UI for both docker and docker-compose
      lazydocker
    ];
  };
}
