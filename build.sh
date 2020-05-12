#!/usr/bin/env bash

cd "$(dirname "$0")"
julia --sysimage sys_plots.so julia_julia.jl
cp plots/julia_set.png /usr/local/share/wallpapers/wallpaper.png
bash /home/will/.fehbg
