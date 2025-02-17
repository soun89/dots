#!/bin/bash

# Function to truncate a string and add ellipsis
truncate_with_ellipsis() {
    local string="$1"
    local max_length="$2"
    if (( ${#string} > max_length )); then
        echo "${string:0:max_length}..."
    else
        echo "$string"
    fi
}

# Check for -o flag
only_class=false
if [[ "$1" == "-o" ]]; then
    only_class=true
fi

while true; do
    # Get active window information
    active_window=$(hyprctl activewindow)

    # Check if there's no active window
    if [[ -z "$active_window" || "$active_window" == *"Invalid"* ]]; then
        echo -e "<span font_weight='heavy'>Finder</span>"
    else
        # Extract class and title
        app_class=$(echo "$active_window" | awk -F': ' '/class:/ {print $2}')
        app_name=$(echo "$active_window" | awk -F': ' '/title:/ {print $2}')
        
        # Truncate title if needed
        truncated_name=$(truncate_with_ellipsis "$app_name" 40)

        if $only_class; then
            echo -e "<span font_weight='heavy'>$app_class</span>"
        else
            echo -e "<span font_weight='heavy'>$app_class</span>\r<span font_weight='light'>$truncated_name</span>"
        fi
    fi

    # Poll every 0.5 seconds (2 times per second)
    sleep 0.3
done
