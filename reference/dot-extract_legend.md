# Pull the guide box out of a ggplot

Used to share one legend between the two array panels instead of drawing
the same one twice. Returns NULL when the plot carries no legend.

## Usage

``` r
.extract_legend(p)
```

## Arguments

- p:

  A ggplot object, already themed with the wanted legend position so
  that the guide box has the matching orientation.

## Value

A grob, or NULL.
