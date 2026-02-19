# Plot Test Reference Profile (TRP) from exametrika

This function takes exametrika output as input and generates a Test
Reference Profile (TRP) plot using ggplot2. TRP shows the number of
students in each latent class/rank (bar graph) and the expected test
score for each class/rank (line graph).

## Usage

``` r
plotTRP_gg(
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

  An object from exametrika: LCA, LRA, Biclustering, IRM, LDB, or BINET
  output.

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

  Character or numeric specifying the line type for the expected score
  line. Default is `"dashed"`.

- show_legend:

  Logical. If `TRUE`, display the legend. Default is `FALSE`.

- legend_position:

  Character. Position of the legend. One of `"right"` (default),
  `"top"`, `"bottom"`, `"left"`, `"none"`.

## Value

A single ggplot object with dual y-axes showing both the student
distribution and expected scores.

## Details

The Test Reference Profile provides an overview of the latent structure.
The bar graph shows how students are distributed across classes/ranks,
while the line graph shows the expected test score for each class/rank.
In well-fitted models, expected scores should increase monotonically
with class/rank number.

## See also

[`plotIRP_gg`](https://kosugitti.github.io/ggExametrika/reference/plotIRP_gg.md),
[`plotLCD_gg`](https://kosugitti.github.io/ggExametrika/reference/plotLCD_gg.md),
[`plotLRD_gg`](https://kosugitti.github.io/ggExametrika/reference/plotLRD_gg.md)

## Examples

``` r
if (FALSE) { # \dontrun{
library(exametrika)
result <- LRA(J15S500, nrank = 5)
plot <- plotTRP_gg(result)
plot
} # }
```
