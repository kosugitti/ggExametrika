#' Plot Distractor Analysis for Rated Models
#'
#' @description
#' Creates stacked bar charts showing the proportion of each response category
#' by rank/class for each item. The correct answer category is highlighted in
#' a distinct color to visualize how well each item discriminates across
#' ability levels.
#'
#' @param data An object of class \code{c("DistractorAnalysis", "exametrika")}
#'   from \code{exametrika::DistractorAnalysis()}.
#' @param items Integer vector of item indices to plot. If \code{NULL} (default),
#'   plots all items.
#' @param ranks Integer vector of rank/class indices to display.
#'   If \code{NULL} (default), displays all ranks/classes.
#' @param title Logical or character. If \code{TRUE} (default), displays an
#'   auto-generated title. If \code{FALSE}, no title. If a character string,
#'   uses it as a custom title (appended with item label).
#' @param colors Character vector of colors for response categories. If
#'   \code{NULL} (default), uses steelblue for the correct answer and gray70
#'   for distractor categories. When specified, colors are assigned to
#'   categories in order (Cat1, Cat2, ...).
#' @param show_legend Logical. If \code{TRUE} (default), displays the legend.
#' @param legend_position Character. Position of the legend. One of
#'   \code{"right"} (default), \code{"top"}, \code{"bottom"}, \code{"left"},
#'   \code{"none"}.
#'
#' @return A named list of ggplot objects, one per item. Names correspond to
#'   item labels.
#'
#' @details
#' Distractor Analysis examines how examinees in different ability ranks or
#' latent classes respond to multiple-choice items. For each item, a stacked
#' bar chart shows the proportion of respondents choosing each category.
#'
#' A well-functioning item should show the correct answer category (highlighted
#' in blue by default) increasing in proportion as rank/class increases, while
#' distractor categories decrease.
#'
#' This function works with \code{DistractorAnalysis} objects produced from
#' \code{LRA} (rated data) and \code{Biclustering} / \code{Biclustering_IRM}
#' (rated data) results.
#'
#' @examplesIf requireNamespace("exametrika", quietly = TRUE)
#' \donttest{
#' library(exametrika)
#' # LRA.rated example
#' result_lra <- LRA(J21S300, nrank = 5, mic = TRUE)
#' da <- DistractorAnalysis(result_lra)
#'
#' # Plot a single item
#' plots <- plotDistractor_gg(da, items = 1)
#' plots[[1]]
#'
#' # Plot multiple items
#' plots <- plotDistractor_gg(da, items = 1:6)
#' combinePlots_gg(plots, selectPlots = 1:6)
#'
#' # Select specific ranks
#' plots <- plotDistractor_gg(da, items = 1, ranks = c(1, 3, 5))
#'
#' # Custom colors
#' plots <- plotDistractor_gg(da,
#'   items = 1,
#'   colors = c("tomato", "steelblue", "gold", "gray70")
#' )
#' }
#'
#' @seealso \code{\link{plotIRP_gg}}, \code{\link{plotFCRP_gg}},
#'   \code{\link{combinePlots_gg}}
#'
#' @importFrom ggplot2 ggplot aes geom_col labs scale_fill_manual
#'   scale_y_continuous theme element_text
#'
#' @export
plotDistractor_gg <- function(data,
                              items = NULL,
                              ranks = NULL,
                              title = TRUE,
                              colors = NULL,
                              show_legend = TRUE,
                              legend_position = "right") {
  # Input validation
  if (!inherits(data, "exametrika") || !inherits(data, "DistractorAnalysis")) {
    stop("Invalid input. The data must be from exametrika::DistractorAnalysis().")
  }

  # Default: all items / all ranks

  if (is.null(items)) items <- seq_len(data$nitems)
  if (is.null(ranks)) ranks <- seq_len(data$n_rank)

  # Determine x-axis label
  msg <- if (!is.null(data$msg)) data$msg else "Rank"

  # Category labels
  cat_labels <- paste0("Cat", seq_len(data$maxQ))

  plots <- list()

  for (j in items) {
    # Compute proportions from frequency table
    freq <- data$freq_table[[j]][ranks, , drop = FALSE]
    row_sums <- rowSums(freq)
    row_sums[row_sums == 0] <- 1
    props <- freq / row_sums
    props[is.nan(props)] <- 0

    # Correct answer for this item
    ca <- data$CA[j]

    # Build long-format data frame
    rank_labels <- paste0(substr(msg, 1, 1), ranks)
    plot_data <- data.frame(
      RankLabel = rep(factor(rank_labels, levels = rank_labels),
        times = data$maxQ
      ),
      Category = rep(factor(cat_labels, levels = cat_labels),
        each = length(ranks)
      ),
      Proportion = as.vector(props)
    )

    # Color setup
    if (is.null(colors)) {
      fill_colors <- rep("gray70", data$maxQ)
      fill_colors[ca] <- "steelblue"
      names(fill_colors) <- cat_labels
    } else {
      fill_colors <- rep_len(colors, data$maxQ)
      names(fill_colors) <- cat_labels
    }

    # Title setup
    item_label <- data$ItemLabel[j]
    if (is.logical(title) && title) {
      plot_title <- paste0(item_label, " (CA=Cat", ca, ")")
    } else if (is.logical(title) && !title) {
      plot_title <- NULL
    } else {
      plot_title <- paste0(title, " ", item_label, " (CA=Cat", ca, ")")
    }

    # Build plot
    p <- ggplot(plot_data, aes(
      x = RankLabel, y = Proportion,
      fill = Category
    )) +
      geom_col(position = "stack", width = 0.7) +
      scale_fill_manual(values = fill_colors) +
      scale_y_continuous(
        limits = c(0, 1),
        breaks = seq(0, 1, 0.25)
      ) +
      labs(
        title = plot_title,
        x = msg,
        y = "Proportion",
        fill = "Category"
      )

    # Legend control
    if (!show_legend) {
      p <- p + theme(legend.position = "none")
    } else {
      p <- p + theme(legend.position = legend_position)
    }

    plots[[item_label]] <- p
  }

  return(plots)
}
