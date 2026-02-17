# Plot Test Response Function (TRF) from exametrika

This function takes exametrika IRT output as input and generates a Test
Response Function (TRF) using ggplot2. TRF shows the expected total
score as a function of ability (theta).

## Usage

``` r
plotTRF_gg(data, xvariable = c(-4, 4))
```

## Arguments

- data:

  An object of class `c("exametrika", "IRT")` from
  [`exametrika::IRT()`](https://rdrr.io/pkg/exametrika/man/IRT.html).

- xvariable:

  A numeric vector of length 2 specifying the range of the x-axis
  (ability). Default is `c(-4, 4)`.

## Value

A single ggplot object showing the Test Response Function.

## Details

The Test Response Function is the sum of all Item Characteristic Curves
(ICCs). At each ability level, TRF represents the expected number of
correct responses across all items. For a test with \\J\\ items:
\$\$TRF(\theta) = \sum\_{j=1}^{J} P_j(\theta)\$\$

The y-axis ranges from 0 to the total number of items. The function
supports 2PL, 3PL, and 4PL IRT models.

## See also

[`plotICC_gg`](https://kosugitti.github.io/ggExametrika/reference/plotICC_gg.md),
[`plotTIC_gg`](https://kosugitti.github.io/ggExametrika/reference/plotTIC_gg.md)

## Examples

``` r
if (FALSE) { # \dontrun{
library(exametrika)
result <- IRT(J15S500, model = 3)
plot <- plotTRF_gg(result)
plot # Show Test Response Function
} # }
```
