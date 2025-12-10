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
if (FALSE) { # \dontrun{
library(exametrika)
result <- IRT(J15S500, model = 3)
plots <- plotICC_gg(result)
combinePlots_gg(plots, selectPlots = 1:6)  # Show first 6 items
combinePlots_gg(plots, selectPlots = c(1, 5, 10))  # Show specific items
} # }
```
