# Shared worker for plotICBR_gg / plotICRP_gg

The two exported functions differ only in which element of the
exametrika output they draw (ICBR vs ICRP), the accepted model classes,
and the auto title.

## Usage

``` r
.plot_item_category(
  data,
  items,
  title,
  colors,
  linetype,
  show_legend,
  legend_position,
  element,
  valid_classes,
  auto_title
)
```

## Arguments

- data:

  An object of class `c("exametrika", "LRAordinal")` from
  [`exametrika::LRA()`](https://kosugitti.github.io/exametrika/reference/LRA.html)
  with `dataType = "ordinal"`.

- items:

  Integer vector specifying which items to plot. Default is all items.

- title:

  Logical or character. If `TRUE` (default), display item labels as
  subplot titles. If `FALSE`, no titles. If a character string, use it
  as the main plot title.

- colors:

  Character vector. Colors for category boundary lines. If `NULL`
  (default), uses the package default palette.

- linetype:

  Character or numeric vector. Line types for category boundaries. If
  `NULL` (default), uses automatic line type assignment.

- show_legend:

  Logical. If `TRUE`, display the legend showing category labels.
  Default is `TRUE`.

- legend_position:

  Character. Position of the legend. One of `"right"` (default),
  `"top"`, `"bottom"`, `"left"`, `"none"`.

- element:

  Name of the data element ("ICBR" or "ICRP").

- valid_classes:

  Acceptable model classes.

- auto_title:

  Base string of the automatic title.

## Value

A ggplot object.
