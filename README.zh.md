# npc 的 NixOS Flake 配置

[English](./README.md)

个人 Nix Flake，用于声明式管理 NixOS 和 nix-darwin 主机，通过 Home Manager 管理用户级配置。Dotfiles 通过 Home Manager 的 `mkOutOfStoreSymlink` 以符号链接方式部署。

两台 NixOS 主机均运行 Wayland 桌面（Hyprland 与 niri，搭配 Noctalia 桌面外壳）。

## 主机列表

| 主机               | 类型       | 架构             | 说明                                                    |
| ------------------ | ---------- | ---------------- | ------------------------------------------------------- |
| `ser7-nixos`       | NixOS      | `x86_64-linux`   | 迷你主机（零刻 SER7，AMD）                              |
| `r9000p-nixos`     | NixOS      | `x86_64-linux`   | 笔记本（联想拯救者 R9000P，AMD）                        |
| `work-macbook-pro` | nix-darwin | `aarch64-darwin` | 工作用 MacBook Pro（Apple Silicon）— **已不再积极维护** |

## 特性亮点

- **Wayland 桌面**：Hyprland 与 niri（可滚动平铺）共用 hyprlock、swayidle、Noctalia 桌面外壳等附加组件
- **AI 编码助手**：opencode、codex、deepseek、herdr 与 pi，以及 `agent-skills/` 中的代理技能目录
- **中文输入**：fcitx5 + rime，使用万象拼音 fork 及可选的语法模型
- **声明式 Dotfiles**：配置文件通过 Home Manager 从 `dotfiles/` 符号链接部署 — 无需单独的 stow 步骤

## 仓库结构

```
.
├── flake.nix          # Flake 入口：输入、输出、nixConfig
├── flake.lock         # 锁定的 flake 依赖
├── hosts/             # 各主机的配置
│   ├── default.nix    # 主机模板定义
│   ├── ser7/          # 迷你主机配置
│   ├── r9000p/        # 笔记本配置
│   └── work-macbook-pro/  # macOS 配置
├── home/              # Home Manager 模块
│   ├── base/          # 所有主机共享（core / gui / tui）
│   ├── linux/         # Linux 专属
│   └── darwin/        # macOS 专属
├── modules/           # NixOS / nix-darwin 模块
│   ├── base/          # 所有主机共享
│   ├── linux/         # Linux 专属
│   └── darwin/        # macOS 专属
├── overlays/          # 包覆盖层
├── nur/               # NUR（Nix 用户仓库）集成
├── dotfiles/          # 通过 Home Manager 建立符号链接的 dotfile 源文件
├── agent-skills/      # AI 代理技能目录 flake
├── docs/              # 笔记与文档（如 nix-notes）
├── lib/               # 辅助库函数
├── vars/              # 共享变量（用户名等）
├── Justfile           # 任务运行器（类似 Makefile）
└── AGENTS.md          # 编码代理指导
```

## 主要 Flake 输入

核心：

- **nixpkgs** — `nixos-unstable`（最新滚动版本）
- **nixpkgs-stable** — `nixos-26.05`（稳定包，以 `pkgs.stable` 暴露）
- **home-manager** — 用户环境管理
- **nix-darwin** + **nix-homebrew** — macOS 系统管理（Apple Silicon，含 Rosetta）

桌面 / 窗口管理器：

- **hyprland-contrib** — Hypr 项目社区脚本与工具
- **hyprland-scroll-overview** — 可滚动工作区总览插件（类似 niri）
- **noctalia** — 基于 Quickshell 的 Wayland 桌面外壳（cachix 分支）
- **zen-browser** — 来自 flake 的 Zen 浏览器

AI 工具：

- **llm-agents** — AI 编码代理与开发工具相关的 Nix 包
- **skills-catalog** — 本地代理技能目录 flake（`agent-skills/`）

其他：

- **NUR** + **nur-npc-z** — Nix 用户仓库及我自己的 NUR 仓库
- **tix** — Nix 语言服务器
- **nix-vscode-extensions** — VS Code 扩展集合
- **rime-wanxiang** — 万象拼音个人 fork，作为 fcitx5-rime 的共享 rime 数据

## 快速开始

所有命令在仓库根目录执行。使用 `just` 查看所有可用命令。

### Linux (NixOS)

```sh
# 测试配置（不添加启动项）
just test

# 切换到新配置
just deploy

# 调试模式（详细日志）
just debug

# 测试远程主机
just remote-test r9000p-nixos
```

### macOS (nix-darwin)

```sh
# 仅构建
just build

# 切换到新配置
just deploy

# 首次安装
just install-darwin
```

### Flake 管理

```sh
# 更新所有 flake 输入
just up

# 更新指定输入
just upp home-manager

# 更新 AI 工具（llm-agents 与 skills-catalog）
just up-ai

# 清理无用的 nix store 条目
just gc
```

## Dotfiles

Dotfiles 通过 Home Manager 声明式管理。模块 `home/base/core/dotfiles-linker.nix` 使用 `mkOutOfStoreSymlink` 将 `dotfiles/` 目录下的配置文件符号链接到 `~/.config/`（通过 `xdg.configFile`）和 `~/`（通过 `home.file`），并为 Linux 与 macOS 分别维护链接集合。这是 NixOS/nix-darwin 常规重建的一部分，无需单独的 stow 步骤。

> **注意：** 我已不再使用 Mac 设备，因此 Darwin (macOS) 配置可能存在问题或已过时。仅 NixOS Linux 主机在积极维护。

## 许可证

MIT — 详见 [LICENSE](./LICENSE)。
