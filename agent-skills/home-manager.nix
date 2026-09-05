{inputs, ...}: {
  programs.agent-skills = {
    sources = {
      anthropic = {
        path = inputs.anthropic-skills;
        subdir = "skills";
        # idPrefix = "anthropic";
      };

      juliusbrussee = {
        path = inputs.juliusbrussee-caveman;
        subdir = "skills";
        # idPrefix = "juliusbrussee";
      };

      mattpocock-productivity = {
        path = inputs.mattpocock-skills;
        subdir = "skills/productivity";
        # idPrefix = "mattpocock-productivity";
      };

      mattpocock-engineering = {
        path = inputs.mattpocock-skills;
        subdir = "skills/engineering";
        # idPrefix = "mattpocock-engineering";
      };

      vercel-labs = {
        path = inputs.vercel-labs-skills;
        subdir = "skills";
        # idPrefix = "vercel-labs";
      };

      kotot-vision = {
        path = inputs.kotot-vision;
        # subdir = "vision";
        # idPrefix = "kotot-vision";
      };

      npc-z-skills = {
        path = inputs.npc-z-skills;
        subdir = "skills";
        # idPrefix = "npc-z-skills"; # 添加 idPrefix 会多添加一层同名目录
      };

      # NOTE: 参考仓库可以添加本地自定义 skills
      # https://github.com/mitramejia/nixos-config/blob/main/modules/home/agent-skills.nix
    };

    skills.enableAll = [
      "mattpocock-productivity"
      "mattpocock-engineering"
      "npc-z-skills"
    ];

    skills.enable = [
      # anthropic
      "frontend-design"
      "webapp-testing"

      # vercel-labs
      "find-skills" # This skill helps you discover and install skills from the open agent skills ecosystem.

      #"juliusbrussee
      # replace with "scoped-commit" from npc-skills
      # "caveman-commit" # Write commit messages terse and exact. Conventional Commits format. No fluff. Why over what.
      "caveman-review" # Write code review comments terse and actionable. One line per finding. Location, problem, fix. No throat-clearing.

      # kotot-vision
      "vision" # help to understand images for model that cannot see images.
    ];

    targets = {
      agents.enable = true;
      # codex.enable = true; # read from agents
      # opencode.enable = true; # read from agents
      # pi.enable = true; # read from agents
    };
  };
}
