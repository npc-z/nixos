{pkgs, ...}: {
  config = {
    home.packages = with pkgs; [
      # Modern API client that lives in your terminal
      posting
    ];
  };
}
