# npc's NixOS Flake

[中文](./README.zh.md)

My personal Nix flake for declaratively managing NixOS and nix-darwin hosts, with Home Manager for user-level configuration. Dotfiles are symlinked into place via Home Manager's `mkOutOfStoreSymlink`.

Both NixOS hosts run Wayland desktops (Hyprland and niri with the Noctalia shell).

## Hosts

| Host               | Type       | Architecture     | Description                                                    |
| ------------------ | ---------- | ---------------- | -------------------------------------------------------------- |
| `ser7-nixos`       | NixOS      | `x86_64-linux`   | Mini PC (Beelink SER7, AMD)                                    |
| `r9000p-nixos`     | NixOS      | `x86_64-linux`   | Laptop (Lenovo Legion R9000P, AMD)                             |
| `work-macbook-pro` | nix-darwin | `aarch64-darwin` | Work MacBook Pro (Apple Silicon) — **not actively maintained** |

## Highlights

- **Wayland desktops**: Hyprland and niri (scrollable tiling) share addons like hyprlock, swayidle and the Noctalia shell
- **AI coding agents**: opencode, codex, deepseek, herdr and pi, plus an agent skills catalog in `agent-skills/`
- **Chinese input**: fcitx5 + rime with the wanxiang (万象拼音) fork and an optional grammar model
- **Declarative dotfiles**: config files symlinked from `dotfiles/` through Home Manager — no separate stow step

## Repository Structure

```
.
├── flake.nix          # Flake entry point: inputs, outputs, nixConfig
├── flake.lock         # Locked flake dependencies
├── hosts/             # Per-host configurations
│   ├── default.nix    # Template definitions for hosts
│   ├── ser7/          # Mini PC config
│   ├── r9000p/        # Laptop config
│   └── work-macbook-pro/  # macOS config
├── home/              # Home Manager modules
│   ├── base/          # Shared across all hosts (core / gui / tui)
│   ├── linux/         # Linux-only home configs
│   └── darwin/        # macOS-only home configs
├── modules/           # NixOS / nix-darwin modules
│   ├── base/          # Shared across all hosts
│   ├── linux/         # Linux-only modules
│   └── darwin/        # macOS-only modules
├── overlays/          # Package overlays
├── nur/               # NUR (Nix User Repository) integration
├── dotfiles/          # Dotfile sources symlinked via Home Manager
├── agent-skills/      # Skills catalog flake for AI agents
├── docs/              # Notes and documentation (e.g. nix-notes)
├── lib/               # Helper library functions
├── vars/              # Shared variables (username, etc.)
├── Justfile           # Task runner commands (like Makefile)
└── AGENTS.md          # Guidance for coding agents
```

## Notable Flake Inputs

Core:

- **nixpkgs** — `nixos-unstable` (latest rolling release)
- **nixpkgs-stable** — `nixos-26.05` (stable packages, exposed as `pkgs.stable`)
- **home-manager** — User environment management
- **nix-darwin** + **nix-homebrew** — macOS system management (Apple Silicon, with Rosetta)

Desktop / WM:

- **hyprland-contrib** — Community scripts and utilities for Hypr projects
- **hyprland-scroll-overview** — Scrollable workspace overview plugin (like niri)
- **noctalia** — Quickshell-based desktop shell for Wayland (cachix branch)
- **zen-browser** — Zen Browser

AI tooling:

- **llm-agents** — Nix packages for AI coding agents and development tools
- **skills-catalog** — Local agent skills catalog flake (`agent-skills/`)

Other:

- **NUR** + **nur-npc-z** — Nix User Repository and my own NUR repo
- **tix** — Nix language server
- **nix-vscode-extensions** — VS Code extension set
- **rime-wanxiang** — Personal wanxiang (万象拼音) fork, used as shared rime data for fcitx5-rime

## Quick Start

All commands are run from the repository root. Use `just` to see available recipes.

### Linux (NixOS)

```sh
# Test a configuration (does not add boot entry)
just test

# Switch to the configuration
just deploy

# Debug with verbose logs
just debug

# Test a remote host
just remote-test r9000p-nixos
```

### macOS (nix-darwin)

```sh
# Build only
just build

# Switch to the configuration
just deploy

# First-time install
just install-darwin
```

### Flake Management

```sh
# Update all flake inputs
just up

# Update a specific input
just upp home-manager

# Update AI tools (llm-agents and skills-catalog)
just up-ai

# Garbage collect unused store entries
just gc
```

## Dotfiles

Dotfiles are managed declaratively through Home Manager. The module at `home/base/core/dotfiles-linker.nix` uses `mkOutOfStoreSymlink` to symlink config files from the `dotfiles/` directory into `~/.config/` (via `xdg.configFile`) and `~/` (via `home.file`), with separate link sets for Linux and macOS. This is part of the normal NixOS/nix-darwin rebuild — no separate stow step needed.

> **Note:** I no longer use a Mac device, so the Darwin (macOS) configuration may be broken or out of date. Only the Linux NixOS hosts are actively maintained.

## License

MIT — see [LICENSE](./LICENSE).
