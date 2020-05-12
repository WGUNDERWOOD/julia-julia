using Revise
using Random
using Plots
using Dates

function make_julia_set(c, max_iters, min_depth, max_depth, max_deriv)

    n = 1
    points = [Dict([("z", 0 + 0*im), ("depth", 0), ("deriv", 1)])]
    plot_points = Complex[]

    while (n <= max_iters) & (length(points) != 0)
        point = pop!(points)

        if point["depth"] >= min_depth
            append!(plot_points, point["z"])
        end

        if (point["depth"] <= max_depth) & (point["deriv"] <= max_deriv)

            z_new = sqrt(point["z"] - c)
            depth_new = point["depth"] + 1
            deriv_new = 2 * point["deriv"] * abs(z_new)
            point_new_1 = [Dict([("z", z_new), ("depth", depth_new), ("deriv", deriv_new)])]
            point_new_2 = [Dict([("z", -z_new), ("depth", depth_new), ("deriv", deriv_new)])]

            append!(points, point_new_1)
            append!(points, point_new_2)

        end
        n = n + 1
    end

    return unique(round_complex.(plot_points, 3))
end


function round_complex(z, digits)

    x = real(z)
    y = imag(z)
    xr = trunc.(x, digits = digits)
    yr = trunc.(y, digits = digits)
    zr = xr + yr * im

    return zr
end


function plot_julia_set(max_iters, min_depth, max_depth, max_deriv, min_points)


    n_points = 0
    while n_points <= min_points
        global c = get_c_value()
        println("c = ", round_complex(c, 3))
        global points = make_julia_set(c, max_iters, min_depth, max_depth, max_deriv)
        n_points = length(points)
        println("Found ", n_points, " points...")
    end

    points_real = real(points)
    points_imag = imag(points)

    rand_red = 0.4 * rand() + 0.2
    rand_green = 0.4 * rand() + 0.2
    rand_blue = 0.4 * rand() + 0.2
    global fg_color = RGBA(rand_red, rand_green, rand_blue, 0.9)

    scatter(points_real,
            points_imag,
            markersize = 0.2,
            markershape = :circle,
            markerstrokewidth = 0,
            size = (2560, 1440),
            axis = nothing,
            border = :none,
            legend = nothing,
            aspect_ratio = :equal,
            color = fg_color,
            background_color = RGB(0, 0, 0)
    )

    # make lower border larger for use as wallpaper
    scatter!([minimum(points_real)],
            [minimum(points_imag) - 0.05],
            color = RGB(0, 0, 0),
            markersize = 0,
            markerstrokewidth = 0
    )

    global filename = string("./plots/julia_set", Dates.now(), ".png")
    savefig(filename)
end



function get_c_value()

    c = 0
    while (abs(c) > 2) | (abs(c) < 0.2)
        c = 4*(-0.5 - 0.5 * im + rand() + rand() * im)
    end

    return c
end


max_iters = 10000000
min_depth = 20
max_depth = 20000
max_deriv = 10000
min_points = 100000

println("Starting Julia set plot...")
gr()

# save plot
plot_julia_set(max_iters, min_depth, max_depth, max_deriv, min_points)

# copy to current version
cp(filename, "./julia_set.png", force = true)

# save c parameter
cx = trunc(real(c), digits = 3)
cy = trunc(imag(c), digits = 3)

if cx == 0
    cx = -cx
end

if cy == 0
    cy = -cy
end

if cy >= 0
    c_label = string("c = ", cx, " + ", cy, "\\,i")
else
    c_label = string("c = ", cx, " - ", -cy, "\\,i")
end

io = open("data/c.txt", "w")
println(io, c_label)
close(io)

# save color
col_string = hex(fg_color, :rrggbb)
col_string = string("\\definecolor{fgcolor}{HTML}{", col_string, "}")
io = open("data/color.txt", "w")
println(io, col_string)
close(io)

# read version number
io = open("data/vernum.txt", "r")
ver_num = parse(Int, read(io, String))
close(io)

# write version number
ver_num = ver_num + 1
ver_num = string(ver_num)
io = open("data/vernum.txt", "w")
write(io, ver_num)
close(io)


println("Finished Julia set plot.")
