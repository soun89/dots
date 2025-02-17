#!/bin/bash
PID_FILE="$HOME/.lid_switch_toggle_pid"

if [[ -f "$PID_FILE" ]]; then
    # If the PID file exists, kill the process and remove the file
    kill "$(cat "$PID_FILE")" && rm "$PID_FILE"
    echo "Disabled lid switch inhibition."
else
    # Run the systemd-inhibit command and save its PID to the file
    systemd-inhibit --what=handle-lid-switch sleep 2592000 &
    echo $! > "$PID_FILE"
    echo "Enabled lid switch inhibition."
fi
