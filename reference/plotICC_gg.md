# Plot Item Characteristic Curves (ICC) from exametrika

This function takes exametrika IRT output as input and generates Item
Characteristic Curves (ICC) using ggplot2. ICC shows the probability of
a correct response as a function of ability (theta).

## Usage

``` r
plotICC_gg(
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
  [`exametrika::IRT()`](https://kosugitti.github.io/exametrika/reference/IRT.html).

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

  Character vector. Color(s) for the curve. If `NULL` (default), a
  colorblind-friendly palette is used.

- linetype:

  Character or numeric specifying the line type. Default is `"solid"`.

- show_legend:

  Logical. If `TRUE`, display the legend. Default is `FALSE`.

- legend_position:

  Character. Position of the legend. One of `"right"` (default),
  `"top"`, `"bottom"`, `"left"`, `"none"`.

## Value

A list of ggplot objects, one for each item. Each plot shows the Item
Characteristic Curve for that item.

## Details

The function supports 2PL, 3PL, and 4PL IRT models:

- 2PL: slope (a) and location (b) parameters

- 3PL: adds lower asymptote (c) parameter

- 4PL: adds upper asymptote (d) parameter

The ICC is computed using the four-parameter logistic model:
\$\$P(\theta) = c + \frac{d - c}{1 + \exp(-a(\theta - b))}\$\$

## See also

[`plotIIC_gg`](https://kosugitti.github.io/ggExametrika/reference/plotIIC_gg.md),
[`plotTIC_gg`](https://kosugitti.github.io/ggExametrika/reference/plotTIC_gg.md)

## Examples

``` r
library(exametrika)
result <- IRT(J15S500, model = 3)
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
plots <- plotICC_gg(result)
plots[[1]] # Show ICC for the first item

combinePlots_gg(plots, selectPlots = 1:6) # Show first 6 items
```
