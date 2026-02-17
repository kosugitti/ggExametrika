# Plot Array from exametrika

This function takes exametrika output as input and generates array plots
using ggplot2. Array plots visualize the response patterns of students
(rows) across items (columns), showing both the original data and the
clustered/reordered data.

Supports both binary (0/1) and multi-valued (ordinal/nominal) data.

## Usage

``` r
plotArray_gg(
  data,
  Original = TRUE,
  Clusterd = TRUE,
  Clusterd_lines = TRUE,
  Clusterd_lines_color = NULL,
  title = TRUE,
  colors = NULL,
  show_legend = NULL,
  legend_position = "right"
)
```

## Arguments

- data:

  An object of class `c("exametrika", "Biclustering")`,
  `c("exametrika", "nominalBiclustering")`,
  `c("exametrika", "ordinalBiclustering")`, `c("exametrika", "IRM")`,
  `c("exametrika", "LDB")`, or `c("exametrika", "BINET")`.

- Original:

  Logical. If `TRUE` (default), plot the original (unsorted) response
  data.

- Clusterd:

  Logical. If `TRUE` (default), plot the clustered (sorted by class and
  field) response data.

- Clusterd_lines:

  Logical. If `TRUE` (default), draw lines on the clustered plot to
  indicate class and field boundaries.

- Clusterd_lines_color:

  Character. Color of the boundary lines. If `NULL` (default), uses
  `"red"` for binary data or `"white"` for multi-valued data.

- title:

  Logical or character. If `TRUE` (default), display auto-generated
  titles. If `FALSE`, no titles. If a character string, use it as a
  custom title prefix.

- colors:

  Character vector of colors for each category. If `NULL` (default),
  uses white/black for binary data or a colorblind-friendly palette for
  multi-valued data.

- show_legend:

  Logical. If `TRUE`, display the legend. Default is `FALSE` for binary
  data, `TRUE` for multi-valued.

- legend_position:

  Character. Position of the legend. One of `"right"` (default),
  `"top"`, `"bottom"`, `"left"`, `"none"`.

## Value

A ggplot object or a grid arrangement of two ggplot objects (original
and clustered plots side by side).

## Details

The array plot provides a visual representation of the biclustering
result. For binary data, black cells indicate correct responses (1) and
white cells indicate incorrect responses (0). For multi-valued data,
different colors represent different response categories.

In a well-fitted model, the clustered plot should show a clear block
diagonal pattern where high-ability students (bottom rows) answer
difficult items (right columns) correctly.

## See also

[`plotFRP_gg`](https://kosugitti.github.io/ggExametrika/reference/plotFRP_gg.md),
[`plotTRP_gg`](https://kosugitti.github.io/ggExametrika/reference/plotTRP_gg.md)

## Examples

``` r
if (FALSE) { # \dontrun{
library(exametrika)
result <- Biclustering(J35S515, nfld = 5, ncls = 6)

# Basic usage
plotArray_gg(result)

# Custom boundary line color
plotArray_gg(result, Clusterd_lines_color = "blue")

# Multi-valued data with custom colors
synthetic_data <- matrix(sample(0:3, 50 * 20, replace = TRUE), nrow = 50, ncol = 20)
result_multi <- Biclustering(synthetic_data, nfld = 4, ncls = 5)
plotArray_gg(result_multi, show_legend = TRUE, Clusterd_lines_color = "darkgreen")
} # }
```
