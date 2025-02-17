#!/bin/bash

get_icon() {
    case "$1" in
        *spotify*) echo "" ;; # Spotify icon
        *mpd*) echo "󱍚" ;;    # VLC icon
        *firefox*) echo "" ;; # Firefox icon
        *chromium*) echo "" ;; # Chrome icon
        *mpv*) echo "" ;;     # mpv icon
        *) echo "" ;;         # Default icon
    esac
}

truncate_title() {
    if [[ ${#1} -le 17 ]]; then
        echo "$1"
    else
        echo "${1:0:17}…"
    fi
}

# Get all players and their metadata
metadata=$(playerctl -a metadata --format "{{playerName}} {{status}} {{xesam:title}}" 2>/dev/null)

# Initialize variables for JSON output
text=""
tooltip=""
class=""

if [[ -z $metadata ]]; then
    # Output JSON indicating no players are active
    echo '{"text": "No players", "tooltip": "No media players running", "class": "inactive"}'
    exit 0
fi

# Loop through metadata and build JSON fields
while IFS= read -r line; do
    # Extract player name, status, and title from metadata
    player=$(echo "$line" | awk '{print $1}')
    status=$(echo "$line" | awk '{print $2}')
    title=$(echo "$line" | cut -d' ' -f3-)
    title=$(truncate_title "$title")
    icon=$(get_icon "$player")

    # Set play/pause icon based on player status
    playpause_icon=""
    [[ $status == "Playing" ]] && playpause_icon=""

    # Append data to text and tooltip
    text+="$icon $title  "
    tooltip+="Player: $player\nStatus: $status\nTitle: $title\n\n"
    [[ $status == "Playing" ]] && class="playing"
done <<< "$metadata"

# Output JSON formatted data for Waybar
echo -e "{\"text\": \"$text\", \"tooltip\": \"${tooltip%\\n}\", \"class\": \"${class:-paused}\"}"
