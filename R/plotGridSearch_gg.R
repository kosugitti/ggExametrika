#' @title Plot the fit index of a grid search
#'
#' @description
#' Draws the fit index recorded by \code{exametrika::GridSearch()} against the
#' number of classes or ranks. For LCA/LRA this is one line. For Biclustering
#' the default is one line per number of fields, and \code{style = "tile"}
#' draws the class-by-field grid as a heat map instead. Settings that
#' converged are filled points, settings that left a class, rank or field
#' empty are open triangles, settings that failed to converge are left
#' blank, and the optimum is marked with a large red point (and, for one
#' line, a dotted vertical line).
#'
#' @param data A \code{GridSearch} result from \code{exametrika::GridSearch()}.
#' @param style Character. \code{"line"} (default) draws the index against the
#'   number of classes/ranks; \code{"tile"} (Biclustering only) draws a heat
#'   map over classes and fields.
#' @param title Logical or character. If \code{TRUE} (default), display an
#'   auto-generated title. If \code{FALSE}, no title. If a character string,
#'   use it as a custom title.
#' @param colors Character vector. For \code{style = "line"}: the line
#'   color (LCA/LRA) or one color per number of fields (Biclustering). For
#'   \code{style = "tile"}: two colors for the low and high ends of the index
#'   scale. If \code{NULL} (default), the package palette is used.
#' @param linetype Character or numeric. Line type of the index line(s).
#'   Default is \code{"solid"}. Ignored for \code{style = "tile"}.
#' @param show_legend Logical. If \code{TRUE} (default), display the legend.
#' @param legend_position Character. Position of the legend.
#'   One of \code{"right"} (default), \code{"top"}, \code{"bottom"},
#'   \code{"left"}, \code{"none"}.
#'
#' @return A single ggplot object.
#'
#' @details
#' The plot reads \code{index_vec} (LCA/LRA) or \code{index_matrix}
#' (Biclustering) together with the \code{empty_vec}/\code{empty_matrix}
#' flags that \code{GridSearch()} records since exametrika 2.3.0. With an
#' older exametrika no setting is marked as empty.
#'
#' @examplesIf requireNamespace("exametrika", quietly = TRUE)
#' \donttest{
#' library(exametrika)
#' gs <- GridSearch(J15S500, max_ncls = 5, fun = "LCA", index = "BIC")
#' plotGridSearch_gg(gs)
#'
#' gs_b <- GridSearch(J15S500, max_ncls = 4, max_nfld = 4,
#'   fun = "Biclustering", index = "BIC")
#' plotGridSearch_gg(gs_b)
#' plotGridSearch_gg(gs_b, style = "tile")
#' }
#'
#' @importFrom ggplot2 ggplot aes geom_line geom_point geom_vline geom_tile labs
#'   scale_x_continuous scale_y_continuous scale_shape_manual scale_color_manual
#'   scale_size_manual scale_fill_gradient guides guide_legend
#' @export

plotGridSearch_gg <- function(data,
                              style = c("line", "tile"),
                              title = TRUE,
                              colors = NULL,
                              linetype = "solid",
                              show_legend = TRUE,
                              legend_position = "right") {
  .validate_exametrika(data, "GridSearch")
  style <- match.arg(style)

  index_name <- if (is.null(data$index)) "Fit index" else data$index
  unit <- if (identical(data$fun, "LRA")) "ranks" else "classes"
  xlab <- paste("Number of", unit)
  opt_col <- "#D7191C"
  # indices that GridSearch() minimises; the others (e.g. log-likelihood) it maximises
  minimize <- index_name %in% c(
    "model_Chi_sq", "RMSEA", "AIC", "CAIC", "BIC", "ICL", "BIC_elbo", "ICL_exact"
  )
  opt_size <- 4
  pt_size <- 2.5

  # ------------------------------------------------------------ LCA / LRA
  if (!is.null(data$index_vec)) {
    df <- data.frame(
      ncls = as.integer(sub("^ncls", "", names(data$index_vec))),
      value = as.numeric(data$index_vec)
    )
    df$empty <- if (is.null(data$empty_vec)) FALSE else as.logical(data$empty_vec)
    df <- df[!is.na(df$value), , drop = FALSE]
    empty_label <- paste("with empty", if (unit == "ranks") "rank" else "class")
    status_levels <- c("fit", empty_label, "optimum")
    df$status <- ifelse(df$empty, empty_label, "fit")
    df$status[df$ncls == data$optimal_ncls] <- "optimum"
    df$status <- factor(df$status, levels = status_levels)

    line_col <- if (is.null(colors)) .gg_exametrika_palette(1) else colors[1]
    plot_title <- .resolve_title(title, paste(index_name, "by number of", unit))

    p <- ggplot(df, aes(x = ncls, y = value)) +
      geom_line(color = line_col, linetype = linetype[1]) +
      geom_point(aes(shape = status, color = status, size = status)) +
      scale_shape_manual(
        values = stats::setNames(c(16, 2, 16), status_levels), name = NULL
      ) +
      scale_color_manual(
        values = stats::setNames(c(line_col, line_col, opt_col), status_levels), name = NULL
      ) +
      scale_size_manual(
        values = stats::setNames(c(pt_size, pt_size, opt_size), status_levels), name = NULL
      ) +
      scale_x_continuous(breaks = df$ncls) +
      labs(title = plot_title, x = xlab, y = index_name)
    if (any(df$status == "optimum")) {
      p <- p + geom_vline(
        xintercept = data$optimal_ncls, linetype = "dotted", color = opt_col
      )
    }
    return(.apply_legend(p, show_legend, legend_position))
  }

  # ---------------------------------------------------------- Biclustering
  mat <- data$index_matrix
  ncls <- as.integer(sub("^ncls ", "", rownames(mat)))
  nfld <- as.integer(sub("^nfld ", "", colnames(mat)))
  empty <- if (is.null(data$empty_matrix)) {
    matrix(FALSE, nrow(mat), ncol(mat))
  } else {
    data$empty_matrix
  }
  df <- data.frame(
    ncls = rep(ncls, times = length(nfld)),
    nfld = rep(nfld, each = length(ncls)),
    value = as.vector(mat),
    empty = as.vector(empty)
  )
  df$optimum <- !is.na(df$value) &
    df$ncls == data$optimal_ncls & df$nfld == data$optimal_nfld

  if (style == "tile") {
    # darker is better: for a minimised index the low end gets the dark colour
    pal <- if (is.null(colors)) c("#E3F0DC", "#14532D") else rep_len(colors, 2)
    if (minimize) pal <- rev(pal)
    plot_title <- .resolve_title(
      title, paste(index_name, "by number of", unit, "and fields")
    )
    p <- ggplot(df, aes(x = ncls, y = nfld, fill = value)) +
      geom_tile(color = "white") +
      scale_fill_gradient(
        low = pal[1], high = pal[2], name = index_name, na.value = "grey90"
      ) +
      scale_x_continuous(breaks = ncls) +
      scale_y_continuous(breaks = nfld) +
      labs(title = plot_title, x = xlab, y = "Number of fields")
    flagged <- df[df$empty & !is.na(df$value), , drop = FALSE]
    if (nrow(flagged) > 0) {
      p <- p + geom_point(data = flagged, shape = 2, color = "black", size = pt_size)
    }
    if (any(df$optimum)) {
      p <- p + geom_point(
        data = df[df$optimum, , drop = FALSE],
        shape = 16, color = opt_col, size = opt_size
      )
    }
    return(.apply_legend(p, show_legend, legend_position))
  }

  df <- df[!is.na(df$value), , drop = FALSE]
  df$series <- as.character(df$nfld)
  status_levels <- c("fit", "with empty class/field")
  df$status <- factor(
    ifelse(df$empty, "with empty class/field", "fit"), levels = status_levels
  )
  pal <- .resolve_colors(colors, length(nfld))
  series_levels <- c(as.character(nfld), "optimum")
  plot_title <- .resolve_title(
    title, paste(index_name, "by number of", unit, "and fields")
  )

  p <- ggplot(df, aes(
    x = ncls, y = value, color = series, group = series
  )) +
    geom_line(linetype = linetype[1]) +
    geom_point(aes(shape = status), size = pt_size)
  if (any(df$optimum)) {
    # the optimum sits on the colour scale as its own key, drawn without a line
    p <- p + geom_point(
      data = df[df$optimum, , drop = FALSE],
      aes(x = ncls, y = value, color = "optimum"),
      inherit.aes = FALSE, shape = 16, size = opt_size
    )
  }
  p <- p +
    scale_color_manual(
      values = stats::setNames(c(pal, opt_col), series_levels),
      breaks = series_levels,
      labels = c(paste("nfld =", nfld), "optimum"),
      name = NULL
    ) +
    scale_shape_manual(values = stats::setNames(c(16, 2), status_levels), name = NULL) +
    scale_x_continuous(breaks = ncls) +
    labs(title = plot_title, x = xlab, y = index_name) +
    ggplot2::guides(color = ggplot2::guide_legend(override.aes = list(
      linetype = c(rep(1, length(nfld)), 0),
      shape = 16,
      size = c(rep(pt_size, length(nfld)), opt_size)
    )))
  .apply_legend(p, show_legend, legend_position)
}
