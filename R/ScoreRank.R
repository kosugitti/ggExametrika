#' @title Plot Score-Rank Heatmap from exametrika
#'
#' @description
#' This function takes exametrika LRAordinal or LRArated output as input and
#' generates a Score-Rank heatmap using ggplot2. The heatmap shows the
#' distribution of students across scores (y-axis) and latent ranks (x-axis),
#' with darker cells indicating higher frequency.
#'
#' @param data An object of class \code{c("exametrika", "LRAordinal")} or
#'   \code{c("exametrika", "LRArated")} from \code{exametrika::LRA()}.
#' @param title Logical or character. If \code{TRUE} (default), display an
#'   auto-generated title. If \code{FALSE}, no title. If a character string,
#'   use it as a custom title.
#' @param colors Character vector of length 2. Low and high colors for the
#'   gradient. If \code{NULL} (default), white-to-black grayscale is used
#'   (matching exametrika's original output).
#' @param show_legend Logical. If \code{TRUE} (default), display the color
#'   scale legend.
#' @param legend_position Character. Position of the legend.
#'   One of \code{"right"} (default), \code{"top"}, \code{"bottom"},
#'   \code{"left"}, \code{"none"}.
#'
#' @return A single ggplot object showing the Score-Rank heatmap.
#'
#' @details
#' The Score-Rank heatmap visualizes the joint distribution of observed
#' scores and estimated latent ranks. Each cell represents the number of
#' students with a given score assigned to a given rank. Darker cells
#' indicate higher frequency.
#'
#' The data is taken from \code{data$ScoreRank}, a matrix where rows
#' represent scores and columns represent latent ranks.
#'
#' @examples
#' \dontrun{
#' library(exametrika)
#' result <- LRA(J15S3810, nrank = 4, dataType = "ordinal")
#' plot <- plotScoreRank_gg(result)
#' plot
#' }
#'
#' @seealso \code{\link{plotScoreFreq_gg}}, \code{\link{plotLRD_gg}}
#'
#' @importFrom ggplot2 ggplot aes geom_tile labs theme
#'   scale_fill_gradient scale_x_continuous
#' @export

plotScoreRank_gg <- function(data,
                             title = TRUE,
                             colors = NULL,
                             show_legend = TRUE,
                             legend_position = "right") {
  # クラスチェック
  is_LRAordinal <- all(class(data) %in% c("exametrika", "LRAordinal"))
  is_LRArated <- all(class(data) %in% c("exametrika", "LRArated"))

  if (!is_LRAordinal && !is_LRArated) {
    stop("Invalid input. The variable must be from exametrika output (LRAordinal or LRArated).")
  }

  score_rank_matrix <- data$ScoreRank
  n_rank <- ncol(score_rank_matrix)
  scores <- as.numeric(rownames(score_rank_matrix))

  # long format に変換
  plot_data <- data.frame(
    rank = rep(1:n_rank, each = length(scores)),
    score = rep(scores, times = n_rank),
    count = as.vector(score_rank_matrix)
  )

  # 色の設定
  if (is.null(colors)) {
    color_low <- "white"
    color_high <- "black"
  } else {
    color_low <- colors[1]
    color_high <- colors[2]
  }

  # タイトルの設定
  if (is.logical(title) && title) {
    plot_title <- "Score-Rank Distribution"
  } else if (is.logical(title) && !title) {
    plot_title <- NULL
  } else {
    plot_title <- title
  }

  p <- ggplot(plot_data, aes(x = rank, y = score, fill = count)) +
    geom_tile() +
    scale_fill_gradient(low = color_low, high = color_high) +
    scale_x_continuous(breaks = 1:n_rank) +
    labs(
      title = plot_title,
      x = "Latent Rank",
      y = "Score",
      fill = "Count"
    )

  # 凡例の制御
  if (show_legend) {
    p <- p + theme(legend.position = legend_position)
  } else {
    p <- p + theme(legend.position = "none")
  }

  return(p)
}
