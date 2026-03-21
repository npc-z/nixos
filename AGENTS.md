# AGENTS.md

Guidance for coding agents operating in this repository.
This repo is a Nix flake for NixOS and nix-darwin hosts, with Home Manager and dotfiles.

## Scope and priorities

- Keep changes declarative and host-aware.
- Prefer small, reviewable edits over broad rewrites.
- Do not introduce imperative setup scripts when a module option can express the same intent.
- Preserve existing behavior for hosts you are not actively changing.

## Repository map

- `flake.nix`: flake inputs and outputs wiring.
- `hosts/default.nix`: central host templates and host registration.
- `hosts/<host>/`: per-host `configuration.nix` and `home.nix`.
- `modules/`: reusable NixOS or Home Manager modules.
- `home/`: Home Manager feature modules.
- `overlays/`: package overlays.
- `nur/`: NUR integration.
- `dotfiles/`: stow-managed source dotfiles.
- `Justfile`: primary operator commands.

## Cursor and Copilot rules

- No `.cursorrules` file was found.
- No `.cursor/rules/` directory rules were found.
- No `.github/copilot-instructions.md` file was found.
- Follow this file and existing code patterns as the canonical guidance.

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

Native equivalents used by `Justfile`:

- `nh os test --ask .`
- `nh os switch --ask .`
- `nh os test --ask --verbose .`
- `nh os test --target-host=npc@<host> --hostname=<host> .`

### macOS (nix-darwin) workflows

- Build only: `just build`
- Deploy switch: `just deploy`

Native equivalents used by `Justfile`:

- `nh darwin build --ask .`
- `nh darwin switch --ask .`

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

### What to run before finishing a change

- If editing one host: run targeted `nix build` for that host.
- If editing shared module/template code: run builds for all affected hosts.
- If changing `flake.nix` inputs/outputs: run at least one Linux and one Darwin build when possible.

## Code style guidelines

## Nix formatting and structure

- Use 2-space indentation in `.nix` files.
- End files with a trailing newline.
- Keep attribute sets readable; group related options together.
- Prefer multi-line formatting when an attrset or list exceeds comfortable line length.
- Keep comments concise and only for non-obvious intent.

### Imports and module composition

- Add reusable logic in `modules/` or `home/`, not inside host files, when shared by multiple hosts.
- Keep host-specific details inside `hosts/<host>/`.
- When wiring modules, follow existing template style from `hosts/default.nix`.
- Thread shared values through `specialArgs` / `extraSpecialArgs` rather than hardcoding globals.
- Prefer explicit module imports over dynamic path tricks.

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
- Avoid introducing ad-hoc fetchers when a flake input is appropriate.
- Keep stable/unstable intent clear when selecting `nixpkgs` channels.
- Minimize cross-channel mixing unless required by package availability.

### Shell snippets inside Nix/Just

- Keep shell snippets POSIX-compatible unless Bash-only features are necessary.
- Quote paths that may contain spaces.
- Prefer idempotent commands for file operations.
- Do not embed destructive commands without strong justification.

## Change management expectations for agents

- Read nearby files before editing to match local patterns.
- Do not reformat unrelated files.
- Do not rename hosts, inputs, or module paths unless the task requires it.
- Do not remove comments or non-English text unless it is part of the requested change.
- When adding new commands/docs, keep them consistent with existing `just` and `nh` usage.

## Quick verification checklist

- `nix flake show` succeeds.
- Target host build succeeds.
- Updated files keep consistent style and indentation.
- No unrelated files were modified.
- Documentation reflects actual commands present in `Justfile`.

## Notes specific to this repository

- `just test` on Linux maps to `nh os test --ask .`.
- `just build` exists only for macOS (`nh darwin build --ask .`).
- Host definitions are centralized in `hosts/default.nix`.
- Home Manager is integrated via `inputs.home-manager.*Modules.home-manager` in templates.

When in doubt, prefer the smallest declarative change that can be validated with a targeted host build.
