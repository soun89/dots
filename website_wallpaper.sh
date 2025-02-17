#!/bin/bash

# Variables
url="$1" # Website URL passed as an argument
download_folder="/tmp/website_images" # Folder to store images
img_extensions="jpg|jpeg|png|gif" # Supported image formats

# Ensure pup is installed for parsing HTML
if ! command -v pup &> /dev/null; then
    echo "pup is required but not installed. Installing pup..."
    sudo apt-get install pup -y
fi

# Create download folder if it doesn't exist
mkdir -p "$download_folder"

# Fetch the HTML content and extract image URLs using wget and pup
echo "Fetching images from $url ..."
wget -q -O - "$url" | pup "img attr{src}" | grep -E "(http|https)://.*\.(?:$img_extensions)" | sort -u > "$download_folder/images.txt"

# Check if any images were found
if [[ ! -s "$download_folder/images.txt" ]]; then
    echo "No images found!"
    exit 1
fi

# Download images
echo "Downloading images ..."
wget -q -i "$download_folder/images.txt" -P "$download_folder"

# Select a random image
random_image=$(find "$download_folder" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) | shuf -n 1)

# Check if an image was found
if [[ -z "$random_image" ]]; then
    echo "No images found after downloading!"
    exit 1
fi

# Set the random image as wallpaper using feh
echo "Setting $random_image as wallpaper ..."
feh --bg-scale "$random_image"

echo "Done!"
