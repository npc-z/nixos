import subprocess
import time
from datetime import datetime

detected_count = 0


def check_network():
    """
    通过 ping 测试网络连接，如果能 ping 通，返回 True，否则返回 False。
    """
    global detected_count
    try:
        now = datetime.now()
        # Ping Google DNS server to check for network connectivity
        result = subprocess.run(
            ["ping", "-c", "1", "8.8.8.8"],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
        print(f"{now} - ping: {result=}, {detected_count=}")
        if result.returncode == 0:
            detected_count = 0
        else:
            detected_count += 1

        return result.returncode == 0
    except Exception as e:
        print(f"Error checking network connectivity: {e}")
        return False


def kill_v2raya():
    try:
        # 使用 pkill 命令结束 v2raya 进程
        subprocess.run(["sudo", "pkill", "-f", "v2raya"], check=True)
        print("v2raya process killed.")
    except subprocess.CalledProcessError as e:
        print(f"Error killing v2raya: {e}")


def monitor_network():
    while True:
        if not check_network() and detected_count % 4 == 0:
            print("Network connection lost. Killing v2raya...")
            kill_v2raya()
            break
        time.sleep(4)


if __name__ == "__main__":
    monitor_network()
