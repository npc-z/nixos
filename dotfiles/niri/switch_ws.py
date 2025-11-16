"""
Switch niri workspaces by skip empty workspaces
"""

import json
import subprocess
import sys


def get_workspaces():
    result = subprocess.run(
        ["niri", "msg", "-j", "workspaces"], capture_output=True, text=True
    )
    return json.loads(result.stdout)


def focus_workspace(id_):
    subprocess.run(["niri", "msg", "action", "focus-workspace", str(id_)])


def main():
    if len(sys.argv) != 2 or sys.argv[1] not in ("up", "down"):
        print("Usage: niri-empty.py [up|down]")
        return

    direction = sys.argv[1]
    workspaces = get_workspaces()

    # 排序：根据 idx
    workspaces_sorted = sorted(workspaces, key=lambda w: w["idx"])

    # 当前的
    current = next(w for w in workspaces_sorted if w["is_focused"])
    current_idx = current["idx"]

    # 过滤出非空工作区
    non_empty = [w for w in workspaces_sorted if w["active_window_id"] is not None]

    if len(non_empty) <= 1:
        return  # 没有其他非空 workspace 可以跳

    # 找到当前在非空列表中的位置
    non_empty_idx_list = [w["idx"] for w in non_empty]

    # 当前在 non-empty 列表中的索引
    try:
        pos = non_empty_idx_list.index(current_idx)
    except ValueError:
        # 当前是空 workspace，就把它插入到列表中以便找到最近的跳转方向
        non_empty_idx_list_with_current = sorted(non_empty_idx_list + [current_idx])
        pos = non_empty_idx_list_with_current.index(current_idx)
        # 回退到离它最近的非空（向上或向下）
        if direction == "up":
            pos = max(0, pos - 1)
        else:
            pos = min(len(non_empty_idx_list_with_current) - 1, pos + 1)
        target_idx = non_empty_idx_list_with_current[pos]
        # 找 workspace id
        target_id = next(w["id"] for w in workspaces_sorted if w["idx"] == target_idx)
        focus_workspace(target_id)
        return

    # 正常情况：当前是非空 workspace
    if direction == "up":
        new_pos = (pos - 1) % len(non_empty)
    else:
        new_pos = (pos + 1) % len(non_empty)

    target_id = non_empty[new_pos]["id"]
    focus_workspace(target_id)


if __name__ == "__main__":
    main()
