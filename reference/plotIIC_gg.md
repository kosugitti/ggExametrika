# Plot Item Information Curves (IIC) from exametrika

This function takes exametrika IRT or GRM output as input and generates
Item Information Curves (IIC) using ggplot2. IIC shows how much
information each item provides at different ability levels.

## Usage

``` r
plotIIC_gg(
  data,
  items = NULL,
  xvariable = c(-4, 4),
  title = TRUE,
  colors = NULL,
  linetype = "solid",
  show_legend = FALSE,
  legend_position = "right"
)
```

## Arguments

- data:

  An object of class `c("exametrika", "IRT")` from
  [`exametrika::IRT()`](https://kosugitti.github.io/exametrika/reference/IRT.html)
  or `c("exametrika", "GRM")` from
  [`exametrika::GRM()`](https://kosugitti.github.io/exametrika/reference/GRM.html).

- items:

  Numeric vector specifying which items to plot. If `NULL` (default),
  all items are plotted.

- xvariable:

  A numeric vector of length 2 specifying the range of the x-axis
  (ability). Default is `c(-4, 4)`.

- title:

  Logical or character. If `TRUE` (default), display an auto-generated
  title. If `FALSE`, no title. If a character string, use it as a custom
  title (only for single-item plots).

- colors:

  Character vector of colors. For IRT, single color for the curve. If
  `NULL` (default), a colorblind-friendly palette is used.

- linetype:

  Character or numeric specifying the line type. Default is `"solid"`.

- show_legend:

  Logical. If `TRUE`, display the legend (mainly for GRM). Default is
  `FALSE`.

- legend_position:

  Character. Position of the legend. One of `"right"` (default),
  `"top"`, `"bottom"`, `"left"`, `"none"`.

## Value

A list of ggplot objects, one for each item. Each plot shows the Item
Information Curve for that item.

## Details

The Item Information Function indicates how precisely an item measures
ability at each point on the theta scale. Items with higher
discrimination parameters provide more information. The peak of the
information curve occurs near the item's difficulty parameter.

For IRT models (2PL, 3PL, 4PL), the function uses the standard IRT
information function. For GRM, the information is computed as:
\$\$I(\theta) = a^2 \sum\_{k=1}^{K-1} P_k^\*(\theta) \[1 -
P_k^\*(\theta)\]\$\$

## See also

[`plotICC_gg`](https://kosugitti.github.io/ggExametrika/reference/plotICC_gg.md),
[`plotTIC_gg`](https://kosugitti.github.io/ggExametrika/reference/plotTIC_gg.md),
[`plotICRF_gg`](https://kosugitti.github.io/ggExametrika/reference/plotICRF_gg.md)

## Examples

``` r
library(exametrika)
# \donttest{
# IRT example
result_irt <- IRT(J15S500, model = 3)
#> No ID column detected. All columns treated as response data. Sequential IDs (Student1, Student2, ...) were generated. Use id= parameter to specify the ID column explicitly.
#> No ID column detected. All columns treated as response data. Sequential IDs (Student1, Student2, ...) were generated. Use id= parameter to specify the ID column explicitly.
#> iter 1 LogLik -3960.28                                                          
#> iter 2 LogLik -3938.35                                                          
#> iter 3 LogLik -3931.82                                                          
#> iter 4 LogLik -3928.68                                                          
#> iter 5 LogLik -3926.99                                                          
#> iter 6 LogLik -3926.05                                                          
#> iter 7 LogLik -3925.51                                                          
#> iter 8 LogLik -3925.19                                                          
#> iter 9 LogLik -3925.01                                                          
#> iter 10 LogLik -3924.9                                                          
#> iter 11 LogLik -3924.84                                                         
#> iter 12 LogLik -3924.8                                                          
#> iter 13 LogLik -3924.77                                                         
plots_irt <- plotIIC_gg(result_irt)
plots_irt[[1]] # Show IIC for the first item


# GRM example
result_grm <- GRM(J5S1000)
#> Parameters: 18 | Initial LL: -6252.352 
#> initial  value 6252.351598 
#> iter  10 value 6032.463982
#> iter  20 value 6010.861094
#> final  value 6008.297278 
#> converged
plots_grm <- plotIIC_gg(result_grm)
plots_grm[[1]] # Show IIC for the first item

# }
```
