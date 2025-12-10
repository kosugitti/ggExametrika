# Plot Latent Rank Distribution (LRD) from exametrika

This function takes exametrika output as input and generates a Latent
Rank Distribution (LRD) plot using ggplot2. LRD shows the number of
students in each latent rank and the rank membership distribution.

## Usage

``` r
plotLRD_gg(data, Num_Students = TRUE, title = TRUE)
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

  Logical. If `TRUE` (default), display the plot title.

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
