using Images



function normalise(i, j, nx, ny, r)

    x_scaling::Float64 = 2 * r / nx
    y_scaling::Float64 = 2 * r / ny
    scaling::Float64 = max(x_scaling, y_scaling)

    x_offset::Float64 = scaling * nx / 2
    y_offset::Float64 = scaling * ny / 2

    y_adjust::Float64 = y_offset / 40

    x::Float64 = i * scaling - x_offset
    y::Float64 = j * scaling - y_offset + y_adjust
    z::Complex = x + im * y

    return z
end



function get_c()

    c::Complex = 4 * (-0.5 - 0.5 * im + rand() + rand() * im)

    return c
end



function get_r(c)

    r::Float64 = 0.5 * (1 + sqrt(1 + 4 * abs(c)))

    return r
end



function init_points(nx, ny, r)

    points = Array{Complex}(undef, nx, ny)
    escape_times = Array{Int}(undef, nx, ny)

    for i = 1:nx
        for j = 1:ny

            z::Complex = normalise(i, j, nx, ny, r)
            points[i, j] = z

            if abs(z) <= r
                escape_times[i, j] = max_iter
            else
                escape_times[i, j] = 0
            end
        end
    end

    return [points, escape_times]
end



function iterate_points(points::Array{Complex}, escape_times::Array{Int}, nx, ny, c, r, max_iter)

    for i = 1:nx
        for j = 1:ny

            n = 1
            while n <= max_iter

                z::Complex = points[i, j]

                if abs(z) <= r
                    points[i, j] = z^2 + c
                else
                    escape_times[i, j] = n
                    break
                end

                n += 1
            end
        end

        if (i % 100 == 0)
            println("Rendered ", i, " of ", nx, " lines...")
        end
    end
    return escape_times
end



function curve_values(vals, l)

    ni = size(vals)[1]
    nj = size(vals)[2]
    c_vals = Array{Float64}(undef, ni, nj)

    m = maximum(vals)

    for i = 1:ni
        for j = 1:nj

            c_vals[i, j] = 1 - exp(-l * vals[i, j] / m)
        end
    end

    return c_vals
end



function format_color(x)

    ni = size(x)[1]
    nj = size(x)[2]
    f_x = Array{RGB{Float64}}(undef, ni, nj)

    rand_red = 0.4 * rand() + 0.4
    rand_green = 0.4 * rand() + 0.4
    rand_blue = 0.4 * rand() + 0.4

    global fg_color = RGB(rand_red, rand_green, rand_blue)

    for i = 1:ni
        for j = 1:nj

            adj_red = x[i, j] * rand_red
            adj_green = x[i, j] * rand_green
            adj_blue = x[i, j] * rand_blue

            f_x[i, j] = RGB{Float64}(adj_red, adj_green, adj_blue)
        end
    end

    return f_x
end



function format_escape_times(escape_times)

    f_escape_times = transpose(escape_times)
    f_escape_times = curve_values(f_escape_times, 1.7)
    f_escape_times /= maximum(f_escape_times)
    f_escape_times = format_color(f_escape_times)

    return f_escape_times
end



function julia_plot(nx, ny, max_iter, long_ver_num, filename)

    n_interesting_points = 0
    nx_small = 90
    ny_small = 90
    max_iter_small = 100

    println("Finding a good value for c...")
    while n_interesting_points <= nx_small * ny_small / 20
        global c = get_c()
        global r = get_r(c)
        points, escape_times = init_points(nx_small, ny_small, r)
        escape_times = iterate_points(points, escape_times, nx_small, ny_small, c, r, max_iter_small)
        n_interesting_points = sum(max_iter_small / 4 .<= escape_times .<= 3 * max_iter_small / 4)
    end

    println("\nc = ", c)
    points, escape_times = init_points(nx, ny, r)
    escape_times = iterate_points(points, escape_times, nx, ny, c, r, max_iter)
    n_interesting_points = sum(max_iter / 10 .<= escape_times .<= 9 * max_iter / 10)
    println("\nFound ", n_interesting_points," / ", nx * ny, " interesting points")

    f_escape_times = format_escape_times(escape_times)

    println("Saving image file...")
    save(filename, f_escape_times)
end



function format_latex(c)

    x = real(c)
    y = imag(c)

    xstr = string(abs(x) + 0.0005, "00000")[1:5]
    ystr = string(abs(y) + 0.0005, "00000")[1:5]

    if (sign(x) < 0) & (xstr != "0.000")
        xstr = string("-", xstr)
    end

    if sign(y) >= 0
        latex_str = string("c = ", xstr, " + ", ystr, "\\,i")
    else
        latex_str = string("c = ", xstr, " - ", ystr, "\\,i")
    end

    return latex_str
end



println("Starting Julia set plot...")

# read version number
io = open("data/vernum.txt", "r")
ver_num = parse(Int, read(io, String))
close(io)

# format version number and filename
long_ver_num = string("000000", ver_num)[end-5:end]
filename = string("./plots/julia_set_", long_ver_num, ".png")

# save plot
const nx = 2560
const ny = 1440
const max_iter = 1000
julia_plot(nx, ny, max_iter, long_ver_num, filename)

# copy to current version
cp(filename, "./plots/julia_set.png", force = true)

# save c parameter
c_label = format_latex(c)
io = open("data/c.txt", "w")
println(io, c_label)
close(io)

# save color
col_string = hex(fg_color, :rrggbb)
col_string = string("\\definecolor{fgcolor}{HTML}{", col_string, "}")
io = open("data/color.txt", "w")
println(io, col_string)
close(io)

println("Finished Julia set plot")
