{lib, ...}: let
  # Homebrew Mirror
  homebrew_mirror_env = {
    HOMEBREW_API_DOMAIN = "https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api";
    HOMEBREW_BOTTLE_DOMAIN = "https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles";
    HOMEBREW_BREW_GIT_REMOTE = "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git";
    HOMEBREW_CORE_GIT_REMOTE = "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git";
    HOMEBREW_PIP_INDEX_URL = "https://pypi.tuna.tsinghua.edu.cn/simple";
  };
in {
  # NOTE: 全新安装系统时，先不要导入此文件，或者先手动安装 homebrew
  # To make this work, homebrew need to be installed manually, see https://brew.sh
  # Set variables for you to manually install homebrew packages.

  environment.variables = homebrew_mirror_env;

  # Set environment variables for nix-darwin before run `brew bundle`.
  system.activationScripts.homebrew.text = let
    env_script = lib.attrsets.foldlAttrs (acc: name: value: acc + "\nexport ${name}=${value}") "" homebrew_mirror_env;
  in
    lib.mkBefore ''
      echo >&2 '${env_script}'
      ${env_script}
    '';

  # The apps installed by homebrew are not managed by nix, and not reproducible!
  # But on macOS, homebrew has a much larger selection of apps than nixpkgs, especially for GUI apps!
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true; # Fetch the newest stable branch of Homebrew's git repo
      upgrade = true; # Upgrade outdated casks, formulae, and App Store apps
      # 'zap': uninstalls all formulae(and related files) not listed in the generated Brewfile
      cleanup = "zap";
    };

    # Applications to install from Mac App Store using mas.
    # You need to install all these Apps manually first so that your apple account have records for them.
    # otherwise Apple Store will refuse to install them.
    # For details, see https://github.com/mas-cli/mas
    masApps = {
      # TODO Feel free to add your favorite apps here.

      # Xcode = 497799835;
      # Wechat = 836500024;
      # NeteaseCloudMusic = 944848654;
      # QQ = 451108668;
      # WeCom = 1189898970;  # Wechat for Work
      # TecentMetting = 1484048379;
      # QQMusic = 595615424;
    };

    taps = [
      "homebrew/services"
    ];

    # `brew install`
    # TODO Feel free to add your favorite apps here.
    brews = [
      # "wget" # download tool
      # "curl" # no not install curl via nixpkgs, it's not working well on macOS!
      # "aria2" # download tool
      # "httpie" # http client
    ];

    # `brew install --cask`
    # TODO Feel free to add your favorite apps here.
    casks = [
      # web
      "firefox"
      "google-chrome"
      "microsoft-edge"

      # dev
      "dbeaver-community"

      # office
      # "wpsoffice-cn"
      "wpsoffice"

      # "nikitabobko/tap/aerospace"

      # vpn
      "clash-verge-rev"

      # terminals
      "alacritty"
      "kitty"

      # IM & audio & remote desktop & meeting
      # "telegram"
      # "discord"
      "feishu"
      "wechat"
      "neteasemusic"

      # "anki"
      # "iina" # video player
      # "raycast" # (HotKey: alt/option + space)search, caculate and run scripts(with many plugins)
      # "stats" # beautiful system monitor
      # "eudic" # 欧路词典

      # key remapper for macOS
      "karabiner-elements"
      # Lightweight clipboard manager for macOS
      "maccy"

      # Development
      # "insomnia" # REST client
      # "wireshark" # network analyzer
      "visual-studio-code"
      "docker"

      "rustdesk"
      # pin a window to the top
      # "lihaoyun6/tap/topit"

      # Mac Mouse Fix is an app that makes your mouse better
      "mac-mouse-fix@2"
    ];
  };
}
