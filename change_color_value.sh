#!/bin/bash

# Read the first line from the colors file
color_line=$(head -n 1 /home/soun/.cache/wal/colors)

# Append "BF" after the hashtag using sed
modified_color=$(echo "$color_line" | sed 's/#/#DE/')

# Replace the content after the '=' in the 15th line with modified_color
sed -i "15s/=.*/= ${modified_color}/" /home/soun/.config/polybar/hack/colors.ini

echo "Color has been updated in the config file."
