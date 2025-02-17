#!/bin/bash
WALLPAPER_PYWAL="$1"
wal -i $WALLPAPER_PYWAL
# /home/soun/change_color_value.sh
#pkill swaybg
#swaybg -m fill -i $WALLPAPER_PYWAL &
swww img --transition-type left --transition-bezier .21,.83,.5,.98 --transition-fps 20 $WALLPAPER_PYWAL
# walogram -B
# ~/reload_dunst.sh
#cp ~/.cache/wal/config ~/.config/cava/config
#pkill -USR2 cava
pkill -USR2 waybar
pywal_sublime.py
#pkill wob
#sleep 1
#tail -f /tmp/wobpipe_vol | wob &
#tail -f /tmp/wobpipe_brt | wob &
# betterlockscreen -u $WALLPAPER_PYWAL
sed -i "4c\    path = $WALLPAPER_PYWAL" ~/.config/hypr/hyprlock.conf
# sed -i "15s|background: url(\"file:///.*\");|background: url(\"file://$WALLPAPER_PYWAL\");|" ~/.mozilla/firefox/53slu19i.default-release-1/chrome/customChrome.css
#notify-send Pywal "Wallpaper changed and colour scheme applied succesfully" -i $WALLPAPER_PYWAL
#gsettings set org.gnome.desktop.background picture-uri "file://$WALLPAPER_PYWAL" && sudo sed -i "s|^background=.*|background=$WALLPAPER_PYWAL|" /etc/lightdm/slick-greeter.conf
