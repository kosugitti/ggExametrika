# Plot Item Reference Profile (IRP) from exametrika

This function takes exametrika output as input and generates Item
Reference Profile (IRP) plots using ggplot2. IRP shows the probability
of a correct response for each item at each latent class or rank level.

## Usage

``` r
plotIRP_gg(data)
```

## Arguments

- data:

  An object of class `c("exametrika", "LCA")`, `c("exametrika", "LRA")`,
  or `c("exametrika", "LDLRA")`.

## Value

A list of ggplot objects, one for each item. Each plot shows the correct
response rate across latent classes or ranks.

## Details

The Item Reference Profile visualizes how item difficulty varies across
latent classes (LCA) or ranks (LRA, LDLRA). Items with monotonically
increasing profiles indicate good discrimination between classes/ranks.

## See also

[`plotFRP_gg`](https://kosugitti.github.io/ggExametrika/reference/plotFRP_gg.md),
[`plotTRP_gg`](https://kosugitti.github.io/ggExametrika/reference/plotTRP_gg.md)

## Examples

``` r
if (FALSE) { # \dontrun{
library(exametrika)
result <- LRA(J15S500, nrank = 5)
plots <- plotIRP_gg(result)
plots[[1]] # Show IRP for the first item
} # }
```
