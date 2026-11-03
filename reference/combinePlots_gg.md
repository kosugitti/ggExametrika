# Display Multiple Plots Simultaneously from ggExametrika Output

This function arranges multiple ggplot objects from ggExametrika
functions into a single display using a grid layout. Useful for
comparing plots across items or students.

## Usage

``` r
combinePlots_gg(plots, selectPlots = c(1:6), nr = NULL, nc = NULL)
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

- nr:

  Number of rows of the grid. Default `NULL` lets
  [`gridExtra::grid.arrange`](https://rdrr.io/pkg/gridExtra/man/arrangeGrob.html)
  choose.

- nc:

  Number of columns of the grid. Default `NULL` lets
  [`gridExtra::grid.arrange`](https://rdrr.io/pkg/gridExtra/man/arrangeGrob.html)
  choose. The names follow the `nr`/`nc` arguments of `plot.exametrika`.

## Value

A gtable object containing the arranged plots, displayed as a side
effect.

## Details

This function uses
[`gridExtra::grid.arrange`](https://rdrr.io/pkg/gridExtra/man/arrangeGrob.html)
to combine multiple plots. The number of rows and columns is determined
automatically unless `nr` and/or `nc` are given. When only one of them
is given the other follows from the number of plots. Selected plots are
placed row by row. For more control over layout, use
[`gridExtra::grid.arrange`](https://rdrr.io/pkg/gridExtra/man/arrangeGrob.html)
directly.

## Examples

``` r
library(exametrika)
#> 
#> Attaching package: ‘exametrika’
#> The following objects are masked from ‘package:ggExametrika’:
#> 
#>     ItemInformationFunc, LogisticModel
result <- IRT(J15S500, model = 3)
plots <- plotICC_gg(result)
combinePlots_gg(plots, selectPlots = 1:6) # Show first 6 items

combinePlots_gg(plots, selectPlots = c(1, 5, 10)) # Show specific items

combinePlots_gg(plots, selectPlots = 1:9, nr = 3, nc = 3) # 3 x 3 grid
```
