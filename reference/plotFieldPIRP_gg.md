# Plot Field PIRP (Parent Item Reference Profile) from exametrika

This function takes exametrika LDB output as input and generates Field
PIRP (Parent Item Reference Profile) plots using ggplot2. Field PIRP
shows the correct response rate for each field as a function of the
number-right score in parent fields.

## Usage

``` r
plotFieldPIRP_gg(
  data,
  title = TRUE,
  colors = NULL,
  linetype = "solid",
  show_legend = FALSE,
  legend_position = "right"
)
```

## Arguments

- data:

  An object of class `c("exametrika", "LDB")`.

- title:

  Logical or character. If `TRUE` (default), display an auto-generated
  title. If `FALSE`, no title. If a character string, use it as a custom
  title prefix (rank number will be appended).

- colors:

  Character vector. Colors for each field line. If `NULL` (default),
  uses black for all lines (with text labels for field identification).

- linetype:

  Character or numeric specifying the line type. Default is `"solid"`.

- show_legend:

  Logical. If `TRUE`, display the legend. Default is `FALSE` (uses text
  labels instead).

- legend_position:

  Character. Position of the legend. One of `"right"` (default),
  `"top"`, `"bottom"`, `"left"`, `"none"`.

## Value

A list of ggplot objects, one for each rank. Each plot shows the correct
response rate curves for all fields at that rank level.

## Details

In Local Dependence Biclustering (LDB), items in a field may depend on
performance in parent fields. The Field PIRP visualizes this dependency
by showing how the correct response rate in each field changes based on
the number of correct responses in parent fields.

Note: Warning messages about NA values may appear during plotting but
the behavior is normal.

## See also

[`plotFRP_gg`](https://kosugitti.github.io/ggExametrika/reference/plotFRP_gg.md),
[`plotArray_gg`](https://kosugitti.github.io/ggExametrika/reference/plotArray_gg.md)

## Examples

``` r
if (FALSE) { # \dontrun{
library(exametrika)
result <- LDB(J35S515, nfld = 5, ncls = 6)
plots <- plotFieldPIRP_gg(result)
plots[[1]] # Show Field PIRP for rank 1
} # }
```
