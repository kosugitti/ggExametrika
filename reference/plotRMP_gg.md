# Plot Rank Membership Profile (RMP) from exametrika

This function takes exametrika output as input and generates Rank
Membership Profile (RMP) plots using ggplot2. RMP shows each student's
membership probability across all latent ranks.

## Usage

``` r
plotRMP_gg(
  data,
  title = TRUE,
  colors = NULL,
  linetype = "dashed",
  show_legend = FALSE,
  legend_position = "right"
)
```

## Arguments

- data:

  An object of class `c("exametrika", "LRA")`,
  `c("exametrika", "Biclustering")`, `c("exametrika", "LDLRA")`, or
  `c("exametrika", "LDB")`. If LCA or BINET output is provided, CMP will
  be plotted instead with a warning.

- title:

  Logical or character. If `TRUE` (default), display an auto-generated
  title. If `FALSE`, no title. If a character string, use it as a custom
  title (only for single-student plots).

- colors:

  Character vector. Color(s) for points and lines. If `NULL` (default),
  a colorblind-friendly palette is used.

- linetype:

  Character or numeric specifying the line type. Default is `"dashed"`.

- show_legend:

  Logical. If `TRUE`, display the legend. Default is `FALSE`.

- legend_position:

  Character. Position of the legend. One of `"right"` (default),
  `"top"`, `"bottom"`, `"left"`, `"none"`.

## Value

A list of ggplot objects, one for each student. Each plot shows the
membership probability across all latent ranks.

## Details

The Rank Membership Profile visualizes how strongly each student belongs
to each latent rank. Unlike class membership, rank membership has an
ordinal interpretation. Students with unimodal profiles centered on a
single rank are well-classified.

## See also

[`plotCMP_gg`](https://kosugitti.github.io/ggExametrika/reference/plotCMP_gg.md),
[`plotLRD_gg`](https://kosugitti.github.io/ggExametrika/reference/plotLRD_gg.md)

## Examples

``` r
if (FALSE) { # \dontrun{
library(exametrika)
result <- LRA(J15S500, nrank = 5)
plots <- plotRMP_gg(result)
plots[[1]] # Show RMP for the first student
} # }
```
