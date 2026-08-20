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
#' @examplesIf requireNamespace("exametrika", quietly = TRUE)
#' library(exametrika)
#' result <- LRA(J5S1000, nrank = 4, dataType = "ordinal")
#' plot <- plotScoreRank_gg(result)
#' plot
#'
#' @seealso \code{\link{plotScoreFreq_gg}}, \code{\link{plotLRD_gg}}
#'
#' @importFrom ggplot2 ggplot aes geom_tile labs theme scale_fill_gradient scale_x_continuous
#' @export

plotScoreRank_gg <- function(data,
                             title = TRUE,
                             colors = NULL,
                             show_legend = TRUE,
                             legend_position = "right") {
  # Class validation
  .validate_exametrika(data, c("LRAordinal", "LRArated"))

  score_rank_matrix <- data$ScoreRank
  n_rank <- ncol(score_rank_matrix)
  scores <- as.numeric(rownames(score_rank_matrix))

  # Convert to long format
  plot_data <- data.frame(
    rank = rep(1:n_rank, each = length(scores)),
    score = rep(scores, times = n_rank),
    count = as.vector(score_rank_matrix)
  )

  # Color setup
  if (is.null(colors)) {
    color_low <- "white"
    color_high <- "black"
  } else {
    color_low <- colors[1]
    color_high <- colors[2]
  }

  # Title setup
  plot_title <- .resolve_title(title, "Score-Rank Distribution")

  p <- ggplot(plot_data, aes(x = rank, y = score, fill = count)) +
    geom_tile() +
    scale_fill_gradient(low = color_low, high = color_high) +
    # Ranks are shown in natural order (1, 2, ...) to match the base
    # plots of the parent exametrika package
    scale_x_continuous(breaks = 1:n_rank) +
    labs(
      title = plot_title,
      x = "Latent Rank",
      y = "Score",
      fill = "Count"
    )

  # Legend control
  p <- .apply_legend(p, show_legend, legend_position)

  return(p)
}
