{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.llama-cpp;

  # CUDA enabled builds are not in any binary cache, so they are always built
  # locally. They also need unfree packages, which the NVIDIA GPU module enables.
  llamaCpp =
    if cfg.cuda.enable
    then pkgs.llama-cpp.override {cudaSupport = true;}
    else pkgs.llama-cpp;
in {
  options.modules.llama-cpp = {
    enable = lib.mkEnableOption "llama-cpp service";

    host = lib.mkOption {
      default = "127.0.0.1";
      type = lib.types.str;
      description = ''
        The host for the llama-cpp service.
      '';
    };

    port = lib.mkOption {
      default = 3060;
      type = lib.types.int;
      description = ''
        The port for the llama-cpp service.
      '';
    };

    openFirewall = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = ''
        Whether to open the firewall for the llama-cpp service.
      '';
    };

    contextSize = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.int;
      description = ''
        Size of the context window in tokens (`--ctx-size`). This bounds the KV
        cache, which lives in VRAM when the GPU is used, so an unset value lets
        llama.cpp pick the model's own (often very large) context. `null` keeps
        that default.
      '';
    };

    modelsMax = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.int;
      description = ''
        Maximum number of model instances the router keeps loaded at the same
        time (`--models-max`); the least recently used one is unloaded once the
        limit is reached. `null` keeps the llama.cpp default (4), which lets
        several models occupy VRAM at once and can exhaust a small GPU.
      '';
    };

    sleepIdleSeconds = lib.mkOption {
      default = 900;
      type = lib.types.either (lib.types.enum [(-1)]) lib.types.ints.positive;
      description = ''
        Seconds of idleness after which the server unloads the loaded model and
        its KV cache, reloading it on the next request (`--sleep-idle-seconds`).
        Only real inference requests count as activity: `GET /health`, `/props`,
        `/models` and `/metrics` neither reload the model nor reset the timer,
        so model list polling cannot keep it awake. Set to -1 to keep models
        resident, which is llama.cpp's own default.
      '';
    };

    autoStart = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = ''
        Start the service with `multi-user.target`. Disable it to keep the
        server stopped until it is started by hand (`systemctl start
        llama-cpp`), so a machine that only needs the server occasionally never
        idles with a loaded model.
      '';
    };

    noMmproj = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = ''
        Disable the multimodal projector for every model (`--no-mmproj`),
        dropping image and video input. llama.cpp's default is the opposite,
        `--mmproj-auto`: the projector is used whenever a model ships one and
        nothing is loaded for text-only models. This flag is process wide and is
        inherited by every model instance, and because router command line
        arguments outrank `--models-preset` entries it cannot be turned back on
        for a single model. Leave it off when you want that per-model behaviour.
      '';
    };

    cuda = {
      enable = lib.mkEnableOption "CUDA acceleration (NVIDIA GPU) for the llama-cpp service";

      gpuLayers = lib.mkOption {
        default = 99;
        type = lib.types.int;
        description = ''
          Number of model layers to offload to the GPU
          (`--n-gpu-layers`). llama.cpp clamps this to the layer count of the
          model, so the default offloads everything that fits in VRAM. Lower it
          if a model does not fit and you want a partial offload.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # 只对 docker0 放行；局域网里仍然打不开 3060
    networking.firewall.interfaces.docker0.allowedTCPPorts = [
      config.modules.llama-cpp.port
    ];

    environment.systemPackages = [
      llamaCpp
    ];

    services.llama-cpp = {
      enable = true;

      package = llamaCpp;

      openFirewall = cfg.openFirewall;
      settings =
        {
          host = cfg.host;
          port = cfg.port;
          sleep-idle-seconds = cfg.sleepIdleSeconds;
        }
        // lib.optionalAttrs (cfg.contextSize != null) {
          ctx-size = cfg.contextSize;
        }
        // lib.optionalAttrs (cfg.modelsMax != null) {
          models-max = cfg.modelsMax;
        }
        // lib.optionalAttrs cfg.noMmproj {
          no-mmproj = true;
        }
        // lib.optionalAttrs cfg.cuda.enable {
          n-gpu-layers = cfg.cuda.gpuLayers;
        };
    };

    # the nixpkgs module wants the service from multi-user.target; drop that so a
    # host can keep the server down until it is started on purpose
    systemd.services.llama-cpp.wantedBy = lib.mkIf (!cfg.autoStart) (lib.mkForce []);

    # mkdir -p ~/.local/share/open-webui
    #
    # docker rm -f open-webui

    # docker run -d --name open-webui \
    #   --add-host=host.docker.internal:host-gateway \
    #   -p 3070:8080 \
    #   -v ~/.local/share/open-webui:/app/backend/data \
    #   --restart unless-stopped \
    #   ghcr.io/open-webui/open-webui:main
  };
}
