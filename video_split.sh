#!/bin/bash

# Check if the input directory is provided as an argument
if [ -z "$1" ]; then
    echo "Usage: $0 <directory_of_images>"
    exit 1
fi

input_dir=$1

# Check if the directory exists
if [ ! -d "$input_dir" ]; then
    echo "Error: Directory '$input_dir' does not exist."
    exit 1
fi

# Prompt for input video and output file names
read -p "Enter the input video file name (e.g., vid_720p.mp4): " input_video
read -p "Enter the output video file name (e.g., output_video.mp4): " output_file

# Ensure input video exists
if [ ! -f "$input_video" ]; then
    echo "Error: Input video '$input_video' does not exist."
    exit 1
fi

# Get the number of images in the directory
image_count=$(ls "$input_dir"/*.jpg 2>/dev/null | wc -l)
if [ "$image_count" -eq 0 ]; then
    echo "Error: No JPG images found in directory '$input_dir'."
    exit 1
fi

# Get the duration of the input video
video_duration=$(ffprobe -i "$input_video" -show_entries format=duration -v quiet -of csv="p=0")
if [ -z "$video_duration" ]; then
    echo "Error: Could not determine input video duration."
    exit 1
fi

# Calculate the duration for each image
duration_per_image=$(echo "$video_duration / $image_count" | bc -l)

echo "Video duration: $video_duration seconds"
echo "Number of images: $image_count"
echo "Duration per image: $duration_per_image seconds"

# Generate the slideshow with the same framerate as the input video
framerate=$(ffprobe -v 0 -select_streams v:0 -show_entries stream=r_frame_rate -of csv=p=0 "$input_video" | bc -l)
slideshow_temp="slideshow_temp.mp4"
ffmpeg -framerate "$framerate" -pattern_type glob -i "$input_dir/*.jpg" \
    -vf "scale=640:720:force_original_aspect_ratio=increase,crop=640:720" \
    -c:v libx264 -pix_fmt yuv420p -r "$framerate" -y "$slideshow_temp"

if [ $? -ne 0 ]; then
    echo "Error creating slideshow."
    exit 1
fi

# Combine video and slideshow in split-screen layout
ffmpeg -i "$input_video" -i "$slideshow_temp" \
    -filter_complex "[0:v][1:v]hstack=inputs=2[vout]" \
    -map "[vout]" -map 0:a? -y "$output_file"

if [ $? -eq 0 ]; then
    echo "Output video created successfully: $output_file"
else
    echo "Error creating the output video."
fi

# Cleanup
rm -f "$slideshow_temp"
