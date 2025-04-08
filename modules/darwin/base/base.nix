{
  inputs,
  myvars,
  pkgs,
  ...
}: {
  nixpkgs.overlays = [
    # nuenv.overlays.default
  ];

  # auto upgrade nix to the unstable version
  # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/tools/package-management/nix/default.nix#L284
  nix.package = pkgs.nixVersions.latest;

  environment.systemPackages = with pkgs; [
    python311
    python311Packages.pip
    python311Packages.isort
    python311Packages.black
    gnumake
    nixd

    just # use Justfile to simplify nix-darwin's commands
    stow
    neofetch
    fastfetch
    git # used by nix flakes
    git-lfs # used by huggingface models

    # archives
    zip
    xz
    zstd
    unzipNLS
    p7zip

    # Text Processing
    # Docs: https://github.com/learnbyexample/Command-line-text-processing
    gnugrep # GNU grep, provides `grep`/`egrep`/`fgrep`
    gnused # GNU sed, very powerful(mainly for replacing text in files)
    gawk # GNU awk, a pattern scanning and processing language
    jq # A lightweight and flexible command-line JSON processor

    # networking tools
    # mtr # A network diagnostic tool
    # iperf3
    # dnsutils # `dig` + `nslookup`
    # ldns # replacement of `dig`, it provide the command `drill`
    wget
    curl
    httpie
    # aria2 # A lightweight multi-protocol & multi-source command-line download utility
    # socat # replacement of openbsd-netcat
    # nmap # A utility for network discovery and security auditing
    # ipcalc # it is a calculator for the IPv4/v6 addresses

    # misc
    file
    findutils
    which
    tree
    gnutar
    rsync
  ];

  users.users.${myvars.username} = {
    # description = myvars.username;
  };

  # Set Git commit hash for configuration version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
}
