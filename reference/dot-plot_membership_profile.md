# Shared worker for plotCMP_gg / plotRMP_gg

The two exported functions draw the same per-student membership plot;
they differ only in which model family is the "native" one (class vs
rank) and therefore in which direction the redirect warning fires.

## Usage

``` r
.plot_membership_profile(
  data,
  title,
  colors,
  linetype,
  show_legend,
  legend_position,
  prefer
)
```

## Arguments

- data:

  An object of class `c("exametrika", "LCA")` or
  `c("exametrika", "BINET")`. If LRA, Biclustering, LDLRA, or LDB output
  is provided, RMP will be plotted instead with a warning.

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

- prefer:

  Either "class" (plotCMP_gg) or "rank" (plotRMP_gg).

## Value

A list of ggplot objects, one per student.
