#!/bin/bash

i3-msg workspace 1
# Start necessary background services
wal -i $(cat ~/.cache/wal/wal); ~/reload_dunst.sh
notify-send "Welcome $(whoami)" "It's $(date +"%I:%M %p") on a $(date +%A)" --icon $(cat ~/.cache/wal/wal)
picom &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
~/.config/polybar/hack/launch.sh & 
mpd &
sleep 0.1
mpd-mpris -host 127.0.0.1 &

# Open applications in the background
sleep 0.5
alacritty &
sleep 0.5
alacritty -e ncmpcpp &
sleep 0.5
alacritty &
sleep 0.5
alacritty --config-file ~/.config/alacritty/alacritty_small_font.toml -e cava &
sleep 0.5
layout_manager.sh work1lmao

# Open applications directly in their designated workspaces
i3-msg "workspace 3; exec --no-startup-id thunar /home/soun/Study" &
i3-msg "workspace 2; exec --no-startup-id evince" &
#i3-msg "workspace 4; exec --no-startup-id firefox" &

# Return to the starting workspace
i3-msg workspace 2
