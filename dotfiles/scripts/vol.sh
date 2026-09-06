#!/usr/bin/env bash

adjust_all_sinks() {
  local op="$1"
  local amount="${2:-5}"  # 默认加/减 5

  case "$op" in
    up)
      flag="-i"
      ;;
    down)
      flag="-d"
      ;;
    toggle_mute)
      pamixer --list-sinks \
        | tail -n +2 \
        | awk '{print $2}' \
        | tr -d '"' \
        | xargs -I{} pamixer --sink {} --toggle-mute
      return
      ;;
    *)
      echo "Usage: $0 { up | down | toggle_mute } [amount]" >&2
      exit 1
      ;;
  esac

  pamixer --list-sinks \
    | tail -n +2 \
    | awk '{print $2}' \
    | tr -d '"' \
    | xargs -I{} pamixer --sink {} "$flag" "$amount"
}

# 执行
adjust_all_sinks "$@"

