#!/bin/bash

# Input video file
VIDEO="$1"

# Directory to save the screenshots
OUTPUT_DIR="./screenshots"
mkdir -p "$OUTPUT_DIR"

# Get video duration in seconds using ffprobe
DURATION=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$VIDEO" 2>/dev/null)
DURATION=${DURATION%.*}  # Convert to integer

# Variables to control behavior
MODE="random"  # Initial mode is 'random'
INTERVALS=(0.1 0.5 1 2 5 10)  # Predefined intervals
INTERVAL_INDEX=4  # Start at 5 seconds (5th value in INTERVALS array)
INTERVAL="${INTERVALS[$INTERVAL_INDEX]}"  # Set initial interval
CURRENT_TIME=0  # Current time for sequential screenshots

# Display instructions on start
echo "Press 'r' to toggle between random and sequential modes."
echo "Press 't' to cycle through time intervals (0.1, 0.5, 1, 2, 5, 10 seconds)."

# Function to generate a screenshot
generate_screenshot() {
    local TIME="$1"
    local SCREENSHOT="$OUTPUT_DIR/screenshot_$(date +%s).jpg"
    ffmpeg -ss "$TIME" -i "$VIDEO" -vframes 1 -q:v 2 "$SCREENSHOT" -y >/dev/null 2>&1
    feh --bg-scale "$SCREENSHOT"
}

# Function to toggle between random and sequential modes
toggle_mode() {
    if [[ "$MODE" == "random" ]]; then
        MODE="sequential"
    else
        MODE="random"
    fi
    echo "Switched to $MODE mode"
}

# Function to cycle through the predefined intervals
cycle_interval() {
    ((INTERVAL_INDEX = (INTERVAL_INDEX + 1) % ${#INTERVALS[@]}))  # Cycle to the next index
    INTERVAL="${INTERVALS[$INTERVAL_INDEX]}"  # Update the interval
    echo "Interval changed to $INTERVAL seconds"
}

# Main loop to capture screenshots and listen for key inputs
while true; do
    # Check for keyboard input with a timeout of 0.1 seconds
    read -t 0.1 -n 1 key
    if [[ $key == "r" ]]; then
        toggle_mode
    elif [[ $key == "t" ]]; then
        cycle_interval
    fi

    # Random mode
    if [[ "$MODE" == "random" ]]; then
        RANDOM_TIME=$(shuf -i 1-"$DURATION" -n 1)
        generate_screenshot "$RANDOM_TIME"
    else
        # Sequential mode
        generate_screenshot "$CURRENT_TIME"
        CURRENT_TIME=$(echo "$CURRENT_TIME + $INTERVAL" | bc)
        if (( $(echo "$CURRENT_TIME > $DURATION" | bc -l) )); then
            CURRENT_TIME=0  # Reset when reaching the end of the video
        fi
    fi

    sleep "$INTERVAL"
done
