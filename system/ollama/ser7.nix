{pkgs, ...}: {
  services = {
    ollama = {
      enable = true;
      # Get up and running with large language models locally, using ROCm for AMD GPU acceleration
      package = pkgs.ollama-rocm;

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

    # open-webui = {
    #   enable = true;
    #   port = 3000;
    # };
  };
}
