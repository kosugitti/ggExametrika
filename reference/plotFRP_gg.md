# Plot Field Reference Profile (FRP) from exametrika

This function takes exametrika output as input and generates a Field
Reference Profile (FRP) plot using ggplot2. For binary data, it displays
correct response rates. For polytomous data, it shows expected scores
calculated using the specified statistic.

## Usage

``` r
plotFRP_gg(
  data,
  stat = "mean",
  fields = NULL,
  title = TRUE,
  colors = NULL,
  linetype = "solid",
  show_legend = TRUE,
  legend_position = "right"
)
```

## Arguments

- data:

  An object from exametrika: Biclustering, nominalBiclustering,
  ordinalBiclustering, IRM, LDB, or BINET output.

- stat:

  Character. Statistic to use for polytomous data: `"mean"` (default),
  `"median"`, or `"mode"`. Ignored for binary data.

- fields:

  Integer vector specifying which fields to plot. Default is all fields.

- title:

  Logical or character. If `TRUE` (default), display automatic title. If
  `FALSE`, no title. If a character string, use it as the title.

- colors:

  Character vector. Colors for each field line. If `NULL` (default),
  uses the package default palette.

- linetype:

  Character or numeric. Line type for all lines. Default is `"solid"`.

- show_legend:

  Logical. If `TRUE` (default), display the legend.

- legend_position:

  Character. Position of the legend: `"right"` (default), `"top"`,
  `"bottom"`, `"left"`, `"none"`.

## Value

A single ggplot object with all selected fields.

## Details

The Field Reference Profile shows how response patterns vary across
latent classes/ranks for each field (cluster of items).

For **binary data** (Biclustering, IRM, LDB, BINET):

- Y-axis: Correct Response Rate (0-1)

- Each line represents one field

For **polytomous data** (nominalBiclustering, ordinalBiclustering):

- Y-axis: Expected Score (calculated using `stat` parameter)

- `stat = "mean"`: Weighted average across categories (default)

- `stat = "median"`: Median category value

- `stat = "mode"`: Most probable category

## See also

[`plotIRP_gg`](https://kosugitti.github.io/ggExametrika/reference/plotIRP_gg.md),
[`plotTRP_gg`](https://kosugitti.github.io/ggExametrika/reference/plotTRP_gg.md),
[`plotCRV_gg`](https://kosugitti.github.io/ggExametrika/reference/plotCRV_gg.md),
[`plotRRV_gg`](https://kosugitti.github.io/ggExametrika/reference/plotRRV_gg.md)

## Examples

``` r
if (FALSE) { # \dontrun{
library(exametrika)

# Binary biclustering
result_bin <- Biclustering(J35S515, ncls = 4, nfld = 3)
plot <- plotFRP_gg(result_bin)

# Ordinal biclustering with mean (default)
result_ord <- Biclustering(OrdinalData, ncls = 4, nfld = 3, dataType = "ordinal")
plot_mean <- plotFRP_gg(result_ord, stat = "mean")

# Using mode for polytomous data
plot_mode <- plotFRP_gg(result_ord, stat = "mode",
                        title = "Field Reference Profile (Mode)",
                        colors = c("red", "blue", "green"))
} # }
```
