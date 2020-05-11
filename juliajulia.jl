using Revise
using Random
using Plots
using Profile

gr()



# keep track of rounded points in points array
# iterate working array
# round and unique
# update points array
# remove from working array


function f_inv_rand(z, c)

    if Random.bitrand(1)[1]
        return sqrt(z - c)
    else
        return -sqrt(z - c)
    end
end


function round_complex(z, prec)

    x = real.(z)
    y = imag.(z)
    x_round = trunc.(x, digits = prec, base = 2)
    y_round = trunc.(y, digits = prec, base = 2)
    z_round = x_round + y_round * im
    return z_round
end


function f_inv_rand_round(z, c, prec)

    return round_complex.(f_inv_rand.(z, c), prec)
end


function cat_unique(x, y)

    return unique(vcat(x, y))
end


function julia_iteration(points, c, prec)

    return cat_unique(points, f_inv_rand_round(points, c, prec))

end


function julia_iterations(c, prec, n_iters)

    points = complex(zeros(1))

    for i = 2:n_iters

        points = julia_iteration(points, c, prec)
        println(i)
        println(length(points))
    end

    return points
end


const n_iters = 100
const prec = 11
const c = 0.69 * im


@time points = julia_iterations(c, prec, n_iters)
num_to_discard = Int(round(0.2 * length(points)))
points = points[num_to_discard:end]
points_real = real(points)
points_imag = imag(points)

scatter(points_real,
        points_imag,
        markersize = 0.3,
        markershape=:circle,
        markerstrokewidth=0,
        dpi = 1000,
        axis = nothing,
        border = :none,
        legend = nothing,
        color = RGB(0.9, 0.9, 0.9),
        background_color = RGB(0.1, 0.1, 0.1)
)

savefig("./julia_set.png")
