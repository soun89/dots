#!/bin/bash

bg_mode="fill"      # Start with fill
sleep_time=2        # Start with 2 seconds sleep
random_mode=true    # Start with random mode by default
wallpaper_dir="$1"

# List of sleep intervals
sleep_intervals=(0.1 0.5 2 5 7 10 15)
interval_index=0 # Start at the first interval

# Get the list of wallpapers in the directory
wallpapers=($(ls "$wallpaper_dir" | sort)) # Sort wallpapers for sequential display
wallpaper_count=${#wallpapers[@]}      # Get the total number of wallpapers
current_wallpaper_index=0          # Start from the first wallpaper

# Function to update the wallpaper
update_wallpaper() {
    if $random_mode; then
        # Randomize wallpaper
        random_index=$(( $RANDOM % wallpaper_count ))
        wallpaper="$wallpaper_dir/${wallpapers[$random_index]}"
    else
        # Display wallpapers in order
        wallpaper="$wallpaper_dir/${wallpapers[$current_wallpaper_index]}"
        current_wallpaper_index=$(( (current_wallpaper_index + 1) % wallpaper_count ))
    fi
    # Kill any existing swaybg instances
    pkill swaybg
    swww img --transition-type top "$wallpaper"
}

# Display the instructions
echo "press 'e' to toggle between fill and fit"
echo "press 't' to cycle through sleep intervals: 0.1, 0.5, 2, 5, 7, 10, 15 seconds"
echo "press 'r' to toggle between random and in-order wallpaper display"

# Main loop
while true; do
    # Check if a key is pressed
    read -n 1 -t $sleep_time key
    if [[ $key == "e" ]]; then
        # Toggle between fill and fit
        if [[ $bg_mode == "fill" ]]; then
            bg_mode="fit"
        else
            bg_mode="fill"
        fi
        echo "Switched to $bg_mode"
    elif [[ $key == "t" ]]; then
        # Cycle through the sleep intervals
        ((interval_index=(interval_index+1)%7)) # Move to the next interval
        sleep_time=${sleep_intervals[$interval_index]}
        echo "Switched sleep time to $sleep_time seconds"
    elif [[ $key == "r" ]]; then
        # Toggle between random and in-order display modes
        if $random_mode; then
            random_mode=false
            echo "Switched to in-order wallpaper display"
        else
            random_mode=true
            echo "Switched to random wallpaper display"
        fi
    fi
    # Update the wallpaper
    update_wallpaper "$1"
done