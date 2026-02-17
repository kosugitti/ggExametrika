#' @title Plot Score Frequency Distribution from exametrika
#'
#' @description
#' This function takes exametrika LRAordinal or LRArated output as input and
#' generates a Score Frequency Distribution plot using ggplot2. The plot shows
#' the density distribution of scores with vertical dashed lines indicating
#' the thresholds between adjacent latent ranks.
#'
#' @param data An object of class \code{c("exametrika", "LRAordinal")} or
#'   \code{c("exametrika", "LRArated")} from \code{exametrika::LRA()}.
#' @param title Logical or character. If \code{TRUE} (default), display an
#'   auto-generated title. If \code{FALSE}, no title. If a character string,
#'   use it as a custom title.
#' @param colors Character vector of length 2. First element is the color
#'   for the density curve, second is the color for the threshold lines.
#'   If \code{NULL} (default), a colorblind-friendly palette is used.
#' @param linetype Character or numeric vector of length 2. First element is
#'   the line type for the density curve, second for the threshold lines.
#'   Default is \code{c("solid", "dashed")}.
#' @param show_legend Logical. If \code{TRUE}, display the legend.
#'   Default is \code{FALSE}.
#' @param legend_position Character. Position of the legend.
#'   One of \code{"right"} (default), \code{"top"}, \code{"bottom"},
#'   \code{"left"}, \code{"none"}.
#'
#' @return A single ggplot object showing the score frequency distribution
#'   with rank threshold lines.
#'
#' @details
#' The Score Frequency Distribution visualizes how student scores are
#' distributed and where the boundaries between latent ranks fall.
#' The threshold between rank \eqn{i} and rank \eqn{i+1} is calculated as
#' the midpoint between the maximum score in rank \eqn{i} and the minimum
#' score in rank \eqn{i+1}.
#'
#' This plot is useful for understanding how latent ranks correspond to
#' observed score ranges.
#'
#' @examples
#' \dontrun{
#' library(exametrika)
#' result <- LRA(J15S3810, nrank = 4, dataType = "ordinal")
#' plot <- plotScoreFreq_gg(result)
#' plot
#' }
#'
#' @seealso \code{\link{plotLRD_gg}}, \code{\link{plotRMP_gg}}
#'
#' @importFrom ggplot2 ggplot aes geom_density geom_vline labs theme
#'   scale_color_manual
#' @export

plotScoreFreq_gg <- function(data,
                             title = TRUE,
                             colors = NULL,
                             linetype = c("solid", "dashed"),
                             show_legend = FALSE,
                             legend_position = "right") {
  # クラスチェック
  is_LRAordinal <- all(class(data) %in% c("exametrika", "LRAordinal"))
  is_LRArated <- all(class(data) %in% c("exametrika", "LRArated"))

  if (!is_LRAordinal && !is_LRArated) {
    stop("Invalid input. The variable must be from exametrika output (LRAordinal or LRArated).")
  }

  # Students データからスコアとランクを取得
  tmp <- as.data.frame(data$Students)
  sc <- tmp$Score
  rank <- tmp$Estimate

  # ランク間の閾値を計算
  unique_ranks <- sort(unique(rank))
  n_ranks <- length(unique_ranks)
  thresholds <- numeric(n_ranks - 1)

  for (i in 1:(n_ranks - 1)) {
    max_rank_i <- max(sc[rank == unique_ranks[i]])
    min_rank_next <- min(sc[rank == unique_ranks[i + 1]])
    thresholds[i] <- (max_rank_i + min_rank_next) / 2
  }

  # 色の設定
  if (is.null(colors)) {
    palette <- .gg_exametrika_palette(2)
    color_density <- palette[1]
    color_threshold <- palette[2]
  } else {
    color_density <- colors[1]
    color_threshold <- colors[2]
  }

  # linetype の設定
  if (length(linetype) == 1) {
    linetype <- c(linetype, "dashed")
  }

  # タイトルの設定
  if (is.logical(title) && title) {
    plot_title <- "Score Frequency Distribution"
  } else if (is.logical(title) && !title) {
    plot_title <- NULL
  } else {
    plot_title <- title
  }

  # プロット作成
  plot_data <- data.frame(score = sc)

  p <- ggplot(plot_data, aes(x = score)) +
    geom_density(color = color_density, linetype = linetype[1]) +
    geom_vline(
      xintercept = thresholds,
      color = color_threshold,
      linetype = linetype[2]
    ) +
    labs(
      title = plot_title,
      x = "Score",
      y = "Density"
    )

  # 凡例の制御
  if (show_legend) {
    p <- p + theme(legend.position = legend_position)
  } else {
    p <- p + theme(legend.position = "none")
  }

  return(p)
}
