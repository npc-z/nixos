{myvars, ...}: {
  # turns your smart phone into a graphic tablet/touch screen for your computer
  programs.weylus = {
    enable = true;
    openFirewall = true;
    users = [
      myvars.username
    ];
  };
}
