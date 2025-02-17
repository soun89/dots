#!/bin/bash
if [ "$1" == "-a" ]
then
	xwinwrap -ov -ni -g "1368x768" -- mpv --fs --loop-file --input-ipc-server="/tmp/mpvsocket$3" --no-osc --no-osd-bar -wid WID --ytdl-format="bestvideo[height<=720]+bestaudio" --ytdl-raw-options=sub-lang="en",write-auto-sub= "$2"
else
 	xwinwrap -ov -ni -g "1368x768" -- mpv --fs --loop-file --input-ipc-server="/tmp/mpvsocket$3" --no-audio --no-osc --no-osd-bar -wid WID --ytdl-format="bestvideo[height<=720]+bestaudio" --ytdl-raw-options=sub-lang="en",write-auto-sub= "$1"
fi