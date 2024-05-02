#! /usr/bin/env nix-shell
#! nix-shell -i bash -p bash

workspace_name=$(hyprctl -j activeworkspace | jq -r '.name')

if [ "$workspace_name" = "OVERVIEW" ]; then
    hyprctl dispatch hycov:leaveoverview forceallinone
else
    hyprctl dispatch hycov:enteroverview forceallinone
    hyprctl dispatch 'easymotion action:hyprctl --batch "dispatch focuswindow address:{} ; dispatch hycov:leaveoverview"'
fi
