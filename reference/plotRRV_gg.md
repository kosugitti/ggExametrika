# Plot Rank Reference Vector (RRV) from exametrika

This function takes exametrika Biclustering output as input and
generates a Rank Reference Vector (RRV) plot using ggplot2. RRV shows
how each latent rank performs across fields, with one line per rank.

Supports both binary (2-valued) and polytomous (multi-valued)
biclustering models. For polytomous data, the `stat` parameter controls
how expected scores are calculated from category probabilities.

## Usage

``` r
plotRRV_gg(
  data,
  title = TRUE,
  colors = NULL,
  linetype = "solid",
  show_legend = TRUE,
  legend_position = "right",
  stat = "mean",
  show_labels = NULL
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

- stat:

  Character. Statistic for polytomous data: `"mean"` (default),
  `"median"`, or `"mode"`. For binary data, this parameter is ignored.

  - `"mean"`: Expected score (sum of category × probability)

  - `"median"`: Median category (cumulative probability \>= 0.5)

  - `"mode"`: Most probable category

- show_labels:

  Logical. If `TRUE`, displays rank labels on each point using `ggrepel`
  to avoid overlaps. Defaults to `FALSE` since the legend already
  provides rank information.

## Value

A single ggplot object showing the Rank Reference Vector.

## Details

The Rank Reference Vector is the transpose of the Field Reference
Profile (FRP). While FRP shows one plot per field, RRV displays all
ranks in a single plot with fields on the x-axis. Each line represents a
latent rank, showing its performance pattern across fields.

**Binary Data (2 categories):**

- Y-axis shows "Correct Response Rate" (0.0 to 1.0)

- Values represent the probability of correct response

**Polytomous Data (3+ categories):**

- Y-axis shows "Expected Score" (1 to max category)

- Values are calculated using the `stat` parameter

- Higher scores indicate better performance

RRV is used when latent ranks are ordinal (ordered). For unordered
latent classes, use
[`plotCRV_gg`](https://kosugitti.github.io/ggExametrika/reference/plotCRV_gg.md)
instead.

## See also

[`plotCRV_gg`](https://kosugitti.github.io/ggExametrika/reference/plotCRV_gg.md),
[`plotFRP_gg`](https://kosugitti.github.io/ggExametrika/reference/plotFRP_gg.md),
[`plotScoreField_gg`](https://kosugitti.github.io/ggExametrika/reference/plotScoreField_gg.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# Binary biclustering
library(exametrika)
result <- Biclustering(J15S500, nfld = 3, ncls = 5)
plotRRV_gg(result)

# Ordinal biclustering (polytomous)
data(J35S500)
result_ord <- Biclustering(J35S500, ncls = 5, nfld = 5, method = "R")
plotRRV_gg(result_ord)  # Default: mean
plotRRV_gg(result_ord, stat = "median")
plotRRV_gg(result_ord, stat = "mode")

# Custom styling
plotRRV_gg(result_ord,
  title = "Rank Performance Across Fields",
  colors = c("#1b9e77", "#d95f02", "#7570b3", "#e7298a", "#66a61e"),
  legend_position = "bottom"
)
} # }
```
