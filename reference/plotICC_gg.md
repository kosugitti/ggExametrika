# Plot Item Characteristic Curves (ICC) from exametrika

This function takes exametrika IRT output as input and generates Item
Characteristic Curves (ICC) using ggplot2. ICC shows the probability of
a correct response as a function of ability (theta).

## Usage

``` r
plotICC_gg(data, xvariable = c(-4, 4))
```

## Arguments

- data:

  An object of class `c("exametrika", "IRT")` from
  [`exametrika::IRT()`](https://rdrr.io/pkg/exametrika/man/IRT.html).

- xvariable:

  A numeric vector of length 2 specifying the range of the x-axis
  (ability). Default is `c(-4, 4)`.

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
if (FALSE) { # \dontrun{
library(exametrika)
result <- IRT(J15S500, model = 3)
plots <- plotICC_gg(result)
plots[[1]] # Show ICC for the first item
combinePlots_gg(plots, selectPlots = 1:6) # Show first 6 items
} # }
```
