#!/bin/bash
TMPBG=/tmp/screen.png
LOCK=$HOME/lock1.png
RES=1366x768

grim $TMPBG
#ffmpeg -f x11grab -video_size $RES -y -i $DISPLAY -i $LOCK -vframes 1 $TMPBG -loglevel quiet
# ffmpeg -f x11grab -video_size $RES -y -i $DISPLAY -i $LOCK -filter_complex "gblur=15:1,overlay=(main_w-overlay_w)/2:(main_h-overlay_h)/2" -vframes 1 $TMPBG -loglevel quiet
gtklock -b $TMPBG
rm $TMPBG