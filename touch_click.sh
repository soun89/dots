#!/bin/bash

# Function to simulate a mouse click using ydotool
simulate_click() {
    ydotool click 0xC0
}

# Find the touchpad device
find_touchpad() {
    for device in /dev/input/event*; do
        if evtest --query "${device}" --info 2>/dev/null | grep -qi 'Touchpad'; then
            echo "${device}"
            return
        fi
    done
    echo "Touchpad device not found." >&2
    exit 1
}

# Main monitoring function
monitor_touchpad() {
    local device="$1"
    echo "Monitoring events from: ${device}"

    # Start reading events
    evtest "/dev/input/event8" | while read -r line; do
        # Look for ABS_PRESSURE values
        if [[ "$line" =~ ABS_PRESSURE ]]; then
            # Extract the pressure value
            pressure=$(echo "$line" | grep -oE '[0-9]+$')
            if [[ "$pressure" -gt 35 ]]; then
                echo "Pressure ${pressure} detected. Simulating click."
                simulate_click
            fi
        fi
    done
}

# Ensure required tools are installed
if ! command -v evtest &>/dev/null; then
    echo "Error: evtest is not installed. Install it using 'sudo pacman -S evtest' on Arch Linux." >&2
    exit 1
fi

if ! command -v ydotool &>/dev/null; then
    echo "Error: ydotool is not installed. Install it using 'sudo pacman -S ydotool' on Arch Linux." >&2
    exit 1
fi

# Ensure ydotool daemon is running
if ! pgrep -x ydotoold >/dev/null; then
    echo "Starting ydotoold..."
    sudo ydotoold &
    sleep 1
fi

# Find the touchpad device and start monitoring
device=$(find_touchpad)
monitor_touchpad "${device}"
