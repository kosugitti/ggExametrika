# Rescale a secondary-axis variable into primary-axis coordinates

Used by the distribution plots (LCD/LRD/TRP) to overlay a frequency
polygon on a bar chart with a different y-scale.

## Usage

``` r
.variable_scaler(y2, yaxis1, yaxis2)
```

## Arguments

- y2:

  Values on the secondary scale.

- yaxis1:

  Range (min, max) of the primary axis.

- yaxis2:

  Range (min, max) of the secondary axis.

## Value

`y2` linearly mapped into primary-axis coordinates.
