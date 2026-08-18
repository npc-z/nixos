# AGENTS.md

## you are not allowed

- DO NOT `grep` OR `rg` IN `/nix/store/` ROOT PATH TO FIND SOMETHING! Query `/nix/store/` via the nix MCP store tools instead.
- DO NOT SPAWN SUBAGENT TO WORK! Do the work directly in this session.

Guidance for coding agents operating in this repository.
This repo is a Nix flake for NixOS and nix-darwin hosts, with Home Manager and dotfiles.

## Scope and priorities

- Keep changes declarative and host-aware.
- Prefer module options over imperative setup scripts.
- Preserve existing behavior for hosts you are not actively changing.

## Repository map

- `flake.nix`: flake inputs and outputs wiring.
- `hosts/default.nix`: central host templates, host registration, and Home Manager wiring (`inputs.home-manager.*Modules.home-manager`).
- `hosts/<host>/`: per-host `configuration.nix` and `home.nix`.
- `modules/`: reusable NixOS or Home Manager modules.
- `home/`: Home Manager feature modules.
- `overlays/`: package overlays.
- `nur/`: NUR integration.
- `dotfiles/`: stow-managed source dotfiles.
- `Justfile`: primary operator commands.

## Build, lint, and test commands

This repository does not use a classic app test runner (no pytest/jest/go test setup in root).
Validation is done by evaluating and building flake outputs.

### Preferred command entrypoint

- List tasks: `just`
- Use `just` recipes first when available.

### Linux (NixOS) workflows

- Test activation (does not add boot entry): `just test`
- Deploy switch: `just deploy`
- Debug test with verbose logs: `just debug`
- Remote host test: `just remote-test <host>`

### macOS (nix-darwin) workflows

- Build only: `just build`
- Deploy switch: `just deploy`

### Flake checks and targeted builds

- Evaluate flake outputs quickly: `nix flake show`
- Update all inputs: `just up`
- Update one input: `just upp <input>`

Build a single host output (closest equivalent to running a single test target):

- NixOS host:
  `nix build .#nixosConfigurations.<host>.config.system.build.toplevel`
- Darwin host:
  `nix build .#darwinConfigurations.<host>.system`

Examples:

- `nix build .#nixosConfigurations.r9000p-nixos.config.system.build.toplevel`
- `nix build .#darwinConfigurations.work-macbook-pro.system`

## Code style guidelines

### Nix formatting and structure

- Use `alejandra` as the formatter for `nix` files.
- Group related options together.
- Keep comments concise and only for non-obvious intent.

### Imports and module composition

- Add reusable logic in `modules/` or `home/`, not inside host files, when shared by multiple hosts.
- Keep host-specific details inside `hosts/<host>/`.
- When wiring modules, follow existing template style from `hosts/default.nix`.
- Thread shared values through `specialArgs` / `extraSpecialArgs` rather than hardcoding globals.

### Naming conventions

- Use `camelCase` for Nix variables and local bindings.
- Use descriptive names (`darwinTemplate`, `specialArgs`, `linux-system` style already exists).
- Keep host directories and host keys aligned and explicit.
- Use stable, predictable names for options and avoid abbreviations unless already established.

### Types and option definitions

- In custom module options, define explicit types with `lib.types.*`.
- Provide sane defaults using `lib.mkDefault` where appropriate.
- Use `lib.mkEnableOption` for feature toggles.
- Use `lib.mkIf` to gate conditional config.
- Use `lib.mkMerge` for composing multiple conditional fragments.

### Error handling and conflict resolution

- Prefer resolving conflicts structurally (conditional modules, ordering) before forcing values.
- Use `lib.mkForce` only when a true override is required and document why.
- Avoid silent fallbacks that hide evaluation problems.
- For failures, reproduce with a targeted `nix build` and then use verbose command variants.

### Package and dependency practices

- Declare dependencies through flake inputs and follow existing `inputs.<name>.follows` patterns.
- Use a flake input instead of an ad-hoc fetcher.
- Keep stable/unstable intent clear when selecting `nixpkgs` channels.
- Minimize cross-channel mixing unless required by package availability.

### Shell snippets inside Nix/Just

- Keep shell snippets POSIX-compatible unless Bash-only features are necessary.
- Quote paths that may contain spaces.
- Prefer idempotent commands for file operations.
- Embed destructive commands only with strong justification.

## Change management expectations for agents

- Read nearby files before editing to match local patterns.
- Reformat only the files a change touches.
- Rename hosts, inputs, or module paths only when the task requires it.
- Remove comments or non-English text only when the requested change requires it.
- When adding new commands/docs, keep them consistent with existing `just` and `nh` usage.
- Before evaluating or building, `git add` newly created Nix files (existing files are already tracked).

## Quick verification checklist

- `nix flake show` succeeds.
- Target host build succeeds:
  - one host: that host only
  - shared module/template code: all affected hosts
  - `flake.nix` inputs/outputs: one Linux and one Darwin build when possible
- Updated files keep consistent style and indentation.
- No unrelated files were modified.
- Documentation reflects actual commands present in `Justfile`.

When in doubt, prefer the smallest declarative change that can be validated with a targeted host build.