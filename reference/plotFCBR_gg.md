# Plot Field Cumulative Boundary Reference from exametrika

This function takes exametrika ordinalBiclustering output as input and
generates a Field Cumulative Boundary Reference (FCBR) plot using
ggplot2. The plot shows cumulative probability curves for each category
boundary across latent classes or ranks. For each field, multiple lines
represent the probability of scoring at or above each category boundary.

## Usage

``` r
plotFCBR_gg(
  data,
  fields = NULL,
  title = TRUE,
  colors = NULL,
  linetype = NULL,
  show_legend = TRUE,
  legend_position = "right"
)
```

## Arguments

- data:

  An object of class `c("exametrika", "ordinalBiclustering")` from
  [`exametrika::Biclustering()`](https://rdrr.io/pkg/exametrika/man/Biclustering.html)
  with `dataType = "ordinal"`.

- fields:

  Integer vector specifying which fields to plot. Default is all fields.

- title:

  Logical or character. If `TRUE` (default), display field labels as
  subplot titles. If `FALSE`, no titles. If a character string, use it
  as the main plot title.

- colors:

  Character vector. Colors for category boundary lines. If `NULL`
  (default), uses the package default palette.

- linetype:

  Character or numeric vector. Line types for category boundaries. If
  `NULL` (default), uses automatic line type assignment.

- show_legend:

  Logical. If `TRUE`, display the legend showing boundary labels.
  Default is `TRUE`.

- legend_position:

  Character. Position of the legend. One of `"right"` (default),
  `"top"`, `"bottom"`, `"left"`, `"none"`.

## Value

A single ggplot object with faceted subplots for each field.

## Details

The Field Cumulative Boundary Reference (FCBR) visualizes how the
probability of reaching each category boundary changes across latent
classes or ranks in ordinal biclustering. This is particularly useful
for understanding the difficulty of each response category threshold
across different ability levels.

For a field with \\K\\ categories (1, 2, ..., K), the FCBR shows:

- Line 1: P(response \>= 2 \| class/rank)

- Line 2: P(response \>= 3 \| class/rank)

- ...

- Line K-1: P(response \>= K \| class/rank)

The boundary probabilities are calculated by summing the probabilities
of all categories at or above the boundary threshold. Higher
classes/ranks (higher ability) typically show higher probabilities for
higher boundaries.

## See also

`plotFCRP_gg`, `plotScoreField_gg`,
[`plotArray_gg`](https://kosugitti.github.io/ggExametrika/reference/plotArray_gg.md)

## Examples

``` r
if (FALSE) { # \dontrun{
library(exametrika)
# Ordinal biclustering example with polytomous data
result <- Biclustering(OrdinalData, ncls = 4, dataType = "ordinal")

# Plot first 4 fields
plot <- plotFCBR_gg(result, fields = 1:4)
plot

# Custom colors and title
plot <- plotFCBR_gg(result, fields = 1:6,
                    title = "Field Cumulative Boundary Reference",
                    colors = c("red", "blue", "green", "purple"))
plot
} # }
```
