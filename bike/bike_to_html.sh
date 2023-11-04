#!/bin/bash

SOURCE_DIR="/Users/derek.nordgren/Documents/outlines"
TARGET_DIR="/Users/derek.nordgren/vaults/outlines"

echo "$(date) - Checking for *.bike files to copy."

# Check each .bike file in the source directory
for file in "$SOURCE_DIR"/*.bike; do
    # Skip if no .bike files are available
    [ -e "$file" ] || continue

    # Extract filename without extension
    base_name=$(basename "$file" .bike)

    target_file="$TARGET_DIR/$base_name.html"

    cp "$file" "$target_file"
done
