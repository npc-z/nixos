{inputs, ...}: {
  programs.agent-skills = {
    sources = {
      anthropic = {
        path = inputs.anthropic-skills;
        subdir = "skills";
        idPrefix = "anthropic";
      };

      juliusbrussee = {
        path = inputs.juliusbrussee-caveman;
        subdir = "skills";
        idPrefix = "juliusbrussee";
      };

      mattpocock-productivity = {
        path = inputs.mattpocock-skills;
        subdir = "skills/productivity";
        idPrefix = "mattpocock-productivity";
      };

      mattpocock-engineering = {
        path = inputs.mattpocock-skills;
        subdir = "skills/engineering";
        idPrefix = "mattpocock-engineering";
      };

      vercel-labs = {
        path = inputs.vercel-labs-skills;
        subdir = "skills";
        idPrefix = "vercel-labs";
      };

      kotot-vision = {
        path = inputs.kotot-vision;
        # subdir = "vision";
        idPrefix = "kotot-vision";
      };

      npc-z-skills = {
        path = inputs.npc-z-skills;
        subdir = "skills";
        idPrefix = "npc-z-skills";
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
      "anthropic/frontend-design"
      "anthropic/webapp-testing"

      # This skill helps you discover and install skills from the open agent skills ecosystem.
      "vercel-labs/find-skills"

      # Write commit messages terse and exact. Conventional Commits format. No fluff. Why over what.
      "juliusbrussee/caveman-commit"
      # Write code review comments terse and actionable. One line per finding. Location, problem, fix. No throat-clearing.
      "juliusbrussee/caveman-review"

      "kotot-vision/vision"
    ];

    targets = {
      agents.enable = true;
      codex.enable = true;
      opencode.enable = true;
      pi.enable = true;
    };
  };
}
