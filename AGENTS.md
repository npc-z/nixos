# AGENTS.md

Nix flake for NixOS and nix-darwin hosts, with Home Manager modules and stow-managed dotfiles.

## Environment rules

- Store paths come from nix (`nix eval … --print-out-paths`, `nix path-info`, `nix-store -q`) or the nix MCP store tools, not from scanning `/nix/store/` root.

## Repository map

- `flake.nix`: flake inputs and outputs wiring.
- `hosts/default.nix`: host templates, host registration, Home Manager wiring, and the `specialArgs` (`inputs`, `mylib`, `myvars`) every module receives.
- `hosts/<host>/`: one directory per host, holding `configuration.nix` (system) and `home.nix` (Home Manager).
- `modules/`: reusable system modules (NixOS / nix-darwin). `home/`: reusable Home Manager modules.
- `overlays/`: package overlays. `nur/`: NUR integration. `dotfiles/`: stow-managed sources.
- `vars/default.nix`: `myvars` — username, email, and the repo paths (`thisRepoPathAtNixos` / `…AtDarwin` are hardcoded to the local layout).
- `lib/default.nix`: `mylib` helpers, described below.
- `Justfile`: operator commands; `just` lists them.

### mylib helpers

- `mylib.scanPaths ./dir` — the module auto-import list: every `.nix` file directly in `dir` except `default.nix`, plus every subdirectory (imported as its `default.nix`). One level deep, so `imports = mylib.scanPaths ./.;` wires in a new sibling file with no other edit, and `default.nix` stays free for the shared config.
- `mylib.relativeToRoot "path"` — path relative to the repo root, used by host files to import modules.
- `mylib.dotfiles {inherit config myvars pkgs;}` — `linkFile "path"` and `linkDir "path"` (recursive) produce `home.file` / `xdg.configFile` entries as out-of-store symlinks into `dotfiles/`, so edits apply without a rebuild.

## Validation

There is no unit-test suite; validation means evaluating and building flake outputs.

- Linux: `just test` activates without adding a boot entry, `just deploy` switches, `just debug` adds verbose logs.
- macOS: `just build`, `just deploy`.
- Flake inputs: `just up`, `just upp <input>`.
- One host: `nix build .#nixosConfigurations.ser7-nixos.config.system.build.toplevel` (or `r9000p-nixos`), `nix build .#darwinConfigurations.work-macbook-pro.system`.
- Remote hosts: `just build-for-remote <host>`, `just build-by-remote <host>`.
- Darwin on Linux: `just check-darwin` evaluates and instantiates the aarch64-darwin graph, which catches assertions and Linux-only packages; a real darwin build needs a macOS runner or remote builder.
- Options and units: `nix eval .#nixosConfigurations.<host>.config…` for the effective value; Home Manager ones sit under `home-manager.users.<user>`.

## Code style

### Formatting

- Run `alejandra` on the files a change touches.

### Modules and option wiring

- Name custom options `modules.<feature>.*`. System and Home Manager scopes share the namespace but evaluate separately: `configuration.nix` sets system options, `home.nix` sets Home Manager ones, and Home Manager cannot read system options — pass them through `extraSpecialArgs`.
- Keep reusable logic in `modules/` and `home/`; host-specific values stay in `hosts/<host>/`.
- Follow the template style in `hosts/default.nix`, and thread shared values through `specialArgs` / `extraSpecialArgs` instead of hardcoding globals.
- Prefer module options over imperative setup scripts.
- Keep changes declarative and host-aware, and preserve behavior on hosts the change does not target.

### Options

- Group related options together, under one `modules.<feature>` attribute set.
- Give custom options an explicit `lib.types.*` type, a description, and a default (`lib.mkDefault` where a host should be able to override it).
- Use `lib.mkEnableOption` for feature toggles, `lib.mkIf` to gate conditional config, `lib.mkMerge` to compose conditional fragments.
- Resolve conflicts structurally (conditional modules, ordering) before forcing values; `lib.mkForce` earns its place only for a true override, with a comment saying why.
- Fail loudly on bad input rather than falling back silently.
- Reproduce evaluation failures with a targeted `nix build`, then add verbosity.

### Naming

- `camelCase` for Nix variables and local bindings.
- Descriptive names; the existing templates are the reference.
- Keep host directory names and flake host keys aligned (`ser7/` ↔ `ser7-nixos`).
- Stable, predictable option names; abbreviate only where the repo already does.

### Packages and dependencies

- Depend on flake inputs rather than ad-hoc fetchers, following the existing `inputs.<name>.follows` patterns.
- Keep stable/unstable intent clear, and minimize cross-channel mixing unless package availability requires it.

### Shell snippets inside Nix or Just

- POSIX-compatible unless Bash-only features are necessary; quote paths that may contain spaces; prefer idempotent file operations. Destructive commands need strong justification.

## Change management

- Read nearby files first, and match the local patterns.
- Keep this file's command list matching the `Justfile`.
- Keep host keys, input names, and module paths stable; rename only when the task requires it.
- Preserve existing comments, including the Chinese ones, and keep comments concise and for non-obvious intent.
- `git add` newly created Nix files before evaluating or building — flakes do not see untracked files.

## Verification checklist

- `nix flake show` succeeds.
- The target host builds; a shared module or template builds on every affected host; a `flake.nix` input or output change builds one Linux and one Darwin host where possible.
- Option, unit, and activation changes show the expected evaluated value, not just a successful build.
- Touched files are `alejandra`-clean, and no unrelated file changed.

When in doubt, prefer the smallest declarative change that can be validated with a targeted host build.
