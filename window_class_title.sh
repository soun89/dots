#!/bin/bash

get_wm_class() {
  local window_id=$1
  # Get the WM_CLASS property of the window
  xprop -id "$window_id" WM_CLASS 2>/dev/null | awk -F '"' '{print $4}'
}

monitor_active_window() {
  xprop -root -spy _NET_ACTIVE_WINDOW | while read -r line; do
    # Extract the active window ID
    window_id=$(echo "$line" | awk -F' ' '{print $NF}' | sed 's/,//')
    
    if [[ "$window_id" == "0x0" ]]; then
      echo "Finder"
    else
      wm_class=$(get_wm_class "$window_id")
      echo "${wm_class:-Unknown}"
    fi
  done
}

monitor_active_window




# get_title_length() {
#   local window_id=$1
#   # Get the length of the window title
#   xprop -id "$window_id" WM_CLASS 2>/dev/null | awk -F '"' '/WM_NAME/ {print length($2)}'
# }

# monitor_active_window() {
#   while true; do
#     # Get the active window ID
#     window_id=$(xprop -root _NET_ACTIVE_WINDOW | awk -F' ' '{print $NF}' | sed 's/,//')
    
#     if [[ "$window_id" == "0x0" || -z "$window_id" ]]; then
#       printf "%7s\n" " " # Default to 7 spaces for "Finder" or no active window
#     else
#       title_length=$(get_title_length "$window_id")
#       if [[ -n "$title_length" && "$title_length" -gt 0 ]]; then
#         printf "%${title_length}s\n" " " # Print spaces equal to the title length
#       else
#         printf "%7s\n" " " # Default to 7 spaces for unknown titles
#       fi
#     fi

#     sleep 0.1 # Poll every 0.1 seconds
#   done
# }

# monitor_active_window
