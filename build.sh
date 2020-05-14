#!/usr/bin/env bash

cd "$(dirname "$0")"

# Make directories and data files
mkdir -p plots
mkdir -p data
[[ -f data/vernum.txt ]] || echo 1 > data/vernum.txt


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
convert -density 1000 -resize 2560x1440\! julia_annotated.pdf ../plots/julia_annotated.png

# Copy annotated version to numbered file
cd ../plots
while read -r line; do
    ver_num="$line"
done < "../data/vernum.txt"
long_ver_num="000000${ver_num}"
long_ver_num=${long_ver_num: -6}
cp julia_annotated.png julia_annotated_${long_ver_num}.png

# Update version number
new_ver_num=$(($ver_num + 1))
echo $new_ver_num > ../data/vernum.txt
