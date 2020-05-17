#!/usr/bin/env bash

# Run script
bash ./build.sh

# Set wallpaper
echo "Setting wallpaper..."
cp ./plots/julia_annotated.png /usr/local/share/wallpapers/wallpaper.png
sleep 1
bash ~/.fehbg
