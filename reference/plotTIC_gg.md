# Plot Test Information Curve (TIC) from exametrika

This function takes exametrika IRT output as input and generates a Test
Information Curve (TIC) using ggplot2. TIC shows the total information
provided by all items at each ability level.

## Usage

``` r
plotTIC_gg(data, xvariable = c(-4, 4))
```

## Arguments

- data:

  An object of class `c("exametrika", "IRT")` from
  [`exametrika::IRT()`](https://rdrr.io/pkg/exametrika/man/IRT.html).

- xvariable:

  A numeric vector of length 2 specifying the range of the x-axis
  (ability). Default is `c(-4, 4)`.

## Value

A single ggplot object showing the Test Information Curve.

## Details

The Test Information Function is the sum of all Item Information
Functions. It indicates how precisely the test as a whole measures
ability at each point on the theta scale. The reciprocal of test
information is approximately equal to the squared standard error of
measurement.

The function supports 2PL, 3PL, and 4PL IRT models.

## See also

[`plotICC_gg`](https://kosugitti.github.io/ggExametrika/reference/plotICC_gg.md),
[`plotIIC_gg`](https://kosugitti.github.io/ggExametrika/reference/plotIIC_gg.md)

## Examples

``` r
if (FALSE) { # \dontrun{
library(exametrika)
result <- IRT(J15S500, model = 3)
plot <- plotTIC_gg(result)
plot  # Show Test Information Curve
} # }
```
