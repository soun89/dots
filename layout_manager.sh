#!/bin/bash

# Path to your saved layout file
LAYOUT_FILE="layout.json"

# Ensure jq is installed for parsing JSON
if ! command -v jq &> /dev/null; then
    echo "jq is required but not installed."
    exit 1
fi

# Parse layout.json and recreate the layout
jq -c '.nodes[] | select(.type=="workspace")' "$LAYOUT_FILE" | while read -r workspace; do
    WORKSPACE_NAME=$(echo "$workspace" | jq -r '.name')
    echo "Restoring workspace: $WORKSPACE_NAME"

    # Switch to the workspace
    swaymsg workspace "$WORKSPACE_NAME"

    # Loop through the windows in this workspace
    echo "$workspace" | jq -c '.nodes[] | select(.type=="con")' | while read -r con; do
        APP_ID=$(echo "$con" | jq -r '.app_id // empty')
        if [ -n "$APP_ID" ]; then
            echo "Launching application: $APP_ID"
            swaymsg exec "$APP_ID"
        fi
    done
done
