{
  description = "skills catalog flake for project child pattern";

  inputs = {
    agent-skills.url = "github:Kyure-A/agent-skills-nix";
    # NOTE: 添加新的 skill 源之后，需要运行以下命令更新 lock 文件，否则会提示 outputs 函数参数问题
    # nix flake lock --update-input skills-catalog

    anthropic-skills = {
      url = "github:anthropics/skills";
      flake = false;
    };

    mattpocock-skills = {
      url = "github:mattpocock/skills";
      flake = false;
    };
  };

  outputs = {
    self,
    agent-skills,
    anthropic-skills,
    mattpocock-skills,
    ...
  }: {
    homeManagerModules.default = {
      imports = [
        agent-skills.homeManagerModules.default
        (import ./home-manager.nix {
          inherit anthropic-skills mattpocock-skills;
        })
      ];
    };
  };
}
