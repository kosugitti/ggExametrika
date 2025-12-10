# Plot Field Reference Profile (FRP) from exametrika

This function takes exametrika output as input and generates Field
Reference Profile (FRP) plots using ggplot2. FRP shows the correct
response rate for each field (item cluster) at each latent class or rank
level.

## Usage

``` r
plotFRP_gg(data)
```

## Arguments

- data:

  An object of class `c("exametrika", "Biclustering")`,
  `c("exametrika", "IRM")`, `c("exametrika", "LDB")`, or
  `c("exametrika", "BINET")`.

## Value

A list of ggplot objects, one for each field. Each plot shows the
correct response rate across latent classes or ranks.

## Details

In biclustering models, items are grouped into fields. The Field
Reference Profile shows how each field's correct response rate varies
across latent classes or ranks. Fields with monotonically increasing
profiles indicate good alignment with the latent structure.

## See also

[`plotIRP_gg`](https://kosugitti.github.io/ggExametrika/reference/plotIRP_gg.md),
[`plotTRP_gg`](https://kosugitti.github.io/ggExametrika/reference/plotTRP_gg.md)

## Examples

``` r
if (FALSE) { # \dontrun{
library(exametrika)
result <- Biclustering(J35S515, nfld = 5, ncls = 6)
plots <- plotFRP_gg(result)
plots[[1]]  # Show FRP for the first field
} # }
```
