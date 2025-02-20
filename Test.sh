#!/bin/bash

# Directory containing your project folders
MAIN_DIR="/path/to/your/main/folder"

# File to keep track of the last pushed folder
LAST_PUSHED_FILE="$MAIN_DIR/last_pushed.txt"

# Read the last pushed folder name
if [[ -f "$LAST_PUSHED_FILE" ]]; then
    LAST_PUSHED=$(cat "$LAST_PUSHED_FILE")
else
    LAST_PUSHED=""
fi

# Find the next folder to push
PUSHED=false
for d in $MAIN_DIR/*; do
    if [[ -d "$d" && "$d" > "$LAST_PUSHED" && "$PUSHED" == false ]]; then
        # Navigate to the folder
        cd "$d"

        # Initialize Git and set remote only if it doesn't exist
        git init
        git remote add origin <URL-to-GitHub-repository> || true

        # Add all files, commit, and push
        git add .
        git commit -m "Automated commit of $(basename "$d")"
        git push -u origin master

        # Update the last pushed record
        echo "$(basename "$d")" > "$LAST_PUSHED_FILE"
        PUSHED=true
    fi
done

