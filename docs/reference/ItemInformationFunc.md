# Item Information Function for 4PLM

Computes the Item Information Function (IIF) for the four-parameter
logistic model in Item Response Theory. The information function
indicates how precisely an item measures ability at different theta
levels.

## Usage

``` r
ItemInformationFunc(x, a = 1, b, c = 0, d = 1)
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

A numeric value representing the item information at the given ability
level.

## Details

Higher discrimination (`a`) parameters result in higher information.
Items provide maximum information near their difficulty (`b`) parameter.
The guessing (`c`) and upper asymptote (`d`) parameters reduce the
maximum information an item can provide.

## See also

[`LogisticModel`](https://kosugitti.github.io/ggExametrika/reference/LogisticModel.md)

## Examples

``` r
# Information at ability = 0 for an item with b = 0
ItemInformationFunc(x = 0, a = 1.5, b = 0, c = 0, d = 1)
#> [1] 0.5625

# Compare information at different ability levels
sapply(seq(-3, 3, 0.5), function(x) ItemInformationFunc(x, a = 1, b = 0))
#>  [1] 0.04517666 0.07010372 0.10499359 0.14914645 0.19661193 0.23500371
#>  [7] 0.25000000 0.23500371 0.19661193 0.14914645 0.10499359 0.07010372
#> [13] 0.04517666
```
