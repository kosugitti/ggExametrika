# Plot Item Information Curves (IIC) from exametrika

This function takes exametrika IRT output as input and generates Item
Information Curves (IIC) using ggplot2. IIC shows how much information
each item provides at different ability levels.

## Usage

``` r
plotIIC_gg(data, xvariable = c(-4, 4))
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
Information Curve for that item.

## Details

The Item Information Function indicates how precisely an item measures
ability at each point on the theta scale. Items with higher
discrimination parameters provide more information. The peak of the
information curve occurs near the item's difficulty parameter.

The function supports 2PL, 3PL, and 4PL IRT models.

## See also

[`plotICC_gg`](https://kosugitti.github.io/ggExametrika/reference/plotICC_gg.md),
[`plotTIC_gg`](https://kosugitti.github.io/ggExametrika/reference/plotTIC_gg.md)

## Examples

``` r
if (FALSE) { # \dontrun{
library(exametrika)
result <- IRT(J15S500, model = 3)
plots <- plotIIC_gg(result)
plots[[1]]  # Show IIC for the first item
combinePlots_gg(plots, selectPlots = 1:6)  # Show first 6 items
} # }
```
