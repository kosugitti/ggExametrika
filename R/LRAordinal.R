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
#' @examplesIf requireNamespace("exametrika", quietly = TRUE)
#' \donttest{
#' library(exametrika)
#' result <- LRA(J5S1000, nrank = 4, dataType = "ordinal")
#' plot <- plotScoreFreq_gg(result)
#' plot
#' }
#'
#' @seealso \code{\link{plotLRD_gg}}, \code{\link{plotRMP_gg}}
#'
#' @importFrom ggplot2 ggplot aes geom_density geom_vline labs theme scale_color_manual
#' @export

plotScoreFreq_gg <- function(data,
                             title = TRUE,
                             colors = NULL,
                             linetype = c("solid", "dashed"),
                             show_legend = FALSE,
                             legend_position = "right") {
  # Class validation
  .validate_exametrika(data, c("LRAordinal", "LRArated"))

  # Extract scores and ranks from Students data
  tmp <- as.data.frame(data$Students)
  sc <- tmp$Score
  rank <- tmp$Estimate

  # Calculate thresholds between ranks
  unique_ranks <- sort(unique(rank))
  n_ranks <- length(unique_ranks)
  thresholds <- numeric(n_ranks - 1)

  for (i in seq_len(n_ranks - 1)) {
    max_rank_i <- max(sc[rank == unique_ranks[i]])
    min_rank_next <- min(sc[rank == unique_ranks[i + 1]])
    thresholds[i] <- (max_rank_i + min_rank_next) / 2
  }

  # Color setup
  if (is.null(colors)) {
    palette <- .gg_exametrika_palette(2)
    color_density <- palette[1]
    color_threshold <- palette[2]
  } else {
    color_density <- colors[1]
    color_threshold <- colors[2]
  }

  # Linetype setup
  if (length(linetype) == 1) {
    linetype <- c(linetype, "dashed")
  }

  # Title setup
  plot_title <- .resolve_title(title, "Score Frequency Distribution")

  # Build plot
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

  # Legend control
  p <- .apply_legend(p, show_legend, legend_position)

  return(p)
}


#' Shared worker for plotICBR_gg / plotICRP_gg
#'
#' The two exported functions differ only in which element of the
#' exametrika output they draw (ICBR vs ICRP), the accepted model
#' classes, and the auto title.
#'
#' @param element Name of the data element ("ICBR" or "ICRP").
#' @param valid_classes Acceptable model classes.
#' @param auto_title Base string of the automatic title.
#' @inheritParams plotICBR_gg
#' @return A ggplot object.
#' @keywords internal

.plot_item_category <- function(data, items, title, colors, linetype,
                                show_legend, legend_position,
                                element, valid_classes, auto_title) {
  # Class validation
  .validate_exametrika(data, valid_classes)

  # Check data existence
  if (!element %in% names(data)) {
    stop(element, " data not found in the input object.")
  }

  element_data <- data[[element]]

  # Item selection
  all_items <- unique(element_data$ItemLabel)
  if (is.null(items)) {
    selected_items <- all_items
  } else {
    # Convert numeric indices to ItemLabel
    if (is.numeric(items)) {
      selected_items <- all_items[items]
    } else {
      selected_items <- items
    }
  }

  # Filter selected items
  plot_data <- element_data[element_data$ItemLabel %in% selected_items, ]

  # Convert wide to long format (rank1, rank2, ... -> Rank and Probability)
  rank_cols <- grep("^rank[0-9]+$", colnames(plot_data), value = TRUE)

  long_data <- tidyr::pivot_longer(
    plot_data,
    cols = all_of(rank_cols),
    names_to = "Rank",
    values_to = "Probability",
    names_prefix = "rank"
  )

  # Convert Rank to numeric
  # Ranks are plotted in natural order (rank1, rank2, ...) to match
  # the base plots of the parent exametrika package
  long_data$Rank <- as.numeric(long_data$Rank)

  # Strip item name prefix from CategoryLabel (e.g., "V1-Cat1" -> "Cat1")
  # This ensures consistent category labels across items for color mapping
  long_data$Category <- sub("^.*-", "", long_data$CategoryLabel)

  # Color setup
  n_categories <- length(unique(long_data$Category))
  colors <- .resolve_colors(colors, n_categories)

  # Linetype setup
  if (is.null(linetype)) {
    # Automatically assign linetypes
    linetype_options <- c("solid", "dashed", "dotted", "dotdash", "longdash", "twodash")
    linetype <- rep(linetype_options, length.out = n_categories)
  }

  # Build plot
  p <- ggplot(long_data, aes(
    x = Rank, y = Probability,
    color = Category,
    linetype = Category,
    group = interaction(ItemLabel, Category)
  )) +
    geom_line(linewidth = 0.8) +
    facet_wrap(~ItemLabel) +
    scale_y_continuous(breaks = seq(0, 1, 0.25)) +
    labs(
      x = "Rank",
      y = "Probability",
      color = "Category",
      linetype = "Category"
    ) +
    theme(
      strip.text = element_text(size = 10, face = "bold")
    )

  # Color and linetype scale setup
  p <- p + scale_color_manual(values = colors) +
    scale_linetype_manual(values = linetype)

  # Title setup
  if (is.logical(title)) {
    if (title && length(selected_items) == 1) {
      p <- p + labs(title = paste0(auto_title, ": ", selected_items[1]))
    } else if (title && length(selected_items) > 1) {
      p <- p + labs(title = auto_title)
    }
  } else if (is.character(title)) {
    p <- p + labs(title = title)
  }

  # Legend control
  .apply_legend(p, show_legend, legend_position)
}


#' @title Plot Item Category Boundary Response from exametrika
#'
#' @description
#' This function takes exametrika LRAordinal output as input and generates an
#' Item Category Boundary Response (ICBR) plot using ggplot2. The plot shows
#' cumulative probability curves for each category boundary across latent ranks.
#' For each item, multiple lines represent the probability of scoring at or above
#' each category boundary.
#'
#' @param data An object of class \code{c("exametrika", "LRAordinal")} from
#'   \code{exametrika::LRA()} with \code{dataType = "ordinal"}.
#' @param items Integer vector specifying which items to plot. Default is all items.
#' @param title Logical or character. If \code{TRUE} (default), display item labels
#'   as subplot titles. If \code{FALSE}, no titles. If a character string,
#'   use it as the main plot title.
#' @param colors Character vector. Colors for category boundary lines.
#'   If \code{NULL} (default), uses the package default palette.
#' @param linetype Character or numeric vector. Line types for category boundaries.
#'   If \code{NULL} (default), uses automatic line type assignment.
#' @param show_legend Logical. If \code{TRUE}, display the legend showing category labels.
#'   Default is \code{TRUE}.
#' @param legend_position Character. Position of the legend.
#'   One of \code{"right"} (default), \code{"top"}, \code{"bottom"},
#'   \code{"left"}, \code{"none"}.
#'
#' @return A single ggplot object with faceted subplots for each item,
#'   or a combined plot using gridExtra if faceting is not suitable.
#'
#' @details
#' The Item Category Boundary Response (ICBR) visualizes how the probability
#' of reaching each category boundary changes across latent ranks. This is
#' particularly useful for understanding the difficulty of each response category
#' in ordinal items.
#'
#' For an item with \eqn{K} categories (0, 1, ..., K-1), the ICBR shows:
#' \itemize{
#'   \item Line 1: P(response >= 1 | rank)
#'   \item Line 2: P(response >= 2 | rank)
#'   \item ...
#'   \item Line K-1: P(response >= K-1 | rank)
#' }
#'
#' Ranks are shown in natural order (rank 1, rank 2, ...), matching the
#' base plots of the parent exametrika package.
#'
#' @examplesIf requireNamespace("exametrika", quietly = TRUE)
#' library(exametrika)
#' \donttest{
#' result <- LRA(J5S1000, nrank = 4, dataType = "ordinal")
#'
#' # Plot first 4 items
#' plot <- plotICBR_gg(result, items = 1:4)
#' plot
#'
#' # Custom colors and title
#' plot <- plotICBR_gg(result,
#'   items = 1:6,
#'   title = "Item Category Boundary Response",
#'   colors = c("red", "blue", "green", "purple")
#' )
#' plot
#' }
#'
#' @seealso \code{\link{plotScoreFreq_gg}}, \code{\link{plotLRD_gg}}, \code{\link{plotRMP_gg}}
#'
#' @importFrom ggplot2 ggplot aes geom_line facet_wrap labs theme element_text scale_color_manual scale_linetype_manual scale_y_continuous
#' @importFrom tidyr pivot_longer
#' @export

plotICBR_gg <- function(data,
                        items = NULL,
                        title = TRUE,
                        colors = NULL,
                        linetype = NULL,
                        show_legend = TRUE,
                        legend_position = "right") {
  .plot_item_category(
    data, items, title, colors, linetype, show_legend, legend_position,
    element = "ICBR",
    valid_classes = "LRAordinal",
    auto_title = "Item Category Boundary Response"
  )
}


#' @title Plot Item Category Reference Profile from exametrika
#'
#' @description
#' This function takes exametrika LRAordinal or LRArated output as input and generates an
#' Item Category Reference Profile (ICRP) plot using ggplot2. The plot shows
#' response probability curves for each category across latent ranks.
#' For each item, multiple lines represent the probability of selecting each response category.
#'
#' @param data An object of class \code{c("exametrika", "LRAordinal")} or
#'   \code{c("exametrika", "LRArated")} from \code{exametrika::LRA()}.
#' @param items Integer vector specifying which items to plot. Default is all items.
#' @param title Logical or character. If \code{TRUE} (default), display item labels
#'   as subplot titles. If \code{FALSE}, no titles. If a character string,
#'   use it as the main plot title.
#' @param colors Character vector. Colors for category lines.
#'   If \code{NULL} (default), uses the package default palette.
#' @param linetype Character or numeric vector. Line types for categories.
#'   If \code{NULL} (default), uses automatic line type assignment.
#' @param show_legend Logical. If \code{TRUE}, display the legend showing category labels.
#'   Default is \code{TRUE}.
#' @param legend_position Character. Position of the legend.
#'   One of \code{"right"} (default), \code{"top"}, \code{"bottom"},
#'   \code{"left"}, \code{"none"}.

#'
#' @return A single ggplot object with faceted subplots for each item.
#'
#' @details
#' The Item Category Reference Profile (ICRP) visualizes how the response probability
#' for each category changes across latent ranks. Unlike ICBR which shows cumulative
#' probabilities, ICRP shows the raw probability of selecting each specific category.
#'
#' For an item with \eqn{K} categories (0, 1, ..., K-1), the ICRP shows:
#' \itemize{
#'   \item Line for Cat0: P(response = 0 | rank)
#'   \item Line for Cat1: P(response = 1 | rank)
#'   \item ...
#'   \item Line for CatK: P(response = K | rank)
#' }
#'
#' The sum of all probabilities at each rank equals 1.0, as they represent
#' mutually exclusive response options.
#'
#' Ranks are shown in natural order (rank 1, rank 2, ...), matching the
#' base plots of the parent exametrika package.
#'
#' @examplesIf requireNamespace("exametrika", quietly = TRUE)
#' library(exametrika)
#' \donttest{
#' result <- LRA(J5S1000, nrank = 4, dataType = "ordinal")
#'
#' # Plot first 4 items
#' plot <- plotICRP_gg(result, items = 1:4)
#' plot
#'
#' # Custom colors and title
#' plot <- plotICRP_gg(result,
#'   items = 1:6,
#'   title = "Item Category Reference Profile",
#'   colors = c("red", "blue", "green", "purple")
#' )
#' plot
#' }
#'
#' @seealso \code{\link{plotICBR_gg}}, \code{\link{plotScoreFreq_gg}}, \code{\link{plotLRD_gg}}
#'
#' @importFrom ggplot2 ggplot aes geom_line facet_wrap labs theme element_text scale_color_manual scale_linetype_manual scale_y_continuous
#' @importFrom tidyr pivot_longer
#' @export

plotICRP_gg <- function(data,
                        items = NULL,
                        title = TRUE,
                        colors = NULL,
                        linetype = NULL,
                        show_legend = TRUE,
                        legend_position = "right") {
  .plot_item_category(
    data, items, title, colors, linetype, show_legend, legend_position,
    element = "ICRP",
    valid_classes = c("LRAordinal", "LRArated"),
    auto_title = "Item Category Reference Profile"
  )
}
