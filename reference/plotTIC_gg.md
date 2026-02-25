# Plot Test Information Curve (TIC) from exametrika

This function takes exametrika IRT or GRM output as input and generates
a Test Information Curve (TIC) using ggplot2. TIC shows the total
information provided by all items at each ability level.

## Usage

``` r
plotTIC_gg(
  data,
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
  [`exametrika::IRT()`](https://rdrr.io/pkg/exametrika/man/IRT.html) or
  `c("exametrika", "GRM")` from
  [`exametrika::GRM()`](https://rdrr.io/pkg/exametrika/man/GRM.html).

- xvariable:

  A numeric vector of length 2 specifying the range of the x-axis
  (ability). Default is `c(-4, 4)`.

- title:

  Logical or character. If `TRUE` (default), display an auto-generated
  title. If `FALSE`, no title. If a character string, use it as a custom
  title.

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

A single ggplot object showing the Test Information Curve.

## Details

The Test Information Function is the sum of all Item Information
Functions. It indicates how precisely the test as a whole measures
ability at each point on the theta scale. The reciprocal of test
information is approximately equal to the squared standard error of
measurement.

The function supports IRT models (2PL, 3PL, 4PL) and GRM.

## See also

[`plotICC_gg`](https://kosugitti.github.io/ggExametrika/reference/plotICC_gg.md),
[`plotIIC_gg`](https://kosugitti.github.io/ggExametrika/reference/plotIIC_gg.md),
[`plotICRF_gg`](https://kosugitti.github.io/ggExametrika/reference/plotICRF_gg.md)

## Examples

``` r
library(exametrika)
# IRT example
result_irt <- IRT(J15S500, model = 3)
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
plot_irt <- plotTIC_gg(result_irt)
plot_irt # Show Test Information Curve


# GRM example
result_grm <- GRM(J5S1000)
#> Parameters: 18 | Initial LL: -6252.352 
#> initial  value 6252.351598 
#> iter  10 value 6032.463982
#> iter  20 value 6010.861094
#> final  value 6008.297278 
#> converged
plot_grm <- plotTIC_gg(result_grm)
plot_grm # Show Test Information Curve
```
