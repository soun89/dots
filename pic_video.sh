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

# Prompt for duration and output file name
read -p "Enter the duration (in seconds) for each image pair: " duration
read -p "Enter the output video file name (e.g., output_video.mp4): " output_file

# Ensure two images are stacked side by side, scaled to fit within 720p (1280x720)
# Pair images and combine them horizontally
temp_dir=$(mktemp -d)

# Convert images into pairs
image_files=("$input_dir"/*.jpg)
num_images=${#image_files[@]}
pair_count=$(( (num_images + 1) / 2 ))  # Calculate how many pairs will be created

for ((i=0; i<num_images; i+=2)); do
    img1="${image_files[i]}"
    img2="${image_files[i+1]:-nullsrc=s=640x720}"  # Use a blank image if no second image in pair
    output_pair="$temp_dir/pair_$(printf "%03d" $((i / 2))).jpg"
    
    ffmpeg -y -i "$img1" -i "$img2" \
        -filter_complex "[0:v]scale=640:-1:force_original_aspect_ratio=decrease,pad=640:720:(640-iw)/2:(720-ih)/2[img1]; \
                         [1:v]scale=640:-1:force_original_aspect_ratio=decrease,pad=640:720:(640-iw)/2:(720-ih)/2[img2]; \
                         [img1][img2]hstack=inputs=2" \
        "$output_pair"
done

# Create video from combined pairs
ffmpeg -framerate 1/$duration -pattern_type glob -i "$temp_dir/*.jpg" \
    -c:v libx264 -pix_fmt yuv420p -r 30 -preset ultrafast "$output_file"

# Clean up temporary files
#rm -rf "$temp_dir"

# Check if the video was created successfully
if [ $? -eq 0 ]; then
    echo "Video created successfully: $output_file"
else
    echo "Error creating video."
fi
