# Plot Latent Class Distribution (LCD) from exametrika

This function takes exametrika output as input and generates a Latent
Class Distribution (LCD) plot using ggplot2. LCD shows the number of
students in each latent class and the class membership distribution.

## Usage

``` r
plotLCD_gg(data, Num_Students = TRUE, title = TRUE)
```

## Arguments

- data:

  An object of class `c("exametrika", "LCA")` or
  `c("exametrika", "BINET")`. If LRA or Biclustering output is provided,
  LRD will be plotted instead with a warning.

- Num_Students:

  Logical. If `TRUE` (default), display the number of students on each
  bar.

- title:

  Logical. If `TRUE` (default), display the plot title.

## Value

A single ggplot object with dual y-axes showing both the student count
and membership frequency.

## Details

The Latent Class Distribution shows how students are distributed across
latent classes. The bar graph shows the number of students assigned to
each class, and the line graph shows the cumulative class membership
distribution.

## See also

[`plotLRD_gg`](https://kosugitti.github.io/ggExametrika/reference/plotLRD_gg.md),
[`plotTRP_gg`](https://kosugitti.github.io/ggExametrika/reference/plotTRP_gg.md)

## Examples

``` r
if (FALSE) { # \dontrun{
library(exametrika)
result <- LCA(J15S500, ncls = 5)
plot <- plotLCD_gg(result)
plot
} # }
```
