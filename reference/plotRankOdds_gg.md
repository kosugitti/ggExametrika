# Plot the rank-up and rank-down odds by rank

Box plots of the rank-up odds (membership of the next rank up over that
of the estimated rank) and the rank-down odds, by estimated rank, on a
log axis with a dashed line at 1. Odds near 1 mark respondents on the
border with the neighbouring rank. The ggplot2 version of
`plot(x, type = "RankOdds")` in exametrika.

## Usage

``` r
plotRankOdds_gg(data, floor = 1e-04, title = TRUE, fill = "grey85")
```

## Arguments

- data:

  A Ranklustering result of exametrika: an ordinal
  [`Biclustering()`](https://kosugitti.github.io/exametrika/reference/Biclustering.html)
  with `method = "R"`, or a binary or rated one.

- floor:

  Odds below this are drawn at this value. Default 1e-4.

- title:

  Logical or character, as in
  [`plotRankUpShift_gg`](https://kosugitti.github.io/ggExametrika/reference/plotRankUpShift_gg.md).

- fill:

  Fill colour of the boxes. Default `"grey85"`.

## Value

A ggplot object with two facets (rank-up and rank-down odds).

## Details

exametrika returns the odds in `Students` for the binary and rated
Ranklustering and, since 2.3.0, for the ordinal one. For an ordinal fit
from an earlier version they are computed here from the class membership
in the same way.

## See also

[`plotRankUpShift_gg`](https://kosugitti.github.io/ggExametrika/reference/plotRankUpShift_gg.md)

## Examples

``` r
# \donttest{
library(exametrika)
result <- Biclustering(J5S1000, ncls = 5, nfld = 2, method = "R")
plotRankOdds_gg(result)

# }
```
