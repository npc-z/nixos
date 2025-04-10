{inputs, ...}: {
  # Set Git commit hash for configuration version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  system.stateVersion = "24.05"; # Did you read the comment?
}
