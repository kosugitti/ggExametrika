# Return the first non-NULL value from arguments

Internal utility for fallback chains (e.g., new naming -\> deprecated
naming).

## Usage

``` r
.first_non_null(...)
```

## Arguments

- ...:

  Values to check in order.

## Value

The first non-NULL value, or NULL if all are NULL.
