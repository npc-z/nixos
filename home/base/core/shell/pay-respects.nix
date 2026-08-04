{...}: {
  # Command suggestions, command-not-found and thefuck replacement written in Rust
  programs.pay-respects = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    options = [
      "--alias"
      "fuck"
    ];
  };
}
