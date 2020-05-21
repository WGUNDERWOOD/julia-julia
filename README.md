# julia-julia

Plotting Julia sets with the Julia language

## Method

This implementation uses an escape-time approach for
computing the Julia set of a complex quadratic:

f(z) = z<sup>2</sup> + c

The algorithm iterates a point until
either it escapes a ball around the origin,
or a maximum number of iterations is reached.
Points are coloured by their time until escape,
producing a (filled) Julia set.
Julia sets with random parameter values
are generated and discarded
at low resolution
until one is found
which contains many
escaping and many non-escaping pixels,
to avoid returning uninteresting plots.
This is then plotted at full resolution.

The output images are saved as high-resolution PNGs in the
`plots` directory,
alongside copies annotated with their parameter values.

The first time the script is run, it will be very slow while
Julia compiles a system image for future use.

The `change_wallpaper_julia` script allows me to set the annotated
plots as my desktop wallpaper.
It won't run on your system.
Sorry.

## Usage

```
bash build.sh
```

## Dependencies

- Julia
  - Julia "Images" library
- pdflatex
- pdfcrop
- ImageMagick
