# Sequential palette for ordered categories

Returns a light-to-dark green ramp. Ordered response categories carry an
order, so a qualitative palette hides the very thing the plot is meant
to show; a sequential ramp maps the category index onto lightness.

## Usage

``` r
.gg_exametrika_sequential(n)
```

## Arguments

- n:

  Number of steps needed.

## Value

A character vector of hex color codes, lightest first.
