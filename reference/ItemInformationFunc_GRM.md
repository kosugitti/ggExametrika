# GRM Item Information Function

Computes the Item Information Function (IIF) for the Graded Response
Model. The information function indicates how precisely an item measures
ability at different theta levels.

## Usage

``` r
ItemInformationFunc_GRM(theta, a, b)
```

## Arguments

- theta:

  Numeric. The ability parameter (theta).

- a:

  Numeric. The slope (discrimination) parameter.

- b:

  Numeric vector. The threshold (boundary) parameters.

## Value

A numeric value representing the item information at the given ability
level.

## Details

For GRM, the Item Information Function is computed as: \$\$I(\theta) =
a^2 \sum\_{k=1}^{K-1} P_k^\*(\theta) \[1 - P_k^\*(\theta)\]\$\$

where \\P_k^\*(\theta)\\ is the cumulative probability of scoring in
category \\k\\ or above.

## See also

[`plotICRF_gg`](https://kosugitti.github.io/ggExametrika/reference/plotICRF_gg.md)

## Examples

``` r
# Information at ability = 0 for a 5-category item
ItemInformationFunc_GRM(theta = 0, a = 1.5, b = c(-1, -0.5, 0.5, 1))
#> [1] 1.651687
```
