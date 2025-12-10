# Plot Array from exametrika

This function takes exametrika output as input and generates array plots
using ggplot2. Array plots visualize the response patterns of students
(rows) across items (columns), showing both the original data and the
clustered/reordered data.

## Usage

``` r
plotArray_gg(
  data,
  Original = TRUE,
  Clusterd = TRUE,
  Clusterd_lines = TRUE,
  title = TRUE
)
```

## Arguments

- data:

  An object of class `c("exametrika", "Biclustering")`,
  `c("exametrika", "IRM")`, `c("exametrika", "LDB")`, or
  `c("exametrika", "BINET")`.

- Original:

  Logical. If `TRUE` (default), plot the original (unsorted) response
  data.

- Clusterd:

  Logical. If `TRUE` (default), plot the clustered (sorted by class and
  field) response data.

- Clusterd_lines:

  Logical. If `TRUE` (default), draw red lines on the clustered plot to
  indicate class and field boundaries.

- title:

  Logical. If `TRUE` (default), display plot titles.

## Value

A ggplot object or a grid arrangement of two ggplot objects (original
and clustered plots side by side).

## Details

The array plot provides a visual representation of the biclustering
result. Black cells indicate correct responses (1), white cells indicate
incorrect responses (0). In a well-fitted model, the clustered plot
should show a clear block diagonal pattern where high-ability students
(bottom rows) answer difficult items (right columns) correctly.

## See also

[`plotFRP_gg`](https://kosugitti.github.io/ggExametrika/reference/plotFRP_gg.md),
[`plotTRP_gg`](https://kosugitti.github.io/ggExametrika/reference/plotTRP_gg.md)

## Examples

``` r
if (FALSE) { # \dontrun{
library(exametrika)
result <- Biclustering(J35S515, nfld = 5, ncls = 6)
plotArray_gg(result)
} # }
```
