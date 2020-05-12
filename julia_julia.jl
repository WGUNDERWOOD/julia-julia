using Revise
using Random
using Plots


function make_julia_set(c, n_iters, min_depth, max_depth, max_deriv)

    n = 1
    points = [Dict([("z", 0 + 0*im), ("depth", 0), ("deriv", 1)])]
    plot_points = Complex[]

    while (n <= n_iters) & (length(points) != 0)
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

    return plot_points
end


function plot_julia_set(n_iters, min_depth, max_depth, max_deriv)


    n_points = 0
    while n_points <= 500000
        global c = get_c_value()
        global points = make_julia_set(c, n_iters, min_depth, max_depth, max_deriv)
        n_points = length(points)
    end

    println(c)
    println(string("Plotting ", n_points, " points..."))

    points_real = real(points)
    points_imag = imag(points)

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
            color = RGBA(0.2, 0.18, 0.25, 0.8),
            background_color = RGB(0, 0, 0)
    )

    scatter!([minimum(points_real)],
            [minimum(points_imag) - 0.05],
            color = RGB(0, 0, 0),
            markersize = 0,
            markerstrokewidth = 0
    )

    savefig("./julia_set.png")
end



function get_c_value()

    zs = [
        0.7 * im,
        -0.8 + 0.2 * im,
        0.4 + 0.4 * im,
        -1.3 + 0.2 * im,
        -0.8 * im,
        0.1 + 0.6 * im,
        0.1 + 0.2 * im
    ]

    ind = rand(1:length(zs))

    jitter = 2*(-0.5 - 0.5 * im + rand() + rand() * im)
    c = zs[ind] + jitter / 5

    return c

end


n_iters = 1000000
min_depth = 20
max_depth = 100
max_deriv = 5000

println("Starting Julia set plot...")
gr()
plot_julia_set(n_iters, min_depth, max_depth, max_deriv)
println("Finished Julia set plot.")
