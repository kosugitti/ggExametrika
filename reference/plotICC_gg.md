# Plot Item Characteristic Curves (ICC) from Exametrika

This function takes Exametrika output as input and generates Item
Characteristic Curves (ICC) using ggplot2. The applicable analytical
method is Item Response Theory (IRT).

## Usage

``` r
plotICC_gg(data, xvariable = c(-4, 4))
```

## Arguments

- data:

  Exametrika output results

- xvariable:

  Specify the vector to set the drawing range at both ends of the x-axis
