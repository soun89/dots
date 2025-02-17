#!/bin/bash

get_icon() {
    case "$1" in
        *spotify*) echo "" ;; # Spotify icon
        *mpd*) echo "󱍚" ;;    # VLC icon
        *firefox*) echo "" ;; # Firefox icon
	*chromium*) echo "" ;; #Chrome icon
	*mpv*) echo "" ;;     #mpv icon
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

# Get all players and their metadata in one go
metadata=$(playerctl -a metadata --format "{{playerName}} {{status}} {{xesam:title}}" 2>/dev/null)
output=""

if [[ -z $metadata ]]; then
    echo "No players running"
    exit 0
fi

while IFS= read -r line; do
    # Extract player name, status, and title from metadata
    player=$(echo "$line" | awk '{print $1}')
    status=$(echo "$line" | awk '{print $2}')
    title=$(echo "$line" | cut -d' ' -f3-)
    title=$(truncate_title "$title")
    icon=$(get_icon "$player")

    playpause_icon=""
    [[ $status == "Playing" ]] && playpause_icon=""
    output+="%{A1:playerctl -p $player play-pause:}$playpause_icon%{A} $icon $title  "
done <<< "$metadata"

echo -e "$output"
