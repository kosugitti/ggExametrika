# Plot All Item Information Curves Overlaid from exametrika

This function takes exametrika IRT or GRM output as input and generates
an overlay plot of all Item Information Curves (IIC) using ggplot2. All
item curves are displayed on a single graph for easy comparison.

## Usage

``` r
plotIIC_overlay_gg(
  data,
  items = NULL,
  xvariable = c(-4, 4),
  title = TRUE,
  colors = NULL,
  linetype = "solid",
  show_legend = TRUE,
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
  title.

- colors:

  Character vector of colors for each item. If `NULL` (default), a
  colorblind-friendly palette is used.

- linetype:

  Character or numeric specifying the line type. Can be a single value
  for all items or a vector for each item. Default is `"solid"`.

- show_legend:

  Logical. If `TRUE` (default), display the legend.

- legend_position:

  Character. Position of the legend. One of `"right"` (default),
  `"top"`, `"bottom"`, `"left"`, `"none"`.

## Value

A single ggplot object showing all Item Information Curves overlaid on
one graph.

## Details

This function is similar to calling
`plot(IRT_result, type = "IIF", overlay = TRUE)` or
`plot(GRM_result, type = "IIF", overlay = TRUE)` in the exametrika
package, but returns a ggplot2 object that can be further customized.

The Item Information Function indicates how precisely an item measures
ability at each point on the theta scale. Items with higher
discrimination parameters provide more information. The peak of the
information curve occurs near the item's difficulty parameter.

## See also

[`plotIIC_gg`](https://kosugitti.github.io/ggExametrika/reference/plotIIC_gg.md),
[`plotICC_gg`](https://kosugitti.github.io/ggExametrika/reference/plotICC_gg.md)

## Examples

``` r
library(exametrika)
# IRT example
result_irt <- IRT(J15S500, model = 3)
#> No ID column detected. All columns treated as response data. Sequential IDs (Student1, Student2, ...) were generated. Use id= parameter to specify the ID column explicitly.
#> No ID column detected. All columns treated as response data. Sequential IDs (Student1, Student2, ...) were generated. Use id= parameter to specify the ID column explicitly.
#> 
iter 1 LogLik -3960.28                                                          
#> 
iter 2 LogLik -3938.35                                                          
#> 
iter 3 LogLik -3931.82                                                          
#> 
iter 4 LogLik -3928.68                                                          
#> 
iter 5 LogLik -3926.99                                                          
#> 
iter 6 LogLik -3926.05                                                          
#> 
iter 7 LogLik -3925.51                                                          
#> 
iter 8 LogLik -3925.19                                                          
#> 
iter 9 LogLik -3925.01                                                          
#> 
iter 10 LogLik -3924.9                                                          
#> 
iter 11 LogLik -3924.84                                                         
#> 
iter 12 LogLik -3924.8                                                          
#> 
iter 13 LogLik -3924.77                                                         
plotIIC_overlay_gg(result_irt) # All items

plotIIC_overlay_gg(result_irt, items = 1:5) # First 5 items only


# GRM example
result_grm <- GRM(J5S1000)
#> Parameters: 18 | Initial LL: -6252.352 
#> initial  value 6252.351598 
#> iter  10 value 6032.463982
#> iter  20 value 6010.861094
#> final  value 6008.297278 
#> converged
plotIIC_overlay_gg(result_grm, show_legend = TRUE)
```
