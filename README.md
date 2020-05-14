# julia-julia

Plotting Julia sets with the Julia language

## Method

This implementation uses an inverse iteration approach for
computing the Julia set of a complex quadratic:

f(z) = z<sup>2</sup> + c

The algorithm inverse-iterates a point until a maximum
depth is reached,
or until the point no longer moves much.
Julia sets are generated and discarded until one is found
which contains many filled pixels,
to avoid returning mostly-empty plots.

The output images are saved as 2K-resolution PNGs in the
plots directory,
alongside copies annotated with their parameter values.

The first time the script is run, it will be very slow while
Julia compiles a system image for future use.

## Usage

```
bash build.sh
```

## Dependencies

- Julia
- pdflatex
- pdfcrop
- ImageMagick
