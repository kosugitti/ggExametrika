# Shared worker for plotCRV_gg / plotRRV_gg

The two exported functions differ only in the series prefix ("C"/"R")
and the display name ("Class"/"Rank").

## Usage

``` r
.plot_reference_vector(
  data,
  title,
  colors,
  linetype,
  show_legend,
  legend_position,
  stat,
  show_labels,
  prefix,
  unit_name
)
```

## Arguments

- data:

  An object of class `c("exametrika", "Biclustering")` from
  [`exametrika::Biclustering()`](https://kosugitti.github.io/exametrika/reference/Biclustering.html).

- title:

  Logical or character. If `TRUE` (default), display an auto-generated
  title. If `FALSE`, no title. If a character string, use it as a custom
  title.

- colors:

  Character vector of colors for each class. If `NULL` (default), a
  colorblind-friendly palette is used.

- linetype:

  Character or numeric scalar specifying the line type applied to all
  lines. Default is `"solid"`.

- show_legend:

  Logical. If `TRUE` (default), display the legend.

- legend_position:

  Character. Position of the legend. One of `"right"` (default),
  `"top"`, `"bottom"`, `"left"`, `"none"`.

- stat:

  Character. Statistic for polytomous data: `"mean"` (default),
  `"median"`, or `"mode"`. For binary data, this parameter is ignored.

  - `"mean"`: Expected score (sum of category x probability)

  - `"median"`: Median category (cumulative probability \>= 0.5)

  - `"mode"`: Most probable category

- show_labels:

  Logical. If `TRUE`, displays class labels on each point using
  `ggrepel` to avoid overlaps. Defaults to `FALSE` since the legend
  already provides class information.

- prefix:

  Single letter prepended to the series labels.

- unit_name:

  Display name used in the auto title.

## Value

A ggplot object.
