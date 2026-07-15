# Shared worker for plotLCD_gg / plotLRD_gg

The two exported functions draw the same student-distribution plot; they
differ only in which model family is the "native" one (class vs rank)
and therefore in which direction the redirect warning fires.

## Usage

``` r
.plot_student_distribution(
  data,
  Num_Students,
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
  `c("exametrika", "BINET")`. If LRA or Biclustering output is provided,
  LRD will be plotted instead with a warning.

- Num_Students:

  Logical. If `TRUE` (default), display the number of students on each
  bar.

- title:

  Logical or character. If `TRUE` (default), display the auto-generated
  title. If `FALSE`, no title. If a character string, use it as a custom
  title.

- colors:

  Character vector of length 2. First element is the bar fill color,
  second is the line/point color. If `NULL` (default), uses gray for
  bars and black for line/points.

- linetype:

  Character or numeric specifying the line type for the frequency line.
  Default is `"dashed"`.

- show_legend:

  Logical. If `TRUE`, display the legend. Default is `FALSE`.

- legend_position:

  Character. Position of the legend. One of `"right"` (default),
  `"top"`, `"bottom"`, `"left"`, `"none"`.

- prefer:

  Either "class" (plotLCD_gg) or "rank" (plotLRD_gg).

## Value

A ggplot object.
