#!/bin/bash

# Get screen dimensions
screen_height=$(hyprctl monitors | jq -r '.[0].height')

# Initial position (off-screen above)
y_start=-$screen_height

# Final position (on-screen)
y_end=0

# Duration of animation (milliseconds)
duration=200

# Step size (adjust for smoothness - should be smaller than screen_height)
step=10

# Calculate delay between steps (handle potential division by zero)
if (( screen_height / step == 0 )); then
    delay=$duration  # If step is larger than screen_height, just use duration
else
    delay=$((duration / (screen_height / step)))
fi


# Move the window down in steps
#!/bin/bash

# ... (screen height, initial position, duration, step, delay calculation - same as before)

#!/bin/bash

# ... (screen height, initial position, duration, step, delay calculation - same as before)

# Move the window down in steps
y=$y_start
while (( $(echo "$y <= $y_end" | bc -l) )); do # Use bc for floating-point comparison
    ydotool mousemove 0 "$y"
    sleep $((delay / 1000.0))
    y=$(echo "$y + $step" | bc -l) # Use bc for floating-point addition
done

# ... (hyprlock launch, optional cursor move, timeout)
# ... (hyprlock launch, optional cursor move, timeout)
# Launch hyprlock (in the background)
# hyprlock &

# ... (Optional: Move cursor, kill hyprlock after timeout)