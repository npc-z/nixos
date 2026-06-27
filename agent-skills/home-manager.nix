{
  anthropic-skills,
  mattpocock-skills,
  ...
}: {
  programs.agent-skills = {
    sources.anthropic = {
      path = anthropic-skills;
      subdir = "skills";
      idPrefix = "anthropic";
    };

    sources.mattpocock = {
      path = mattpocock-skills;
      subdir = "skills/productivity";
      idPrefix = "mattpocock";
    };

    skills.enable = [
      # "anthropic/pdf"
      "mattpocock/teach"
    ];

    targets.opencode.enable = true;
  };
}
