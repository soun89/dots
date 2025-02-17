#!/bin/bash

# Get the current workspace
# current_workspace=$(swaymsg -t get_workspaces | jq -r '.[] | select(.focused).name')

# # Determine the target workspace
# if [ "$current_workspace" = "2" ]; then
#     target_workspace=6
# elif [ "$current_workspace" = "6" ]; then
#     target_workspace=2
# else
#     exit 0 # Exit if not on workspace 2 or 6
# fi

# # Simulate key press, switch workspace, and simulate key press again
# # sleep 0.2 && ydotool key 57:1 57:0 && sleep 0.1 && swaymsg workspace $target_workspace && ydotool key 57:1 57:0
# swaymsg workspace 2

ydotool key 57:1 57:0 && sleep 0.1 && ydotool key 56:1 3:1 3:0 56:0 && sleep 0.2 && ydotool key 57:1 57:0