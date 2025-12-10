# Plot Item Characteristic Curves (IIC) from Exametrika

This function takes Exametrika output as input and generates Item
Characteristic Curves (IIC) using ggplot2. The applicable analytical
method is Item Response Theory (IRT).

## Usage

``` r
plotIIC_gg(data, xvariable = c(-4, 4))
```

## Arguments

- data:

  Exametrika output results

- xvariable:

  Specify the vector to set the drawing range at both ends of the x-axis
