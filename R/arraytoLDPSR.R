#' @title Plot Array from exametrika
#'
#' @description
#' This function takes exametrika output as input and generates
#' array plots using ggplot2. Array plots visualize the response
#' patterns of students (rows) across items (columns), showing both
#' the original data and the clustered/reordered data.
#'
#' Supports both binary (0/1) and multi-valued (ordinal/nominal) data.
#'
#' @param data An object of class \code{c("exametrika", "Biclustering")},
#'   \code{c("exametrika", "nominalBiclustering")},
#'   \code{c("exametrika", "ordinalBiclustering")},
#'   \code{c("exametrika", "IRM")}, \code{c("exametrika", "LDB")}, or
#'   \code{c("exametrika", "BINET")}.
#' @param Original Logical. If \code{TRUE} (default), plot the original
#'   (unsorted) response data.
#' @param Clusterd Logical. If \code{TRUE} (default), plot the clustered
#'   (sorted by class and field) response data.
#' @param Clusterd_lines Logical. If \code{TRUE} (default), draw lines
#'   on the clustered plot to indicate class and field boundaries.
#' @param Clusterd_lines_color Character. Color of the boundary lines.
#'   If \code{NULL} (default), uses \code{"red"} for binary data or
#'   \code{"white"} for multi-valued data.
#' @param title Logical or character. If \code{TRUE} (default), display
#'   auto-generated titles. If \code{FALSE}, no titles. If a character
#'   string, use it as a custom title prefix.
#' @param colors Character vector of colors for each category.
#'   If \code{NULL} (default), uses white/black for binary data or a
#'   colorblind-friendly palette for multi-valued data.
#' @param show_legend Logical. If \code{TRUE}, display the legend.
#'   Default is \code{FALSE} for binary data, \code{TRUE} for multi-valued.
#' @param legend_position Character. Position of the legend.
#'   One of \code{"right"} (default), \code{"top"}, \code{"bottom"},
#'   \code{"left"}, \code{"none"}.
#'
#' @return A ggplot object or a grid arrangement of two ggplot objects
#'   (original and clustered plots side by side).
#'
#' @details
#' The array plot provides a visual representation of the biclustering
#' result. For binary data, black cells indicate correct responses (1)
#' and white cells indicate incorrect responses (0). For multi-valued
#' data, different colors represent different response categories.
#'
#' In a well-fitted model, the clustered plot should show a clear block
#' diagonal pattern where high-ability students (bottom rows) answer
#' difficult items (right columns) correctly.
#'
#' @examples
#' \dontrun{
#' library(exametrika)
#' result <- Biclustering(J35S515, nfld = 5, ncls = 6)
#'
#' # Basic usage
#' plotArray_gg(result)
#'
#' # Custom boundary line color
#' plotArray_gg(result, Clusterd_lines_color = "blue")
#'
#' # Multi-valued data with custom colors
#' synthetic_data <- matrix(sample(0:3, 50 * 20, replace = TRUE), nrow = 50, ncol = 20)
#' result_multi <- Biclustering(synthetic_data, nfld = 4, ncls = 5)
#' plotArray_gg(result_multi, show_legend = TRUE, Clusterd_lines_color = "darkgreen")
#' }
#'
#' @seealso \code{\link{plotFRP_gg}}, \code{\link{plotTRP_gg}}
#'
#' @importFrom ggplot2 ggplot aes geom_tile scale_fill_manual
#'   labs theme element_text element_blank geom_hline geom_vline margin
#'   scale_x_continuous scale_y_continuous
#' @importFrom gridExtra grid.arrange
#' @export

plotArray_gg <- function(data,
                         Original = TRUE,
                         Clusterd = TRUE,
                         Clusterd_lines = TRUE,
                         Clusterd_lines_color = NULL,
                         title = TRUE,
                         colors = NULL,
                         show_legend = NULL,
                         legend_position = "right") {
  # Check input class
  valid_classes <- c(
    "Biclustering", "nominalBiclustering", "ordinalBiclustering",
    "IRM", "LDB", "BINET"
  )
  if (!any(sapply(valid_classes, function(cls) all(class(data) %in% c("exametrika", cls))))) {
    stop(
      "Invalid input. The variable must be from exametrika output: ",
      "Biclustering, nominalBiclustering, ordinalBiclustering, IRM, LDB, or BINET."
    )
  }

  # Detect data values and categories
  raw_data <- if (!is.null(data$U)) data$U else data$Q
  all_values <- sort(unique(as.vector(as.matrix(raw_data))))
  n_categories <- length(all_values)

  # Set default boundary line color based on number of categories
  if (is.null(Clusterd_lines_color)) {
    if (n_categories == 2) {
      # Binary data: red lines for better visibility on black/white
      Clusterd_lines_color <- "red"
    } else {
      # Multi-valued data: white lines
      Clusterd_lines_color <- "white"
    }
  }

  # Set default colors based on number of categories
  if (is.null(colors)) {
    if (n_categories == 2) {
      # Binary data: white (0) and black (1)
      use_colors <- c("#FFFFFF", "#000000")
    } else {
      # Multi-valued data: use colorblind-friendly palette
      use_colors <- c(
        "#E69F00", "#0173B2", "#DE8F05", "#029E73", "#CC78BC",
        "#CA9161", "#FBAFE4", "#949494", "#ECE133", "#56B4E9"
      )
      if (length(use_colors) < n_categories) {
        # Add more colors if needed
        additional_colors <- c(
          "#D55E00", "#F0E442", "#009E73", "#CC79A7", "#0072B2",
          "#E8601C", "#7CAE00", "#C77CFF", "#00BFC4", "#F8766D"
        )
        use_colors <- c(use_colors, additional_colors)[1:n_categories]
      }
    }
  } else {
    use_colors <- colors[1:n_categories]
  }

  # Set default legend visibility based on data type
  if (is.null(show_legend)) {
    show_legend <- n_categories > 2
  }

  plots <- list()

  if (Original == TRUE) {
    itemn <- NULL
    for (i in 1:ncol(raw_data)) {
      itemn <- c(itemn, rep(i, nrow(raw_data)))
    }

    rown <- rep(1:nrow(raw_data), ncol(raw_data))
    response_val <- as.vector(as.matrix(raw_data))

    plot_data <- data.frame(
      itemn = itemn,
      rown = rown,
      value = factor(response_val, levels = all_values)
    )

    # Set title
    if (is.logical(title) && title) {
      title1 <- "Original Data"
    } else if (is.logical(title) && !title) {
      title1 <- NULL
    } else if (is.character(title)) {
      title1 <- paste(title, "- Original Data")
    }

    original_plot <- ggplot(plot_data, aes(x = itemn, y = rown, fill = value)) +
      geom_tile() +
      scale_fill_manual(
        values = setNames(use_colors, all_values),
        name = "Response",
        drop = FALSE
      ) +
      scale_x_continuous(expand = c(0, 0), limits = c(0.5, ncol(raw_data) + 0.5)) +
      scale_y_continuous(expand = c(0, 0), limits = c(0.5, nrow(raw_data) + 0.5)) +
      labs(title = title1) +
      theme(
        plot.title = element_text(
          hjust = 0.5,
          size = 11,
          margin = margin(t = 5, b = 5)
        ),
        axis.ticks = element_blank(),
        axis.text = element_blank(),
        axis.title = element_blank(),
        axis.line = element_blank(),
        panel.background = element_blank(),
        plot.margin = margin(t = 5, r = 5, b = 5, l = 5)
      )

    # Legend control
    if (!show_legend) {
      original_plot <- original_plot + theme(legend.position = "none")
    } else {
      original_plot <- original_plot + theme(legend.position = legend_position)
    }

    plots[[1]] <- original_plot
  }

  if (Clusterd == TRUE) {
    # Sort data to match exametrika's original implementation
    # order(decreasing = FALSE) puts smaller class numbers first in the data
    # But we reverse rown so smaller classes appear at top visually
    case_order <- order(data$ClassEstimated, decreasing = FALSE)
    field_order <- order(data$FieldEstimated, decreasing = FALSE)
    sorted <- raw_data[case_order, field_order]

    itemn <- NULL
    for (i in 1:ncol(sorted)) {
      itemn <- c(itemn, rep(i, nrow(sorted)))
    }

    # Reverse row numbers so that:
    # - sorted[1, ] (smallest ClassEstimated) -> rown = nrow (top visually)
    # - sorted[nrow, ] (largest ClassEstimated) -> rown = 1 (bottom visually)
    rown <- rep(nrow(sorted):1, ncol(sorted))
    response_val <- as.vector(as.matrix(sorted))

    plot_data <- data.frame(
      itemn = itemn,
      rown = rown,
      value = factor(response_val, levels = all_values)
    )

    # Set title
    if (is.logical(title) && title) {
      title2 <- "Clusterd Data"
    } else if (is.logical(title) && !title) {
      title2 <- NULL
    } else if (is.character(title)) {
      title2 <- paste(title, "- Clusterd Data")
    }

    clusterd_plot <- ggplot(plot_data, aes(x = itemn, y = rown, fill = value)) +
      geom_tile() +
      scale_fill_manual(
        values = setNames(use_colors, all_values),
        name = "Response",
        drop = FALSE
      ) +
      scale_x_continuous(expand = c(0, 0), limits = c(0.5, ncol(sorted) + 0.5)) +
      scale_y_continuous(expand = c(0, 0), limits = c(0.5, nrow(sorted) + 0.5)) +
      labs(title = title2) +
      theme(
        plot.title = element_text(
          hjust = 0.5,
          size = 11,
          margin = margin(t = 5, b = 5)
        ),
        axis.ticks = element_blank(),
        axis.text = element_blank(),
        axis.title = element_blank(),
        axis.line = element_blank(),
        panel.background = element_blank(),
        plot.margin = margin(t = 5, r = 5, b = 5, l = 5)
      )

    # Add class/field boundary lines
    if (Clusterd_lines == TRUE) {
      # Calculate boundary positions based on sorted data
      sorted_class <- data$ClassEstimated[case_order]
      sorted_field <- data$FieldEstimated[field_order]

      class_breaks <- cumsum(table(sorted_class))
      field_breaks <- cumsum(table(sorted_field))

      # Use Nclass if available, otherwise use Nrank
      n_class <- if (!is.null(data$Nclass)) data$Nclass else data$Nrank
      n_field <- if (!is.null(data$Nfield)) data$Nfield else length(unique(data$FieldEstimated))

      h <- class_breaks[1:(n_class - 1)]
      v <- field_breaks[1:(n_field - 1)]

      # Since rown is reversed (nrow:1), we need to adjust h positions
      # h gives positions in sorted data (1-indexed from top)
      # We need positions in ggplot2 coordinates where rown goes from nrow (top) to 1 (bottom)
      h_adjusted <- nrow(sorted) - h

      # Lines should be placed at boundaries between cells (x.5 positions)
      clusterd_plot <- clusterd_plot +
        geom_hline(yintercept = h_adjusted + 0.5, color = Clusterd_lines_color, linewidth = 0.5) +
        geom_vline(xintercept = v + 0.5, color = Clusterd_lines_color, linewidth = 0.5)
    }

    # Legend control
    if (!show_legend) {
      clusterd_plot <- clusterd_plot + theme(legend.position = "none")
    } else {
      clusterd_plot <- clusterd_plot + theme(legend.position = legend_position)
    }

    plots[[2]] <- clusterd_plot
  }

  if (Original == TRUE && Clusterd == TRUE) {
    plots <- grid.arrange(plots[[1]], plots[[2]], nrow = 1)
  }

  return(plots)
}


#' @title Plot Field PIRP (Parent Item Reference Profile) from exametrika
#'
#' @description
#' This function takes exametrika LDB output as input and generates
#' Field PIRP (Parent Item Reference Profile) plots using ggplot2.
#' Field PIRP shows the correct response rate for each field as a
#' function of the number-right score in parent fields.
#'
#' @param data An object of class \code{c("exametrika", "LDB")}.
#'
#' @return A list of ggplot objects, one for each rank. Each plot shows
#'   the correct response rate curves for all fields at that rank level.
#'
#' @details
#' In Local Dependence Biclustering (LDB), items in a field may depend
#' on performance in parent fields. The Field PIRP visualizes this
#' dependency by showing how the correct response rate in each field
#' changes based on the number of correct responses in parent fields.
#'
#' Note: Warning messages about NA values may appear during plotting
#' but the behavior is normal.
#'
#' @examples
#' \dontrun{
#' library(exametrika)
#' result <- LDB(J35S515, nfld = 5, ncls = 6)
#' plots <- plotFieldPIRP_gg(result)
#' plots[[1]] # Show Field PIRP for rank 1
#' }
#'
#' @seealso \code{\link{plotFRP_gg}}, \code{\link{plotArray_gg}}
#'
#' @importFrom ggplot2 ggplot
#' @importFrom ggplot2 ylim
#' @importFrom ggplot2 geom_line
#' @importFrom ggplot2 geom_text
#' @importFrom ggplot2 scale_x_continuous
#' @importFrom ggplot2 labs
#' @export

plotFieldPIRP_gg <- function(data) {
  if (all(class(data) %in% c("exametrika", "LDB"))) {} else {
    stop("Invalid input. The variable must be from exametrika output or from LDB.")
  }


  n_cls <- data$Nclass

  n_field <- data$Nfield

  plots <- list()

  for (i in 1:n_cls) {
    field_data <- NULL

    plot_data <- NULL

    for (j in 1:n_field) {
      x <- data.frame(k = c(data$CCRR_table[j + (i - 1) * n_field, 3:ncol(data$CCRR_table)]))

      field_data <- data.frame(
        k = t(x),
        l = c(0:(ncol(
          data$CCRR_table
        ) - 3)),
        field = data$CCRR_table$Field[j + (i - 1) * n_field]
      )

      plot_data <- rbind(plot_data, field_data)
    }

    plots[[i]] <-
      ggplot(plot_data, aes(
        x = l,
        y = k,
        group = field
      )) +
      scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.25)) +
      scale_x_continuous(breaks = seq(0, max(plot_data$l), 1)) +
      geom_line() +
      geom_text(aes(x = l, y = k - 0.02), label = substr(plot_data$field, 7, 8)) +
      labs(
        title = paste0("Rank ", i),
        x = "PIRP(Number-Right Score) in Parent Field(s) ",
        y = "Correct Response Rate"
      )
  }

  return(plots)
}
