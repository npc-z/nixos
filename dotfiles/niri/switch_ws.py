"""
Switch niri workspaces by skip empty workspaces
"""

import json
import subprocess
import sys
from dataclasses import dataclass
from typing import List, Optional


@dataclass
class Workspace:
    """niri workspace"""

    id: int
    idx: int
    name: str
    output: str
    is_urgent: bool
    is_active: bool
    is_focused: bool
    active_window_id: Optional[int] = None


def get_workspaces():
    """get workspaces"""

    result = subprocess.run(
        ["niri", "msg", "-j", "workspaces"], capture_output=True, text=True, check=True
    )

    val: list[dict] = json.loads(result.stdout)
    wss = [Workspace(**w) for w in val]

    return wss


def focus_workspace(ws: Workspace):
    """focus to workspace"""
    subprocess.run(["niri", "msg", "action", "focus-workspace", str(ws.id)], check=True)


def get_next_ws(workspaces: List[Workspace], direction: str):
    """获取目标 workspace"""

    # 排序：根据 idx
    workspaces_sorted = sorted(workspaces, key=lambda w: w.idx)

    # 当前的
    cur_ws = next(w for w in workspaces_sorted if w.is_focused)
    current_idx = cur_ws.idx

    # 过滤出非空工作区
    non_empty_wss = [w for w in workspaces_sorted if w.active_window_id is not None]
    non_empty_wss_cnt = len(non_empty_wss)

    if non_empty_wss_cnt < 1:
        # 没有其他非空 workspace 可以跳
        return None

    if non_empty_wss_cnt == 1 and non_empty_wss[0].idx != current_idx:
        return non_empty_wss[0]

    # 找到当前在非空列表中的位置
    non_empty_idx_list = [w.idx for w in non_empty_wss]

    # 当前在 non_empty_wss 列表中的索引
    try:
        pos = non_empty_idx_list.index(cur_ws.idx)
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
        target_ws = next(w for w in workspaces_sorted if w.idx == target_idx)
        return target_ws

    # 正常情况：当前是非空 workspace
    if direction == "up":
        new_pos = (pos - 1) % non_empty_wss_cnt
    else:
        new_pos = (pos + 1) % non_empty_wss_cnt

    target_ws = non_empty_wss[new_pos]
    return target_ws


def main():
    """main"""

    if len(sys.argv) != 2 or sys.argv[1] not in ("up", "down"):
        print("Usage: switch_ws.py [up|down]")
        return

    direction = sys.argv[1]
    workspaces = get_workspaces()

    target_ws = get_next_ws(workspaces, direction)
    if not target_ws:
        return

    focus_workspace(target_ws)


if __name__ == "__main__":
    main()
