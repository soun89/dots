#!/bin/sh

# see man zscroll for documentation of the following parameters
zscroll -l 25 -n true \
        --delay 0.2 \
        --scroll-padding "  " \
        --match-command "playerctl metadata --format '{{playerName}}" \
        --match-text "spotify" "--before-text ' '" \
        --match-text "chromium" "--before-text ' '" \
        "playerctl metadata --format '{{ artist }} - {{ title }}' --follow --no-messages" &

wait

