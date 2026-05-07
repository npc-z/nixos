# npc 的 NixOS Flake 配置

[English](./README.md)

个人 Nix Flake，用于声明式管理 NixOS 和 nix-darwin 主机，通过 Home Manager 管理用户级配置。Dotfiles 通过 Home Manager 的 `mkOutOfStoreSymlink` 以符号链接方式部署。

## 主机列表

| 主机 | 类型 | 架构 | 说明 |
|---|---|---|---|
| `ser7-nixos` | NixOS | `x86_64-linux` | 迷你主机 (零刻 SER7) |
| `r9000p-nixos` | NixOS | `x86_64-linux` | 笔记本 (联想拯救者 R9000P) |
| `work-macbook-pro` | nix-darwin | `aarch64-darwin` | 工作用 MacBook Pro (Apple Silicon) — **已不再积极维护** |

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
│   ├── base/          # 所有主机共享
│   ├── linux/         # Linux 专属
│   └── darwin/        # macOS 专属
├── modules/           # NixOS / nix-darwin 模块
│   ├── base/          # 所有主机共享
│   ├── linux/         # Linux 专属
│   └── darwin/        # macOS 专属
├── overlays/          # 包覆盖层
├── nur/               # NUR (Nix 用户仓库) 集成
├── dotfiles/          # 通过 Home Manager 建立符号链接的 dotfile 源文件
├── lib/               # 辅助库函数
├── vars/              # 共享变量（用户名等）
├── user/              # 每个用户的配置片段
├── Justfile           # 任务运行器（类似 Makefile）
└── AGENTS.md          # 编码代理指导
```

## 主要 Flake 输入

- **nixpkgs** — `nixos-unstable`（最新滚动版本）
- **nixpkgs-stable** — `nixos-25.11`（稳定包）
- **home-manager** — 用户环境管理
- **nix-darwin** — macOS 系统管理
- **NUR** — Nix 用户仓库，提供社区软件包
- **zen-browser** — 来自 flake 的 Zen 浏览器

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

# 清理无用的 nix store 条目
just gc
```

## Dotfiles

Dotfiles 通过 Home Manager 声明式管理。模块 `home/base/core/dotfiles-linker.nix` 使用 `mkOutOfStoreSymlink` 将 `dotfiles/` 目录下的配置文件符号链接到 `~/.config/`（通过 `xdg.configFile`）和 `~/`（通过 `home.file`）。这是 NixOS/nix-darwin 常规重建的一部分，无需单独的 stow 步骤。

Justfile 中的 GNU Stow 命令为遗留方案，并非当前的主要机制。

> **注意：** 我已不再使用 Mac 设备，因此 Darwin (macOS) 配置可能存在问题或已过时。仅 NixOS Linux 主机在积极维护。

## 许可证

MIT — 详见 [LICENSE](./LICENSE)。
