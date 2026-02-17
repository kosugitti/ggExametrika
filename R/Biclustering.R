#' @title Plot Class Reference Vector (CRV) from exametrika
#'
#' @description
#' This function takes exametrika Biclustering output as input and generates
#' a Class Reference Vector (CRV) plot using ggplot2. CRV shows how each
#' latent class performs across fields, with one line per class.
#'
#' @param data An object of class \code{c("exametrika", "Biclustering")} from
#'   \code{exametrika::Biclustering()}.
#' @param title Logical or character. If \code{TRUE} (default), display an
#'   auto-generated title. If \code{FALSE}, no title. If a character string,
#'   use it as a custom title.
#' @param colors Character vector of colors for each class.
#'   If \code{NULL} (default), a colorblind-friendly palette is used.
#' @param linetype Character or numeric vector specifying the line types.
#'   If a single value, all lines use that type. If a vector, each class
#'   uses the corresponding type. Default is \code{"solid"}.
#' @param show_legend Logical. If \code{TRUE} (default), display the legend.
#' @param legend_position Character. Position of the legend.
#'   One of \code{"right"} (default), \code{"top"}, \code{"bottom"},
#'   \code{"left"}, \code{"none"}.
#'
#' @return A single ggplot object showing the Class Reference Vector.
#'
#' @details
#' The Class Reference Vector is the transpose of the Field Reference Profile
#' (FRP). While FRP shows one plot per field, CRV displays all classes in a
#' single plot with fields on the x-axis. Each line represents a latent class,
#' showing its correct response rate pattern across fields.
#'
#' CRV is used when latent classes are nominal (unordered). For ordered
#' latent ranks, use \code{\link{plotRRV_gg}} instead.
#'
#' @examples
#' \dontrun{
#' library(exametrika)
#' result <- Biclustering(J35S515, nfld = 5, ncls = 6)
#' plot <- plotCRV_gg(result)
#' plot
#' }
#'
#' @seealso \code{\link{plotRRV_gg}}, \code{\link{plotFRP_gg}}
#'
#' @importFrom ggplot2 ggplot aes geom_line geom_point labs theme
#'   scale_color_manual scale_x_continuous scale_y_continuous
#' @export

plotCRV_gg <- function(data,
                       title = TRUE,
                       colors = NULL,
                       linetype = "solid",
                       show_legend = TRUE,
                       legend_position = "right") {
  if (!all(class(data) %in% c("exametrika", "Biclustering"))) {
    stop("Invalid input. The variable must be from exametrika output or an output from Biclustering.")
  }

  # FRPを転置: 行=Class, 列=Field
  RRV <- t(data$FRP)
  n_cls <- nrow(RRV)
  n_fld <- ncol(RRV)

  # long format に変換
  plot_data <- data.frame(
    field = rep(1:n_fld, each = n_cls),
    field_label = rep(colnames(RRV), each = n_cls),
    crr = as.vector(t(RRV)),
    class = factor(rep(rownames(RRV), times = n_fld))
  )

  # 色の設定
  if (is.null(colors)) {
    use_colors <- .gg_exametrika_palette(n_cls)
  } else {
    use_colors <- colors[1:n_cls]
  }

  # タイトルの設定
  if (is.logical(title) && title) {
    plot_title <- "Class Reference Vector"
  } else if (is.logical(title) && !title) {
    plot_title <- NULL
  } else {
    plot_title <- title
  }

  p <- ggplot(plot_data, aes(x = field, y = crr, color = class)) +
    geom_line(linetype = linetype) +
    geom_point() +
    scale_x_continuous(breaks = 1:n_fld, labels = colnames(RRV)) +
    scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.25)) +
    scale_color_manual(values = use_colors) +
    labs(
      title = plot_title,
      x = "Field",
      y = "Correct Response Rate",
      color = NULL
    )

  # 凡例の制御
  if (show_legend) {
    p <- p + theme(legend.position = legend_position)
  } else {
    p <- p + theme(legend.position = "none")
  }

  return(p)
}


#' @title Plot Rank Reference Vector (RRV) from exametrika
#'
#' @description
#' This function takes exametrika Biclustering output as input and generates
#' a Rank Reference Vector (RRV) plot using ggplot2. RRV shows how each
#' latent rank performs across fields, with one line per rank.
#'
#' @param data An object of class \code{c("exametrika", "Biclustering")} from
#'   \code{exametrika::Biclustering()}.
#' @param title Logical or character. If \code{TRUE} (default), display an
#'   auto-generated title. If \code{FALSE}, no title. If a character string,
#'   use it as a custom title.
#' @param colors Character vector of colors for each rank.
#'   If \code{NULL} (default), a colorblind-friendly palette is used.
#' @param linetype Character or numeric vector specifying the line types.
#'   If a single value, all lines use that type. If a vector, each rank
#'   uses the corresponding type. Default is \code{"solid"}.
#' @param show_legend Logical. If \code{TRUE} (default), display the legend.
#' @param legend_position Character. Position of the legend.
#'   One of \code{"right"} (default), \code{"top"}, \code{"bottom"},
#'   \code{"left"}, \code{"none"}.
#'
#' @return A single ggplot object showing the Rank Reference Vector.
#'
#' @details
#' The Rank Reference Vector is the transpose of the Field Reference Profile
#' (FRP). While FRP shows one plot per field, RRV displays all ranks in a
#' single plot with fields on the x-axis. Each line represents a latent rank,
#' showing its correct response rate pattern across fields.
#'
#' RRV is used when latent ranks are ordinal (ordered). For unordered
#' latent classes, use \code{\link{plotCRV_gg}} instead.
#'
#' @examples
#' \dontrun{
#' library(exametrika)
#' result <- Biclustering(J35S515, nfld = 5, ncls = 6)
#' plot <- plotRRV_gg(result)
#' plot
#' }
#'
#' @seealso \code{\link{plotCRV_gg}}, \code{\link{plotFRP_gg}}
#'
#' @importFrom ggplot2 ggplot aes geom_line geom_point labs theme
#'   scale_color_manual scale_x_continuous scale_y_continuous
#' @export

plotRRV_gg <- function(data,
                       title = TRUE,
                       colors = NULL,
                       linetype = "solid",
                       show_legend = TRUE,
                       legend_position = "right") {
  if (!all(class(data) %in% c("exametrika", "Biclustering"))) {
    stop("Invalid input. The variable must be from exametrika output or an output from Biclustering.")
  }

  # FRPを転置: 行=Rank, 列=Field
  RRV <- t(data$FRP)
  n_rank <- nrow(RRV)
  n_fld <- ncol(RRV)

  # long format に変換
  plot_data <- data.frame(
    field = rep(1:n_fld, each = n_rank),
    field_label = rep(colnames(RRV), each = n_rank),
    crr = as.vector(t(RRV)),
    rank = factor(rep(rownames(RRV), times = n_fld))
  )

  # 色の設定
  if (is.null(colors)) {
    use_colors <- .gg_exametrika_palette(n_rank)
  } else {
    use_colors <- colors[1:n_rank]
  }

  # タイトルの設定
  if (is.logical(title) && title) {
    plot_title <- "Rank Reference Vector"
  } else if (is.logical(title) && !title) {
    plot_title <- NULL
  } else {
    plot_title <- title
  }

  p <- ggplot(plot_data, aes(x = field, y = crr, color = rank)) +
    geom_line(linetype = linetype) +
    geom_point() +
    scale_x_continuous(breaks = 1:n_fld, labels = colnames(RRV)) +
    scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.25)) +
    scale_color_manual(values = use_colors) +
    labs(
      title = plot_title,
      x = "Field",
      y = "Correct Response Rate",
      color = NULL
    )

  # 凡例の制御
  if (show_legend) {
    p <- p + theme(legend.position = legend_position)
  } else {
    p <- p + theme(legend.position = "none")
  }

  return(p)
}
