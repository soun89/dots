#!/bin/bash

# Function to get the window class
get_wm_class() {
  local window_id=$1
  # If no valid window ID is passed, assume desktop
  if [[ -z "$window_id" || "$window_id" == "0x0" ]]; then
    echo "Desktop"
    return 0
  fi

  # Attempt to get the WM_CLASS property using xprop
  local wm_class
  wm_class=$(xprop -id "$window_id" | grep WM_CLASS | awk '{print $4}' | sed 's/"//g')

  # Check if the WM_CLASS property was found
  if [[ -z "$wm_class" ]]; then
    echo "Unknown"
    return 1
  fi

  echo "$wm_class"
}

# Monitor active window changes in real time
monitor_active_window() {
  xprop -root -spy _NET_ACTIVE_WINDOW | while read -r line; do
    # Extract the active window ID
    window_id=$(echo "$line" | awk -F' ' '{print $NF}' | sed 's/,//')

    # Get the WM_CLASS for the current active window
    wm_class=$(get_wm_class "$window_id")

    # Check for specific window classes and display corresponding menu bars
    if [[ "$wm_class" == "Desktop" ]]; then
      echo -e "   File  Edit  View  Go  Window  Help"
    else
      case "$wm_class" in
        "firefox")
          echo "   File  Edit  View  History  Bookmarks  Tools  Help"
          ;;
        "Thunar")
          echo "   File  Edit  View  Go  Bookmarks  Help  $(xprop -id $(xdotool getactivewindow) | awk -F'"' '/WM_NAME/ {split($2, parts, " - "); print parts[1]; exit}')"
          # echo "   "
          ;;
        "Alacritty")
          echo "   $(date +%R)  File  Edit  View  Terminal  Help"
          ;;
        "Zathura")
          echo "   File  Edit  View  Search  Help  $(xprop -id $(xdotool getactivewindow) | awk -F'"' '/WM_NAME/ {split($2, path, "/"); print path[length(path)]; exit}')"
          ;;
        "Sublime_text")
          echo "   File  Edit  Selection  Find  View  Goto  Tools  Project  Preferences  Help  $(xprop -id $(xdotool getactivewindow) | awk -F'"' '/WM_NAME/ {split($2, parts, " - "); print parts[1]; exit}')"
          # echo "   "
          ;;
        "avidemux3_qt5")
          echo "   File  Recent  Edit  View  Audio  Video  Auto  Tools  Go  Custom  Help"
          # echo "  "
          ;;
        "kdenlive")
          echo "   File  Edit  View  Project  Tool  Clip  Timeline  Monitor  Settings  Help"
          # echo "  "
          ;;
        "Audacity")
          echo "   File  Edit  Select  View  Transport  Tracks  Generate  Effect  Analyze  Tools  Help"
          ;;
        "vlc")
          echo "   Media  Playback  Audio  Video  Subtitle  Tools  View  Help"
          # echo "  "
          ;;
        "Hydrogen")
          echo "   Projects  Undo  Drumkits  Instruments  View  Options  Debug  Info"
          ;;
        "Yoshimi")
          echo "   Instruments  Patch Sets  Paths  Scales  State"
          ;;
        "FreeTube")
          echo "   File  Edit  View  Navigate  Window"
          ;;
        "Scid")
          # echo "   File  Play  Edit  Game  Search  Windows  Tools  Options  Help"
          echo "  "
          ;;
        *)
          echo "   File  Edit  View  Go  Window  Help"
          ;;
      esac
    fi
  done
}

# Start monitoring active window changes
monitor_active_window
