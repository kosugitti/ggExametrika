# Four-Parameter Logistic Model

Computes the probability of a correct response using the four-parameter
logistic model (4PLM) in Item Response Theory.

## Usage

``` r
LogisticModel(x, a = 1, b, c = 0, d = 1)
```

## Arguments

- x:

  Numeric. The ability parameter (theta).

- a:

  Numeric. The slope (discrimination) parameter. Default is 1.

- b:

  Numeric. The location (difficulty) parameter.

- c:

  Numeric. The lower asymptote (guessing) parameter. Default is 0.

- d:

  Numeric. The upper asymptote (carelessness) parameter. Default is 1.

## Value

A numeric value representing the probability of a correct response.

## Details

The four-parameter logistic model extends the 3PLM by adding an upper
asymptote parameter `d`, which accounts for careless errors by
high-ability examinees.

The model formula is: \$\$P(\theta) = c + \frac{d - c}{1 +
\exp(-a(\theta - b))}\$\$

Special cases:

- 1PLM: `a = 1`, `c = 0`, `d = 1`

- 2PLM: `c = 0`, `d = 1`

- 3PLM: `d = 1`

## See also

[`ItemInformationFunc`](https://kosugitti.github.io/ggExametrika/reference/ItemInformationFunc.md)

## Examples

``` r
# Compute probability for ability = 0, difficulty = 0
LogisticModel(x = 0, a = 1, b = 0, c = 0, d = 1) # Returns 0.5
#> [1] 0.5

# 3PLM with guessing parameter
LogisticModel(x = -3, a = 1.5, b = 0, c = 0.2, d = 1)
#> [1] 0.2087896
```
