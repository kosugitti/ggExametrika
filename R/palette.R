#' Default color palette for ggExametrika
#'
#' Returns the package default color palette (ColorBrewer Dark2).
#' Colorblind-friendly and high-contrast for both screen and print.
#'
#' @param n Number of colors needed. If greater than 8, colors are recycled.
#' @return A character vector of hex color codes.
#' @keywords internal

.gg_exametrika_palette <- function(n = 8) {
  palette <- c(
    "#1B9E77", # teal
    "#D95F02", # orange
    "#7570B3", # purple
    "#E7298A", # pink
    "#66A61E", # green
    "#E6AB02", # gold
    "#A6761D", # brown
    "#666666"  # gray
  )
  rep_len(palette, n)
}
