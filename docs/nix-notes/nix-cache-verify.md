# Nix 缓存命中验证与路径发现

记录与 "更新 flake 后如何确认能吃到官方二进制缓存" 相关的命令。
以 noctalia 为例(它的缓存来自 `noctalia.cachix.org`),其他带 cachix 缓存的输入同理。

## 前提:能命中缓存的条件

- 输入指向官方维护的 `cachix` 分支(noctalia: `github:noctalia-dev/noctalia/cachix`,该分支永远指向最新**已缓存**的 commit)
- 没有对输入做 `inputs.nixpkgs.follows`(官方文档明确:follows 会改变 derivation 哈希,导致缓存 miss)
- 缓存的 substituter + 公钥已配置(`flake.nix` 的 `nixConfig`,或系统配置 `nix.settings`,或 `/etc/nix/nix.conf`)
- flake 的 `nixConfig` 需要 `--accept-flake-config` 才会生效;接受过一次后保存在
  `~/.local/share/nix/trusted-settings.json`(按**值**匹配,`flake.nix` 里改过一次组合就要重新确认一次)
- 传递性 nixpkgs 锁与输入自身 `flake.lock` 保持一致(见下文"锁一致性")

## 验证 1:更新锁之后、构建之前,确认 derivation 是否在缓存里

```bash
# 在 flake 仓库目录下执行
nix build .#nixosConfigurations.ser7-nixos.config.home-manager.users.npc.programs.noctalia.package --dry-run
```

判断标准:

- `these N paths will be fetched` → 命中缓存,会下载
- `this derivation will be built` → 缓存 miss,会本地编译

注意:`--dry-run` 对**已在本地 store 中的路径是静默的**,所以只在
"更新了输入、新 derivation 还没进 store" 时才有效。

## 验证 2:直接向缓存查询 narinfo(不依赖本地状态)

```bash
# 1. 得到锁定输入的 derivation 及输出路径
nix derivation show "github:noctalia-dev/noctalia/<rev>#packages.x86_64-linux.default"
# 输出里找 outputs.out.path,形如 /nix/store/<hash>-noctalia-5.0.0

# 2. 用输出路径的 hash 段直接请求 narinfo
curl -o /dev/null -w "%{http_code}\n" "https://noctalia.cachix.org/<hash>.narinfo"
# 200 = 缓存里有这个 derivation;404 = 没有(锁不一致或 CI 未缓存)

# 3. 或者让 nix 直接查缓存
nix path-info --store "https://noctalia.cachix.org" /nix/store/<hash>-noctalia-5.0.0
```

## 路径组合规则(验证其他 App 时把 `<name>` 换掉)

| 声明位置                         | 路径模板                                                                                          |
| -------------------------------- | ------------------------------------------------------------------------------------------------- |
| home-manager 模块(用户级)        | `.#nixosConfigurations.<host>.config.home-manager.users.<user>.programs.<name>.<option>`          |
| NixOS 系统级模块                 | `.#nixosConfigurations.<host>.config.<模块路径>`(如 `services.foo`、`environment.systemPackages`) |
| 独立的 `homeConfigurations` 输出 | `.#homeConfigurations.<name>.config...`(本仓库没有,home-manager 作为 NixOS 模块接线)              |

`<host>` = `hosts/default.nix` 里注册的主机名(如 `ser7-nixos`、`r9000p-nixos`)。
本仓库用户为 `npc`。

## 发现命令(不用手拼路径)

```bash
# 列出全部 home-manager 模块名(含未启用的)
nix eval .#nixosConfigurations.ser7-nixos.config.home-manager.users.npc.programs --apply builtins.attrNames

# 确认某个 App 是否有该模块且路径正确(报错 = 不存在)
nix eval .#nixosConfigurations.ser7-nixos.config.home-manager.users.npc.programs.hyprland.enable

# 查看某模块暴露了哪些选项
nix eval .#nixosConfigurations.ser7-nixos.config.home-manager.users.npc.programs.hyprland --apply builtins.attrNames
```

## 锁一致性检查(缓存 miss 的常见历史原因)

noctalia 的 flake 用未固定的 tarball URL 作为 nixpkgs 输入。若传递性锁
(`flake.lock` 里的 `nixpkgs_5`)与该 commit 自身 `flake.lock` 固定的版本不一致,
derivation 哈希就与 CI 不同,缓存必然 miss。

```bash
# 本仓库锁里的 noctalia + 传递 nixpkgs
nix flake metadata . | rg -A3 noctalia

# 该 commit 自身锁定的 nixpkgs(应一致)
curl -sL "https://raw.githubusercontent.com/noctalia-dev/noctalia/<rev>/flake.lock" | python3 -c "import json,sys; print(json.load(sys.stdin)['nodes']['nixpkgs']['locked']['rev'])"
```

修复方式:再跑一次 `just upp noctalia`(现版本 nix 会正确重锁传递输入),或 `just up`。

## 常见坑

- `nixConfig` 信任按值匹配:改动 `extra-substituters` 组合后会重新弹确认,与"以前构建过"无关
- 不要在别的 flake 目录下跑 `.#...` 命令——会解析到那个项目的配置(路径对不上或弹奇怪的缓存确认)
- 远端构建(`remote-test`)用的 `nixos-rebuild` 默认不传 `--accept-flake-config`,flake 的 nixConfig 不会生效
- 换 `nixos-rebuild` 不会改变缓存行为:它和 `nh` 走同一套 nix 与 flake nixConfig
