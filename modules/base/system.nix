{inputs, ...}: {
  # Set Git commit hash for configuration version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";
}
