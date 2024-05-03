{pkgs, ...}: {
  environment.systemPackages = with pkgs; [swaylock];

  # Unlock with Swaylock
  security = {
    pam = {
      services = {
        swaylock = {
          fprintAuth = false;
          text = ''
            auth include login
          '';
        };
      };
    };
  };
}
