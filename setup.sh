#!/bin/bash

# Define colors
GREEN='\033[00;32m'
RED='\033[00;31m'
RESTORE='\033[0m'

# FIX: Get the actual user who is running the script, even with sudo
REAL_USER=$(logname || echo $USER)
REAL_HOME=$(getent passwd "$REAL_USER" | cut -d: -f6)

echo -e "${GREEN}--- Starting Dotfiles Setup ---${RESTORE}"

# 1. Install Dependencies
if [ -x "$(command -v apt)" ]; then
    INSTALL="sudo apt install -y"
    PKGS=(i3 i3status rofi kitty picom feh scrot pasystray network-manager fonts-jetbrains-mono)
elif [ -x "$(command -v pacman)" ]; then
    INSTALL="sudo pacman -S --noconfirm"
    PKGS=(i3-wm i3status rofi kitty picom feh scrot pasystray networkmanager ttf-jetbrains-mono)
fi

echo "Installing packages..."
$INSTALL "${PKGS[@]}"

# 2. Restore Configs
# We target the actual user's home directory
DOTFILES_DIR="$REAL_HOME/dotfiles"
CONFIG_DEST="$REAL_HOME/.config"
TARGETS=("i3" "rofi" "kitty" "i3status" "picom")

echo "Restoring configurations for user: $REAL_USER"
mkdir -p "$CONFIG_DEST"

for folder in "${TARGETS[@]}"; do
    if [ -d "$DOTFILES_DIR/$folder" ]; then
        echo "Copying $folder..."
        cp -r "$DOTFILES_DIR/$folder" "$CONFIG_DEST/"
        # Ensure the user owns their files, not root
        chown -R "$REAL_USER:$REAL_USER" "$CONFIG_DEST/$folder"
    else
        echo -e "${RED}Error: $folder not found in $DOTFILES_DIR${RESTORE}"
    fi
done

echo -e "${GREEN}--- Setup Finished! ---${RESTORE}"
