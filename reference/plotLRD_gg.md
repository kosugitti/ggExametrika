# Plot Latent Rank Distribution (LRD) from exametrika

This function takes exametrika output as input and generates a Latent
Rank Distribution (LRD) plot using ggplot2. LRD shows the number of
students in each latent rank and the rank membership distribution.

## Usage

``` r
plotLRD_gg(
  data,
  Num_Students = TRUE,
  title = TRUE,
  colors = NULL,
  linetype = "dashed",
  show_legend = FALSE,
  legend_position = "right"
)
```

## Arguments

- data:

  An object of class `c("exametrika", "LRA")`,
  `c("exametrika", "Biclustering")`, `c("exametrika", "LDLRA")`, or
  `c("exametrika", "LDB")`. If LCA or BINET output is provided, LCD will
  be plotted instead with a warning.

- Num_Students:

  Logical. If `TRUE` (default), display the number of students on each
  bar.

- title:

  Logical or character. If `TRUE` (default), display the auto-generated
  title. If `FALSE`, no title. If a character string, use it as a custom
  title.

- colors:

  Character vector of length 2. First element is the bar fill color,
  second is the line/point color. If `NULL` (default), uses gray for
  bars and black for line/points.

- linetype:

  Character or numeric specifying the line type for the frequency line.
  Default is `"dashed"`.

- show_legend:

  Logical. If `TRUE`, display the legend. Default is `FALSE`.

- legend_position:

  Character. Position of the legend. One of `"right"` (default),
  `"top"`, `"bottom"`, `"left"`, `"none"`.

## Value

A single ggplot object with dual y-axes showing both the student count
and membership frequency.

## Details

The Latent Rank Distribution shows how students are distributed across
latent ranks. Unlike latent classes, ranks have an ordinal
interpretation where higher ranks indicate higher ability levels.

## See also

[`plotLCD_gg`](https://kosugitti.github.io/ggExametrika/reference/plotLCD_gg.md),
[`plotTRP_gg`](https://kosugitti.github.io/ggExametrika/reference/plotTRP_gg.md)

## Examples

``` r
if (FALSE) { # \dontrun{
library(exametrika)
result <- LRA(J15S500, nrank = 5)
plot <- plotLRD_gg(result)
plot
} # }
```
