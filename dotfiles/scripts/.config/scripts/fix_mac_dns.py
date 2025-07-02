"""
usage:

将以下内容写入这个文件
~/Library/LaunchAgents/fixDns.plist


```text
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>fixDns</string>
    <key>ProgramArguments</key>
    <array>
        <string>/run/current-system/sw/bin/python3</string>
        <string>~/.config/scripts/fix_mac_dns.py</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>/tmp/fix-mac-dns.stdout.log</string>
    <key>StandardErrorPath</key>
    <string>/tmp/fix-mac-dns.stderr.log</string>
</dict>
</plist>
```

加载服务
launchctl load fixDns.plist

卸载服务
launchctl unload fixDns.plist


"""


import time
import subprocess
from typing import List
from datetime import datetime


def log(*args, **kw):
    now = datetime.now()
    print(now, *args, **kw)


WORK_DNS = "192.168.10.1"

get_dns_cmd = "networksetup -getdnsservers Wi-Fi".split()
log(f"{get_dns_cmd=}")
set_dns_cmd = 'networksetup -setdnsservers Wi-Fi 192.168.10.1 8.8.8.8 8.8.4.4'.split()
log(f"{set_dns_cmd=}")


def run_cmd(cmd: List[str]):
    """run the cmd"""
    cp = subprocess.run(
        cmd,
        # cwd=project_path,
        check=True,
        text=True,
        stdout=subprocess.PIPE,  # 使用PIPE捕获输出
    )
    return cp


def fix_dns():
    "fix dns with work env"
    while True:
        time.sleep(10)
        cp = run_cmd(get_dns_cmd)
        cur_dns = cp.stdout.splitlines()
        log(f"{cur_dns=}")
        if WORK_DNS not in cur_dns and run_cmd(set_dns_cmd).returncode == 0:
            log("DNS 已修复")


fix_dns()
