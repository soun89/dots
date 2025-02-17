#!/bin/bash

# Ask for input directory
read -p "Enter the input directory: " input_dir

# Extract the parent directory and base directory name of the input
parent_dir=$(dirname "$input_dir")
input_dir_name=$(basename "$input_dir")

# Ask where to create the output directory
echo "Where do you want to create the output directory?"
echo "1) Same parent directory as input"
echo "2) USB drive"
echo "3) Specify a custom output directory"
read -p "Choose an option (1/2/3): " choice

if [ "$choice" == "1" ]; then
    # If user chooses to create it in the same parent directory
    read -p "Enter the new output directory name: " new_dir_name
    output_dir="$parent_dir/$new_dir_name"
elif [ "$choice" == "2" ]; then
    # If user chooses the USB drive, create a directory with the same name as input_dir
    output_dir="/media/removable/hmm/$input_dir_name"
else
    # If user chooses to specify a custom directory
    read -p "Enter the full output directory path: " output_dir
fi

# Create the output directory if it doesn't exist
mkdir -p "$output_dir"

# Get total number of files for progress tracking
total_files=$(ls "$input_dir"/*.mp3 2>/dev/null | wc -l)
current_file=0

# Function to process a single file (to be run in parallel)
process_file() {
    local file="$1"
    local output_dir="$2"
    local total_files="$3"
    
    # Get the base filename
    local filename=$(basename "$file")

    # Apply volume reduction of 20 dB
    ffmpeg -i "$file" -filter:a "volume=-20dB" "$output_dir/$filename" -loglevel error
}

export -f process_file  # Export function to be used in GNU parallel

# Using GNU parallel to process files in parallel
find "$input_dir" -name "*.mp3" | parallel --bar process_file {} "$output_dir" "$total_files"

echo -e "\\nVolume reduction applied to all files. Output saved to $output_dir."
