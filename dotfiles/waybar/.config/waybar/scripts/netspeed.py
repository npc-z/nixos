import json
import sys
import time
from typing import Tuple, Union

UNITS = "BKMGTPEZY"


def filesize_ex(size: int) -> Tuple[Union[float, int], str]:
    left: Union[int, float] = abs(size)
    unit = 0
    n = len(UNITS)
    while left > 1100 and unit < n:
        left = left / 1024
        unit += 1
    else:
        if size < 0:
            left = -left
        return left, UNITS[unit]


def get_data():
    iface = None

    with open("/proc/net/route") as f:
        next(f)  # skip header
        for line in f:
            dev, route, *_ = line.split()
            if route == "00000000":
                iface = dev
                break

    if not iface:
        return

    iface += ":"
    with open("/proc/net/dev") as f:
        next(f)
        next(f)
        for line in f:
            data = line.split()
            dev, recv, *_ = data
            send = data[9]
            if dev == iface:
                return int(recv), int(send)


COLORS = {
    "": "gray",
    "K": "#5798d9",
    "M": "#57d977",
}


def format_size(s):
    f, u = filesize_ex(s)
    if u:
        t = f"{f:.1f}{u}"
    else:
        t = f"{f}"
    return f"{t:6}"


def gen_text():
    last_recv = last_send = None

    while True:
        data = get_data()
        time.sleep(1)
        if not data:
            last_recv = last_send = None
            yield '<span color="#992525">(No network)</span>'
            continue

        recv, send = data

        if last_recv is not None:
            down = format_size(recv - last_recv)
            up = format_size(send - last_send)
            yield f"↓{down} ↑{up}"
        else:
            yield "(init)"

        last_recv = recv
        last_send = send


def main():
    output = {"text": "", "tooltip": "", "class": "", "percentage": 0}
    gen = gen_text()
    while True:
        output["text"] = next(gen)
        json.dump(output, sys.stdout, ensure_ascii=False)
        print(flush=True)


if __name__ == "__main__":
    main()
