# npc's NixOS Flake

[中文](./README.zh.md)

My personal Nix flake for declaratively managing NixOS and nix-darwin hosts, with Home Manager for user-level configuration. Dotfiles are symlinked into place via Home Manager's `mkOutOfStoreSymlink`.

## Hosts

| Host | Type | Architecture | Description |
|---|---|---|---|
| `ser7-nixos` | NixOS | `x86_64-linux` | Mini PC (Beelink SER7) |
| `r9000p-nixos` | NixOS | `x86_64-linux` | Laptop (Lenovo Legion R9000P) |
| `work-macbook-pro` | nix-darwin | `aarch64-darwin` | Work MacBook Pro (Apple Silicon) — **not actively maintained** |

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
│   ├── base/          # Shared across all hosts
│   ├── linux/         # Linux-only home configs
│   └── darwin/        # macOS-only home configs
├── modules/           # NixOS / nix-darwin modules
│   ├── base/          # Shared across all hosts
│   ├── linux/         # Linux-only modules
│   └── darwin/        # macOS-only modules
├── overlays/          # Package overlays
├── nur/               # NUR (Nix User Repository) integration
├── dotfiles/          # Dotfile sources symlinked via Home Manager
├── lib/               # Helper library functions
├── vars/              # Shared variables (username, etc.)
├── user/              # Per-user configuration fragments
├── Justfile           # Task runner commands (like Makefile)
└── AGENTS.md          # Guidance for coding agents
```

## Notable Flake Inputs

- **nixpkgs** — `nixos-unstable` (latest rolling release)
- **nixpkgs-stable** — `nixos-25.11` (for stable packages)
- **home-manager** — User environment management
- **nix-darwin** — macOS system management
- **NUR** — Nix User Repository for community packages
- **zen-browser** — Zen Browser from flake

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

# Garbage collect unused store entries
just gc
```

## Dotfiles

Dotfiles are managed declaratively through Home Manager. The module at `home/base/core/dotfiles-linker.nix` uses `mkOutOfStoreSymlink` to symlink config files from the `dotfiles/` directory into `~/.config/` (via `xdg.configFile`) and `~/` (via `home.file`). This is part of the normal NixOS/nix-darwin rebuild — no separate stow step needed.

The GNU Stow commands in the Justfile are legacy and not the primary mechanism.

> **Note:** I no longer use a Mac device, so the Darwin (macOS) configuration may be broken or out of date. Only the Linux NixOS hosts are actively maintained.

## License

This is my personal configuration. Feel free to reference and adapt.
