#' Validate an exametrika object and return the matched model class
#'
#' Internal validation used by all plot functions. The object must inherit
#' from "exametrika" and carry at least one of the model classes in
#' \code{valid_classes}. Using \code{\%in\%} on \code{class(data)} against
#' the candidate set (and not the other way around) keeps the check robust
#' when the parent package adds extra classes to its outputs.
#'
#' @param data Object to validate.
#' @param valid_classes Character vector of acceptable model classes.
#' @return The first matched model class (character scalar), invisibly usable
#'   for dispatching on the model type.
#' @keywords internal

.validate_exametrika <- function(data, valid_classes) {
  if (!inherits(data, "exametrika") || !any(class(data) %in% valid_classes)) {
    stop(
      "Invalid input. The data must be an exametrika object of class ",
      paste(valid_classes, collapse = ", "), ".",
      call. = FALSE
    )
  }
  intersect(class(data), valid_classes)[1]
}


#' Resolve the colors argument against the number of colors needed
#'
#' If \code{colors} is NULL, the package default palette is used. If the
#' user supplies fewer colors than needed, a warning is issued and the
#' colors are recycled (instead of silently producing NA colors).
#'
#' @param colors User-supplied color vector or NULL.
#' @param n Number of colors needed.
#' @return A character vector of length \code{n}.
#' @keywords internal

.resolve_colors <- function(colors, n) {
  if (is.null(colors)) {
    return(.gg_exametrika_palette(n))
  }
  if (length(colors) < n) {
    warning(
      "Fewer colors supplied (", length(colors), ") than needed (", n,
      "); colors will be recycled.",
      call. = FALSE
    )
  }
  rep_len(colors, n)
}


#' Resolve the title argument (logical or character)
#'
#' @param title TRUE (auto title), FALSE (no title), or a character string.
#' @param auto_title The automatic title used when \code{title} is TRUE.
#' @return A character title or NULL.
#' @keywords internal

.resolve_title <- function(title, auto_title) {
  if (is.character(title)) {
    return(title)
  }
  if (isTRUE(title)) {
    return(auto_title)
  }
  NULL
}


#' Apply legend visibility and position to a ggplot
#'
#' @param p A ggplot object.
#' @param show_legend Logical. FALSE hides the legend.
#' @param legend_position Legend position passed to \code{theme()}.
#' @return The modified ggplot object.
#' @keywords internal

.apply_legend <- function(p, show_legend, legend_position) {
  if (isTRUE(show_legend)) {
    p + ggplot2::theme(legend.position = legend_position)
  } else {
    p + ggplot2::theme(legend.position = "none")
  }
}


#' Rescale a secondary-axis variable into primary-axis coordinates
#'
#' Used by the distribution plots (LCD/LRD/TRP) to overlay a frequency
#' polygon on a bar chart with a different y-scale.
#'
#' @param y2 Values on the secondary scale.
#' @param yaxis1 Range (min, max) of the primary axis.
#' @param yaxis2 Range (min, max) of the secondary axis.
#' @return \code{y2} linearly mapped into primary-axis coordinates.
#' @keywords internal

.variable_scaler <- function(y2, yaxis1, yaxis2) {
  a <- diff(yaxis1) / diff(yaxis2)
  b <- (yaxis1[1] * yaxis2[2] - yaxis1[2] * yaxis2[1]) / diff(yaxis2)
  a * y2 + b
}


#' Inverse of .variable_scaler for secondary-axis labeling
#'
#' @param y1 Values on the primary scale.
#' @param yaxis1 Range (min, max) of the primary axis.
#' @param yaxis2 Range (min, max) of the secondary axis.
#' @return \code{y1} linearly mapped into secondary-axis coordinates.
#' @keywords internal

.axis_scaler <- function(y1, yaxis1, yaxis2) {
  a <- diff(yaxis2) / diff(yaxis1)
  b <- (yaxis2[1] * yaxis1[2] - yaxis2[2] * yaxis1[1]) / diff(yaxis1)
  a * y1 + b
}
