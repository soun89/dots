#!/bin/bash
swaybg -i $(cat ~/.cache/wal/wal) &
swaymsg workspace 1

# Ensure wobpipe_vol is running
if ! pgrep -f "wob" > /dev/null; then
    mkfifo /tmp/wobpipe_vol
    tail -f /tmp/wobpipe_vol | wob &
    mkfifo /tmp/wobpipe_brt
    tail -f /tmp/wobpipe_brt | wob &
fi

protonvpn-app --start-minimized &
nm-applet &
env LD_PRELOAD=/usr/local/lib/spotify-adblock.so spotify &&

# mpd &
# # Ensure mpd-mpris is running
# if ! pgrep -f "mpd-mpris" > /dev/null; then
#     mpd-mpris -host 127.0.0.1 &
# fi

# wal -i $(cat ~/.cache/wal/wal); ~/Documents/ChromiumPywal-main/generate-theme.sh; ~/reload_dunst.sh
wal -i $(cat ~/.cache/wal/wal)
notify-send "Welcome $(whoami)" "Its $(date +"%I:%M %p") on a $(date +%A)" --icon $(cat ~/.cache/wal/wal)
kitty &
sleep 0.5

#kitty &
#sleep 0.5
# alacritty -e ncmpcpp &
#kitty &
#sleep 0.5
# alacritty -e ranger ~/Documents &
# alacritty -e elinks &
# alacritty &
#sleep 0.5
#alacritty --config-file ~/.config/alacritty/alacritty_small_font.toml -e cava &
#sleep 1
#kitty -c ~/.config/kitty/kittysmall.conf &
i3-msg workspace 3 && thunar /home/soun/Study &
sleep 2
#i3-msg workspace 4 && firefox &
#sleep 4
#i3-msg workspace 2
#evince &
