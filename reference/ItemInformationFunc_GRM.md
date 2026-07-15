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

The information is Samejima's (1969) item information for the GRM,
computed identically to
[`exametrika::grm_iif`](https://kosugitti.github.io/exametrika/reference/grm_iif.html)
(\>= 1.15.0.9000) so that ggExametrika plots match the base plots of the
parent package: \$\$I(\theta) = \sum\_{k=1}^{K}
\frac{\[P_k'(\theta)\]^2}{P_k(\theta)}\$\$

where \\P_k(\theta) = P\_{k-1}^\*(\theta) - P_k^\*(\theta)\\ is the
category response probability, \\P_k^\*(\theta)\\ is the cumulative
(boundary) probability with \\P_0^\* = 1\\ and \\P_K^\* = 0\\, and
\\P_k^{\*\prime}(\theta) = a P_k^\*(\theta) \[1 - P_k^\*(\theta)\]\\.
The logistic metric of the parent package's estimation is used as is (no
1.702 scaling constant).

## See also

[`plotICRF_gg`](https://kosugitti.github.io/ggExametrika/reference/plotICRF_gg.md)

## Examples

``` r
# Information at ability = 0 for a 5-category item
ItemInformationFunc_GRM(theta = 0, a = 1.5, b = c(-1, -0.5, 0.5, 1))
#> [1] 0.7024022
```
