# Plot All Item Characteristic Curves Overlaid from exametrika

This function takes exametrika IRT output as input and generates an
overlay plot of all Item Characteristic Curves (ICC) using ggplot2. All
item curves are displayed on a single graph for easy comparison.

## Usage

``` r
plotICC_overlay_gg(
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
  [`exametrika::IRT()`](https://rdrr.io/pkg/exametrika/man/IRT.html).

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

A single ggplot object showing all Item Characteristic Curves overlaid
on one graph.

## Details

This function is similar to calling
`plot(IRT_result, type = "IRF", overlay = TRUE)` in the exametrika
package, but returns a ggplot2 object that can be further customized.

The ICC is computed using the four-parameter logistic model:
\$\$P(\theta) = c + \frac{d - c}{1 + \exp(-a(\theta - b))}\$\$

## See also

[`plotICC_gg`](https://kosugitti.github.io/ggExametrika/reference/plotICC_gg.md),
[`plotIIC_gg`](https://kosugitti.github.io/ggExametrika/reference/plotIIC_gg.md)

## Examples

``` r
library(exametrika)
result <- IRT(J15S500, model = 3)
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
plotICC_overlay_gg(result) # All items

plotICC_overlay_gg(result, items = 1:5) # First 5 items only

plotICC_overlay_gg(result, title = "My Custom Title", show_legend = TRUE)
```
