# julia-julia

Plotting Julia sets with the Julia language

## Method

This implementation uses an inverse iteration approach for
computing the Julia set of a complex quadratic.
The algorithm iterates a point until a maximum
depth is reached,
or until the point no longer moves much.
The output images are 2K-resolution PNGs in the
[plots](./plots/)
directory,
alongside copies annotated with their parameter values.

## Usage

```
bash build.sh
```

## Dependencies

- Julia
- pdflatex
- pdfcrop
- ImageMagick
