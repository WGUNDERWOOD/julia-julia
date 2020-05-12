using PackageCompiler

create_sysimage(:Plots, sysimage_path="sys_plots.so", precompile_execution_file="julia_julia.jl")
