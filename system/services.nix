{...}: {
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.cron.enable = true;

  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # proxy
  # Transparent redirector of any TCP connection to proxy
  services.redsocks = {
    enable = false;
    redsocks = [
      {
        doNotRedirect = [
          "-d 0.0.0.0/8"
          "-d 10.0.0.0/8"
          "-d 127.0.0.0/8"
          "-d 169.254.0.0/16"
          "-d 172.16.0.0/12"
          "-d 192.168.0.0/16"
          "-d 224.0.0.0/4"
          "-d 240.0.0.0/4"
        ];
        port = 12345;
        proxy = "172.20.10.1:1082";
        redirectCondition = true;
        # not work?
        type = "http-connect";
      }

      {
        doNotRedirect = [
          "-d 0.0.0.0/8"
          "-d 10.0.0.0/8"
          "-d 127.0.0.0/8"
          "-d 169.254.0.0/16"
          "-d 172.16.0.0/12"
          "-d 192.168.0.0/16"
          "-d 224.0.0.0/4"
          "-d 240.0.0.0/4"
        ];
        port = 12346;
        proxy = "172.20.10.1:1082";
        redirectCondition = true;
        type = "socks5";
      }
    ];
  };
}
