#!/bin/bash

# Temporary directory for trimmed files
temp_dir="trimmed_files"
mkdir -p "$temp_dir"

# Combined output file
output_file="combined_trimmed.pdf"

# Process each PDF
for file in *.pdf; do
    # First remove the watermarks
    pdfcpu watermark remove -m pdf -- $file
    # Get the total number of pages
    total_pages=$(qpdf --show-npages "$file")
    # Remove the last page and save to the temporary directory
    qpdf "$file" --pages "$file" 1-$((total_pages - 1)) -- "$temp_dir/trimmed_${file}"
    echo "Processed $file -> $temp_dir/trimmed_${file}"
done

# Combine all trimmed PDFs into one file
qpdf --empty --pages "$temp_dir"/*.pdf -- "$output_file"
echo "All trimmed PDFs combined into $output_file"

# Remove individual trimmed PDFs
rm -r "$temp_dir"
echo "Removed temporary trimmed files"
