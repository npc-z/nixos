# fix darwin nix-daemon

```log
---- warning! ------------------------------------------------------------------
Nix already appears to be installed. This installer may run into issues.
If an error occurs, try manually uninstalling, then rerunning this script.


Uninstalling nix:
1. Restore /etc/bashrc.backup-before-nix back to /etc/bashrc

  sudo mv /etc/bashrc.backup-before-nix /etc/bashrc

(after this one, you may need to re-open any terminals that were
opened while it existed.)

2. Restore /etc/zshrc.backup-before-nix back to /etc/zshrc

  sudo mv /etc/zshrc.backup-before-nix /etc/zshrc

(after this one, you may need to re-open any terminals that were
opened while it existed.)

3. Delete the files Nix added to your system:

  sudo rm -rf "/etc/nix" "/nix" "/var/root/.nix-profile" "/var/root/.nix-defexpr" "/var/root/.nix-channels" "/var/root/.local/state/nix" "/var/root/.cache/nix" "/Users/npc/.nix-profile" "/Users/npc/.nix-defexpr" "/Users/npc/.nix-channels" "/Users/npc/.local/state/nix" "/Users/npc/.cache/nix"

and that is it.


---- oh no! --------------------------------------------------------------------
I back up shell profile/rc scripts before I add Nix to them.
I need to back up /etc/bashrc to /etc/bashrc.backup-before-nix,
but the latter already exists.

Here's how to clean up the old backup file:

1. Back up (copy) /etc/bashrc and /etc/bashrc.backup-before-nix
   to another location, just in case.

2. Ensure /etc/bashrc.backup-before-nix does not have anything
   Nix-related in it. If it does, something is probably quite
   wrong. Please open an issue or get in touch immediately.

3. Once you confirm /etc/bashrc is backed up and
   /etc/bashrc.backup-before-nix doesn't mention Nix, run:
   mv /etc/bashrc.backup-before-nix /etc/bashrc

We'd love to help if you need it.

You can open an issue at
https://github.com/NixOS/nix/issues/new?labels=installer&template=installer.md

Or get in touch with the community: https://nixos.org/community
  ~ took 1h18m28s 
 |

```

## 执行安装 nix 时, 安装脚本没有足够的权限, 需要抹掉 nix 磁盘分区

以下为执行 install nix

```sh
sh <(curl -L https://nixos.org/nix/install) --daemon
```

安装脚本时遇到的错误

```log
---- sudo execution ------------------------------------------------------------
I am executing:

    $ sudo /usr/sbin/chown -R root:nixbld /nix

to take root ownership of existing Nix store files

chown: /nix/.Spotlight-V100: Operation not permitted
chown: /nix/.Spotlight-V100: Operation not permitted
chown: /nix/.Trashes: Operation not permitted
chown: /nix/.Trashes: Operation not permitted
^C
---- oh no! --------------------------------------------------------------------
Oh no, something went wrong. If you can take all the output and open
an issue, we'd love to fix the problem so nobody else has this issue.

:(

We'd love to help if you need it.

You can open an issue at
https://github.com/NixOS/nix/issues/new?labels=installer&template=installer.md

Or get in touch with the community: https://nixos.org/community
npc@work-macbook-pro ~ % ll /nix
```

## SSL cert problem

https://github.com/NixOS/nix/issues/2899

solution:
https://github.com/NixOS/nix/issues/2899#issuecomment-1669501326

This helped me as well. There was a broken symbolic link, probably from my previous nix-darwin install, which I ditched for just the raw nix.
Just to save everyone a click:

```bash
sudo rm /etc/ssl/certs/ca-certificates.crt
sudo ln -s /nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt /etc/ssl/certs/ca-certificates.crt
```

## mkdir fails with 'Operation not permitted' for some packages during build

https://github.com/LnL7/nix-darwin/issues/1315

solution
https://github.com/LnL7/nix-darwin/issues/1315#issuecomment-2655346461

I had the same issue right after upgrading my Mac and using native nix installer (vs determinate previously). I've added nix to the "allow full disk access" security list and it worked. I didn't use the overlay.
