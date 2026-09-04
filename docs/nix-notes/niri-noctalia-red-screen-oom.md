# niri + noctalia 隔夜红屏无法解锁排查

> 场景：`niri` + `noctalia` 锁屏，隔夜后变红屏无法解锁，重启前 `hyprlock` 也出现同现象。主机 `ser7-nixos`（AMD GPU），`niri 26.04`。

## 现象
- 晚间 `22:50:47` 正常锁屏，次日 `05:08` 后唤醒显示纯红/灰，键盘无响应，无法输入密码，只能 `REISUB`/硬重启。
- `journalctl` 显示锁后 `LockedHint=yes` 但锁客户端已退出，`niri` 回落到红色兜底。

## 时间线（2026-08-28 ~ 08-29）

| 时间 | 事件 | 来源 |
|---|---|---|
| 22:50:47 | `niri[3646]: INFO niri::niri: locking session` | `journalctl -b -1` |
| 05:08:41 | `kernel: oom-kill task=WeChatAppEx pid=12763 task_memcg=.../app-niri-noctalia-3722.scope` | `journalctl -b -1` |
| 05:08:42 | `systemd[2088]: app-niri-noctalia-3722.scope: Failed with result 'oom-kill' Consumed 7.3G mem peak, 10.8G swap peak` | `journalctl -b -1` |
| 05:09:41 | `systemd-coredump: Process 124273 (electron) SIGILL` | `coredumpctl` |
| 05:09:43 | `app-splayer-124273.scope: 495M mem, 219M swap` | `journalctl` |
| 09:18:16 | `niri: pausing session` + `login: gkr-pam unlocked` | 唤醒 |
| 09:19:07 | `niri: quitting due to SIGTERM` 重启 | `journalctl` |

## 根因拆解

### 1. 主因：`noctalia` 内存泄漏被 OOM 杀掉，`niri` 无锁客户端 -> 红屏
- `dotfiles/niri/config.kdl:117` `spawn-at-startup "noctalia"` + `home/linux/gui/wm/addons/noctalia.nix:6` `programs.noctalia.enable=true`
- `noctalia` 常驻 2 天，`7.3G/10.8G` 远超 `splayer 0.5G`。`dotfiles/noctalia/settings.json:397` `plugin:fancy-audiovisualizer` + `quickshell` 动画在 `11h CPU` 后泄漏。
- `niri` 的 `ext-session-lock-v1` 约定：客户端崩溃即红屏，不自动解锁。

### 2. 次因：`hyprlock` 缺 PAM，鉴权永远失败
- `home/linux/gui/wm/addons/hyprlock.nix:12` 仅 `home-manager programs.hyprlock.enable`，不会创建 `/etc/pam.d/hyprlock`。
- 实测 `ls /etc/pam.d` 只有 `swaylock`（`modules/linux/desktop/swaylock.nix:19` 生成），`cat /etc/pam.d/hyprlock` -> `No such file`。
- NixOS 需 `security.pam.services.hyprlock.enable = true`（`<nixpkgs/nixos/modules/programs/wayland/hyprlock.nix>`），缺失时红屏停留。

### 3. 竞争：多锁源
- `dotfiles/noctalia/settings.json:544` `idle.lockCommand="hyprlock" lockTimeout=600` 与 `dotfiles/noctalia/settings.toml:48` `timeout=3600` 双配置。
- `dotfiles/swayidle/config:4` `timeout 605 hyprlock` 仍被 `home/base/core/dotfiles-linker.nix:57` 链接，但 `home/linux/gui/wm/addons/swayidle.nix:2` 仅装包无服务，`dotfiles/niri/config.kdl:123` `spawn swayidle` 已注释 -> 实为 `noctalia idle` 单源，易误判。

### 4. `hyprlock.conf` 变量未定义
- `dotfiles/hypr/.config/hypr/hyprlock.conf:33` `color=$clockm/$white/$border` 无定义（依赖 Hyprland 主题注入），`hyprlock -v` 报错时回落红屏。
- `background.path = ~/.config/wallpapers/cyberpunk-...` 存在但模糊参数 `blur_size=4` 在 GPU 恢复失败时也触发。

### 5. 共犯：`splayer` 的角色
- `home/linux/gui/misc.nix:26` `splayer 3.1.1 / electron 41.10.6`，`dotfiles/niri/config.kdl:434` 桌面歌词常驻。
- 历史峰值 `500M~1.1G`（`08-26 773M, 07-06 1006M`），本次 `495M` 非主泄。`05:09 SIGILL` 是 OOM 后 `electron` 内存损坏，非泄漏源头。
- 合力：`user@1000 8.7G/21.6G` + `niri 941M/9.8G swap` + `zramSwap 5.7G` `modules/linux/base/zram.nix:7`，压爆后先杀最大 `noctalia`。

## 误判澄清
> “`splayer` 直泄到 7G” 不成立。`splayer` 是贡献者（常驻 lyric）+ 受害者（OOM 后 coredump），主泄是 `noctalia`。

## 复现与取证命令

```bash
# 锁与 OOM
journalctl -b -1 --no-pager | grep -E 'locking|oom-kill|noctalia' | tail -n 50
journalctl --user --no-pager | grep -i splayer | tail -n 30
coredumpctl info 124273
coredumpctl list --no-pager | head -n 20

# PAM
ls -l /etc/pam.d/ | grep -E 'hypr|sway'
cat /etc/pam.d/hyprlock; cat /etc/pam.d/swaylock

# 内存
free -h; zramctl; systemd-cgtop --cpu=memory -n 1 -b
ps aux --sort=-%mem | head -n 20
cat /proc/meminfo | head -n 20

# 锁配置
cat dotfiles/noctalia/settings.json | jq .idle
cat dotfiles/noctalia/settings.toml | grep -A5 idle
cat dotfiles/swayidle/config
cat dotfiles/hypr/.config/hypr/hyprlock.conf
hyprlock -v 2>&1 | head -n 20
```

## 修复（最小声明式改动）

### A. 三选一锁（推荐保留 noctalia 锁屏）
```nix
# home/linux/gui/wm/addons/noctalia.nix
programs.noctalia.settings.idle.enabled = false; # 若用 hyprlock，接管 idle
# 或反向：禁 hyprlock，靠 noctalia 自带锁
# wm.addons.hyprlock.enable = false;
```

### B. 补 PAM（若保留 hyprlock）
```nix
# modules/linux/desktop/security.nix:15
security.pam.services.hyprlock.enable = true;
# 或 security.pam.services.hyprlock.text = "auth include login\n...";
```

### C. 清理 swayidle 残留
```bash
rm dotfiles/swayidle/config # 或改为 systemd 管理
# home/linux/gui/wm/addons/swayidle.nix 补 services
```

### D. 修 hyprlock.conf
补全变量或改用 `programs.hyprlock.settings` 声明式配置，避免 `$white` 未定义。

### E. 抑制泄漏
- 禁 `fancy-audiovisualizer`：`dotfiles/noctalia/settings.json:397` / `dotfiles/noctalia/plugins.json`
- `splayer` 桌面歌词：注释 `dotfiles/niri/config.kdl:434` 或切 `gapless` `home/linux/gui/misc.nix:23`
- 限制：`systemctl --user edit noctalia` / `app-splayer` 加 `MemoryMax=2G MemoryHigh=1.5G Restart=on-failure`
- 更新：`just upp noctalia` + `nixpkgs` 到新 `electron`（`splayer` 3.1.1 已旧）

## 预防监控

```bash
# 常驻观察
journalctl --user -f | grep -E 'noctalia|splayer|hyprlock'
watch -n 5 'ps aux --sort=-%mem | head -n 15; echo "---"; free -h'
# 阈值告警（可选 systemd）
# /etc/systemd/system/user@1000.service.d/limits.conf: MemoryMax=10G
```

## 附录：关键文件索引

| 文件 | 作用 |
|---|---|
| `dotfiles/niri/config.kdl:117,123,434` | 启动项、歌词窗口 |
| `home/linux/gui/wm/niri/default.nix:27,35` | 启用 hyprlock/noctalia |
| `home/linux/gui/wm/addons/hyprlock.nix:1` | home-manager 锁 |
| `home/linux/gui/wm/addons/noctalia.nix:1` | noctalia 模块 |
| `modules/linux/desktop/swaylock.nix:1` | swaylock PAM 范例 |
| `modules/linux/desktop/security.nix:1` | 补 hyprlock PAM 位置 |
| `modules/linux/base/zram.nix:7` | zram 5.7G |
| `flake.nix:79` | noctalia cachix 输入 |

## 常见坑
- `programs.hyprlock.enable` != `security.pam.services.hyprlock.enable`，前者不管 PAM。
- `noctalia` `settings.json` 与 `settings.toml` 并存时以 `toml` 为主，`json` 的 600s 不生效。
- `electron` `SIGILL` 多为 OOM 内存损坏，非代码非法指令。
- `dry-run` 缓存误报见 `docs/nix-notes/nix-cache-verify.md` 的 `narinfo-cache-negative-ttl 0`。
