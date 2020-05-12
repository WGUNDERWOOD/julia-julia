#!/usr/bin/env bash

cd "$(dirname "$0")"

# Run Julia script
if [ -f "sys_plots.so" ]; then
    echo "Using Julia sysimage for fast plotting..."
    julia --sysimage sys_plots.so julia_julia.jl
else
    echo "No Julia sysimage found. Recompiling..."
    julia compile.jl
fi

# Annotations
cd latex
pdflatex julia_annotated.tex > /dev/null 2>&1
pdfcrop julia_annotated.pdf julia_annotated.pdf > /dev/null 2>&1
convert -density 1000 -resize 2560x1440\! julia_annotated.pdf ../julia_annotated.png

# Set wallpaper
cd ..
cp julia_annotated.png /usr/local/share/wallpapers/wallpaper.png
bash /home/will/.fehbg
