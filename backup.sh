#!/bin/bash

GREEN='\033[00;32m'
RESTORE='\033[0m'

# Source and Destination
DOTFILES_DIR="$HOME/dotfiles"
TARGETS=("i3" "rofi" "kitty" "i3status" "picom")

echo -e "${GREEN}Starting Backup...${RESTORE}"

# Create dotfiles directory if it doesn't exist
mkdir -p "$DOTFILES_DIR"

for folder in "${TARGETS[@]}"; do
    if [ -d "$HOME/.config/$folder" ]; then
        echo "Backing up $folder..."
        # Using -r to copy folders and -u to only copy if files are newer
        cp -ru "$HOME/.config/$folder" "$DOTFILES_DIR/"
    fi
done

echo -e "${GREEN}Backup finished successfully!${RESTORE}"
