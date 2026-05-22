#!/usr/bin/env bash

echo "[ + ]: Welcome, lets end your cursor updating sufferings r8 now! :) "

echo "[ * ]: Checking system dependencies..."

run_as_root() {
    if [ "$EUID" -eq 0 ]; then
        "$@"
    else
        sudo "$@"
    fi
}

if [ -x "$(command -v pacman)" ]; then
    echo "[ + ]: Arch Linux detected. Installing dependencies via pacman..."
    run_as_root pacman -Syu --needed git hyprcursor nwg-look

elif [ -x "$(command -v dnf)" ]; then
    echo "[ + ]: Fedora detected. Installing dependencies via dnf..."
    run_as_root dnf install -y git hyprcursor nwg-look

elif [ -x "$(command -v apt-get)" ]; then
    echo "[ + ]: Debian/Ubuntu-based system detected. Installing dependencies via apt..."
    run_as_root apt-get update
    run_as_root apt-get install -y git hyprcursor nwg-look

elif [ -x "$(command -v zypper)" ]; then
    echo "[ + ]: openSUSE detected. Installing dependencies via zypper..."
    run_as_root zypper refresh
    run_as_root zypper install -y git hyprcursor nwg-look

else
    echo "[ ! ]: Unknown package manager. Skipping auto-install."
    echo "[ ! ]: Please ensure 'git', 'hyprcursor', and 'nwg-look' are installed manually."
fi

echo "[ + ]: Dependencies verified!"
echo "--------------------------------------------------------"

echo "[ + ]: Creating necessary folders..."
mkdir -p "$HOME/.config/systemd/user"
echo "--------------------------------------------------------"

echo "[ + ]: Copying necessary files to `~/.config/systemd/user/`"
cp cursor-update.sh "$HOME/.config/systemd/user/"
cp cursor-update.path "$HOME/.config/systemd/user/"
cp cursor-update.service "$HOME/.config/systemd/user/"
echo "--------------------------------------------------------"

echo "[ + ]: Making the script executable..."
chmod +x "$HOME/.config/systemd/user/cursor-update.sh"
echo "--------------------------------------------------------"


echo "[ + ]: Starting hyprcursor-sync daemon..."
systemctl --user daemon-reload
systemctl --user enable --now cursor-update.path

echo "[ + ]: Installation Complete! Enjoy your cursors!"
