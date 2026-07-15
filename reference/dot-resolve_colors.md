# Resolve the colors argument against the number of colors needed

If `colors` is NULL, the package default palette is used. If the user
supplies fewer colors than needed, a warning is issued and the colors
are recycled (instead of silently producing NA colors).

## Usage

``` r
.resolve_colors(colors, n)
```

## Arguments

- colors:

  User-supplied color vector or NULL.

- n:

  Number of colors needed.

## Value

A character vector of length `n`.
