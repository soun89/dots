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
    output_dir="/media/removable/USB Drive/Albums/$input_dir_name"
else
    # If user chooses to specify a custom directory
    read -p "Enter the full output directory path: " output_dir
fi

# Create the output directory if it doesn't exist
mkdir -p "$output_dir"

# Get total number of files for progress tracking
total_files=$(ls "$input_dir"/*.m4a 2>/dev/null | wc -l)
current_file=0

# Progress bar function
progress_bar() {
    local progress=$1
    local total=$2
    local percent=$(( (progress * 100) / total ))
    local completed=$((percent / 2))  # 50 columns for the progress bar
    local remaining=$((50 - completed))

    printf "\\r["
    printf "%0.s#" $(seq 1 $completed)
    printf "%0.s-" $(seq 1 $remaining)
    printf "] %d%% (%d/%d)" "$percent" "$progress" "$total"
}

# Loop through each m4a file in the input directory
for file in "$input_dir"/*.m4a; do
    # Get the base filename without the directory
    filename=$(basename "$file")
    
    # Ensure the output file has .mp3 extension
    filename="${filename%.m4a}.mp3"
    
    # Increment the current file counter for progress display
    current_file=$((current_file + 1))

    # Display the current song being processed
    echo -e "\\nProcessing: " "$filename"

    # Show progress bar
    progress_bar "$current_file" "$total_files"

    # Convert from m4a to mp3 with volume reduction of 20 dB
    ffmpeg -i "$file" -filter:a "volume=-20dB" "$output_dir/$filename" -loglevel error

done

# Finish with a full progress bar and newline
progress_bar "$total_files" "$total_files"
echo -e "\\nVolume reduction applied to all files. Output saved to $output_dir."
