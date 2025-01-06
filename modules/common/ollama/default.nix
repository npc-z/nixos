{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.ollama;
in {
  options.modules.ollama = {
    enable = lib.mkEnableOption "ollama service";

    package = lib.mkOption {
      default = pkgs.ollama;
      example = "pkgs.ollama";
      type = lib.types.package;
      description = ''
        The ollama package to use.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.config.rocmSupport = true;

    services = {
      ollama = {
        enable = true;
        # Get up and running with large language models locally, using ROCm for AMD GPU acceleration
        package = cfg.package;

        host = "0.0.0.0";
        port = 11434;
        environmentVariables = {
          OLLAMA_ORIGINS = "*";
        };

        acceleration = "rocm";
        loadModels = [
          # "llama3.2:3b"
          # "qwen2.5:7b"
          # "gemma2"
        ];
      };

      # https://github.com/open-webui/open-webui
      # docker run -d -p 4000:8080 --add-host=host.docker.internal:host-gateway -v open-webui:/app/backend/data --name open-webui  ghcr.io/open-webui/open-webui:main
      # open-webui = {
      #   enable = true;
      #   port = 11435;
      # };
    };
  };
}
