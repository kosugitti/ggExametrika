# Plot LDPSR (Local Dependence Passing Student Rate) from exametrika

This function takes exametrika BINET output as input and generates LDPSR
(Local Dependence Passing Student Rate) plots using ggplot2. LDPSR
visualizes the correct response rate for items within a field, comparing
the parent class and child class at each DAG edge.

Each plot corresponds to one edge in the BINET DAG structure, showing
how item-level performance differs between the parent class (lower
ability) and the child class (higher ability) connected through a
specific field.

## Usage

``` r
plotLDPSR_gg(
  data,
  title = TRUE,
  colors = NULL,
  linetype = "solid",
  show_legend = TRUE,
  legend_position = "right"
)
```

## Arguments

- data:

  An object of class `c("exametrika", "BINET")`.

- title:

  Logical or character. If `TRUE` (default), display an auto-generated
  title showing the field and class transition. If `FALSE`, no title. If
  a character string, use it as a custom title prefix.

- colors:

  Character vector of length 2. Colors for the parent class line
  (`colors[1]`) and the child class line (`colors[2]`). If `NULL`
  (default), uses the package default palette.

- linetype:

  Character or numeric specifying the line type. Default is `"solid"`.

- show_legend:

  Logical. If `TRUE` (default), display the legend identifying parent
  and child class lines.

- legend_position:

  Character. Position of the legend. One of `"right"` (default),
  `"top"`, `"bottom"`, `"left"`, `"none"`.

## Value

A list of ggplot objects, one for each DAG edge. Each plot shows the
correct response rate profiles for the parent class and child class on
items belonging to the connecting field.

## Details

In BINET (Bicluster Network Model), latent classes are connected by a
directed acyclic graph (DAG), where edges pass through specific fields.
LDPSR shows the item-level passing rate for each such edge: the parent
class line represents the correct response rate of students in the
originating class, and the child class line shows the rate for students
in the destination class.

The gap between the two lines indicates how much students improve on
each item when transitioning from the parent class to the child class
via the specified field.

## See also

[`plotFRP_gg`](https://kosugitti.github.io/ggExametrika/reference/plotFRP_gg.md),
[`plotArray_gg`](https://kosugitti.github.io/ggExametrika/reference/plotArray_gg.md),
[`plotGraph_gg`](https://kosugitti.github.io/ggExametrika/reference/plotGraph_gg.md),
[`combinePlots_gg`](https://kosugitti.github.io/ggExametrika/reference/combinePlots_gg.md)

## Examples

``` r
if (FALSE) { # \dontrun{
library(exametrika)
# BINET requires graph structure input (g_list or adj_file)
result <- BINET(J35S515, ncls = 13, nfld = 12, conf = conf, adj_file = edges)
plots <- plotLDPSR_gg(result)
plots[[1]] # Show LDPSR for the first edge
combinePlots_gg(plots, selectPlots = 1:6) # Show first 6 edges
} # }
```
