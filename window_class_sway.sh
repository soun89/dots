#!/bin/bash

# Function to get window class or title using hyprctl
get_window_info() {
    local active_window
    active_window=$(hyprctl activewindow)

    if [[ -z "$active_window" || "$active_window" == *"Invalid"* ]]; then
        echo "Desktop"
        return
    fi

    # Extract window class
    echo "$active_window" | awk -F': ' '/class:/ {print $2}'
}

# Monitor active window changes
monitor_active_window() {
    local last_window=""

    while true; do
        wm_class=$(get_window_info)

        # Prevent unnecessary updates if the window hasn't changed
        if [[ "$wm_class" == "$last_window" ]]; then
            sleep 0.5
            continue
        fi

        last_window="$wm_class"

        # Check for specific window classes and display corresponding menu bars
        if [[ "$wm_class" == "Desktop" ]]; then
            echo -e "   File  Edit  View  Go  Window  Help"
        else
            case "$wm_class" in
                "firefox")
                    echo "   File  Edit  View  History  Bookmarks  Tools  Help"
                    ;;
                "Thunar")
                    echo "   File  Edit  View  Go  Help"
                    ;;
                "kitty"|"foot"|"Alacritty")
                    echo "   $(date +%R)  File  Edit  View  Terminal  Help"
                    ;;
                "Zathura")
                    echo "   File  Edit  View  Search  Help"
                    ;;
                "sublime_text")
                    echo "   File  Edit  Selection  Find  View  Goto  Tools  Project  Preferences  Help"
                    ;;
                "avidemux3_qt5")
                    echo "   File  Recent  Edit  View  Audio  Video  Auto  Tools  Go  Custom  Help"
                    ;;
                "kdenlive")
                    echo "   File  Edit  View  Project  Tool  Clip  Timeline  Monitor  Settings  Help"
                    ;;
                "Audacity")
                    echo "   File  Edit  Select  View  Transport  Tracks  Generate  Effect  Analyze  Tools  Help"
                    ;;
                "vlc")
                    echo "   Media  Playback  Audio  Video  Subtitle  Tools  View  Help"
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
                *)
                    echo "   File  Edit  View  Go  Window  Help"
                    ;;
            esac
        fi

        # Poll every 0.5 seconds
        sleep 0.3
    done
}

# Start monitoring active window changes
monitor_active_window
