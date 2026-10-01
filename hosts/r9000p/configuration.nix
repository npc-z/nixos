{mylib, ...}: {
  imports = [
    ./hardware-configuration.nix

    (mylib.relativeToRoot "modules/linux/desktop.nix")
  ];

  config = {
    networking = {
      hostName = "r9000p-nixos";
    };

    # only build CUDA device code for this laptop's GPU (RTX 3060 Laptop = sm_86);
    # the nixpkgs default targets 9 architectures and multiplies compile time
    nixpkgs.config.cudaCapabilities = ["8.6"];

    modules = {
      # NOTE:
      usrEnv.isWayland = true;

      fcitx5.rime.grammarModel.enable = true;

      llama-cpp = {
        enable = true;
        host = "0.0.0.0"; # 容器要从 docker0 访问，不能只绑回环
        cuda.enable = true; # RTX 3060 Laptop
        # contextSize = 32768; # 6GB 显存放不下模型自带的 262144 上下文
        contextSize = 16384; # for unsloth/Qwen3-4B-Instruct-2507-GGUF:Q4_K_M
        modelsMax = 1; # 6GB 显存同时只驻留一个模型，避免 2B+4B 挤爆
        autoStart = false; # 不随机启动，需要时 systemctl start llama-cpp
      };

      cpu = {
        type = "amd";
        amd = {
          # load pstate module in case the device has a newer gpu
          pstate.enable = true;
          # zenpower is for reading cpu info, i.e voltage
          zenpower.enable = true;
        };
      };

      gpu = {
        # type = "amd";
        type = "hybrid-nv";
        busId = {
          nvidia = "PCI:1:0:0";
          amd = "PCI:6:0:0";
        };
      };

      game = {
        enable = true;
      };

      laptop.enable = true;
    };

    # This option defines the first version of NixOS you have installed on this particular machine,
    # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
    #
    # Most users should NEVER change this value after the initial install, for any reason,
    # even if you've upgraded your system to a new NixOS release.
    #
    # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
    # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
    # to actually do that.
    #
    # This value being lower than the current NixOS release does NOT mean your system is
    # out of date, out of support, or vulnerable.
    #
    # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
    # and migrated your data accordingly.
    #
    # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
    system.stateVersion = "24.05"; # Did you read the comment?
  };
}
