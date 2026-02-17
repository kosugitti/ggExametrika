# Plot Rank Reference Vector (RRV) from exametrika

This function takes exametrika Biclustering output as input and
generates a Rank Reference Vector (RRV) plot using ggplot2. RRV shows
how each latent rank performs across fields, with one line per rank.

## Usage

``` r
plotRRV_gg(
  data,
  title = TRUE,
  colors = NULL,
  linetype = "solid",
  show_legend = TRUE,
  legend_position = "right"
)
```

## Arguments

- data:

  An object of class `c("exametrika", "Biclustering")` from
  [`exametrika::Biclustering()`](https://rdrr.io/pkg/exametrika/man/Biclustering.html).

- title:

  Logical or character. If `TRUE` (default), display an auto-generated
  title. If `FALSE`, no title. If a character string, use it as a custom
  title.

- colors:

  Character vector of colors for each rank. If `NULL` (default), a
  colorblind-friendly palette is used.

- linetype:

  Character or numeric vector specifying the line types. If a single
  value, all lines use that type. If a vector, each rank uses the
  corresponding type. Default is `"solid"`.

- show_legend:

  Logical. If `TRUE` (default), display the legend.

- legend_position:

  Character. Position of the legend. One of `"right"` (default),
  `"top"`, `"bottom"`, `"left"`, `"none"`.

## Value

A single ggplot object showing the Rank Reference Vector.

## Details

The Rank Reference Vector is the transpose of the Field Reference
Profile (FRP). While FRP shows one plot per field, RRV displays all
ranks in a single plot with fields on the x-axis. Each line represents a
latent rank, showing its correct response rate pattern across fields.

RRV is used when latent ranks are ordinal (ordered). For unordered
latent classes, use
[`plotCRV_gg`](https://kosugitti.github.io/ggExametrika/reference/plotCRV_gg.md)
instead.

## See also

[`plotCRV_gg`](https://kosugitti.github.io/ggExametrika/reference/plotCRV_gg.md),
[`plotFRP_gg`](https://kosugitti.github.io/ggExametrika/reference/plotFRP_gg.md)

## Examples

``` r
if (FALSE) { # \dontrun{
library(exametrika)
result <- Biclustering(J35S515, nfld = 5, ncls = 6)
plot <- plotRRV_gg(result)
plot
} # }
```
