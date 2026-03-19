# Display Multiple Plots Simultaneously from ggExametrika Output

This function arranges multiple ggplot objects from ggExametrika
functions into a single display using a grid layout. Useful for
comparing plots across items or students.

## Usage

``` r
combinePlots_gg(plots, selectPlots = c(1:6))
```

## Arguments

- plots:

  A list of ggplot objects, typically output from functions like
  [`plotICC_gg`](https://kosugitti.github.io/ggExametrika/reference/plotICC_gg.md),
  [`plotIRP_gg`](https://kosugitti.github.io/ggExametrika/reference/plotIRP_gg.md),
  etc.

- selectPlots:

  A numeric vector specifying which plots to display. Default is `1:6`
  (first 6 plots). Indices exceeding the list length are automatically
  excluded.

## Value

A gtable object containing the arranged plots, displayed as a side
effect.

## Details

This function uses
[`gridExtra::grid.arrange`](https://rdrr.io/pkg/gridExtra/man/arrangeGrob.html)
to combine multiple plots. The number of rows and columns is
automatically determined. For more control over layout, consider using
[`gridExtra::grid.arrange`](https://rdrr.io/pkg/gridExtra/man/arrangeGrob.html)
directly with the `nrow` and `ncol` arguments.

## Examples

``` r
library(exametrika)
#> 
#> Attaching package: ‘exametrika’
#> The following objects are masked from ‘package:ggExametrika’:
#> 
#>     ItemInformationFunc, LogisticModel
result <- IRT(J15S500, model = 3)
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
plots <- plotICC_gg(result)
combinePlots_gg(plots, selectPlots = 1:6) # Show first 6 items

combinePlots_gg(plots, selectPlots = c(1, 5, 10)) # Show specific items
```
