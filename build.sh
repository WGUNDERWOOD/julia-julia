#!/usr/bin/env bash

cd "$(dirname "$0")"

# Make directories and data files
mkdir -p plots
mkdir -p data
[[ -f data/vernum.txt ]] || echo 1 > data/vernum.txt


# Run Julia script
if [ -f "sys_plots.so" ]; then
    echo "Using Julia sysimage for fast plotting..."
    julia --threads 12 --sysimage sys_plots.so julia_julia.jl
else
    echo "No Julia sysimage found. Recompiling..."
    julia compile.jl
fi


# Annotations
echo "Annotating using LaTeX..."
cd latex
pdflatex julia_annotated.tex > /dev/null 2>&1
pdfcrop julia_annotated.pdf julia_annotated.pdf > /dev/null 2>&1
convert -density 1000 -resize 2560x1440\! julia_annotated.pdf ../plots/julia_annotated.png


# Read version number
cd ../plots
while read -r line; do
    ver_num="$line"
done < "../data/vernum.txt"


# Update version number
echo "Updating version number..."
new_ver_num=$(($ver_num + 1))
echo $new_ver_num > ../data/vernum.txt
