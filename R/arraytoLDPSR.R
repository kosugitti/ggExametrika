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

  # Separate missing values (-1) from valid values
  has_missing <- -1 %in% all_values
  valid_values <- all_values[all_values != -1]
  n_valid_categories <- length(valid_values)

  # Determine total categories (for boundary line color decision)
  n_categories <- length(all_values)

  # Set default boundary line color based on number of valid categories
  if (is.null(Clusterd_lines_color)) {
    if (n_valid_categories <= 2 && !has_missing) {
      # Binary data: red lines for better visibility on black/white
      Clusterd_lines_color <- "red"
    } else {
      # Multi-valued data: white lines
      Clusterd_lines_color <- "white"
    }
  }

  # Set default colors based on number of valid categories
  if (is.null(colors)) {
    if (n_valid_categories == 2 && !has_missing) {
      # Binary data: white (0) and black (1)
      valid_colors <- c("#FFFFFF", "#000000")
    } else {
      # Multi-valued data: use colorblind-friendly palette
      valid_colors <- c(
        "#E69F00", "#0173B2", "#DE8F05", "#029E73", "#CC78BC",
        "#CA9161", "#FBAFE4", "#949494", "#ECE133", "#56B4E9"
      )
      if (length(valid_colors) < n_valid_categories) {
        # Add more colors if needed
        additional_colors <- c(
          "#D55E00", "#F0E442", "#009E73", "#CC79A7", "#0072B2",
          "#E8601C", "#7CAE00", "#C77CFF", "#00BFC4", "#F8766D"
        )
        valid_colors <- c(valid_colors, additional_colors)[1:n_valid_categories]
      } else {
        valid_colors <- valid_colors[1:n_valid_categories]
      }
    }

    # Assign colors to all values (including -1 if present)
    use_colors <- character(n_categories)
    for (i in seq_along(all_values)) {
      if (all_values[i] == -1) {
        use_colors[i] <- "#000000"  # Black for missing
      } else {
        # Find position in valid_values
        valid_idx <- which(valid_values == all_values[i])
        use_colors[i] <- valid_colors[valid_idx]
      }
    }
  } else {
    use_colors <- colors[1:n_categories]
  }

  # Create labels for legend (NA for -1, numbers for others)
  value_labels <- ifelse(all_values == -1, "NA", as.character(all_values))

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
        labels = value_labels,
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
        labels = value_labels,
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

      # 新名称優先、旧名称フォールバックでクラス数・フィールド数を取得
      n_class <- .first_non_null(data$n_class, data$Nclass, data$n_rank, data$Nrank)
      n_field <- .first_non_null(data$n_field, data$Nfield, length(unique(data$FieldEstimated)))

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

    plots[[length(plots) + 1]] <- clusterd_plot
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
#' @param title Logical or character. If \code{TRUE} (default), display an
#'   auto-generated title. If \code{FALSE}, no title. If a character string,
#'   use it as a custom title prefix (rank number will be appended).
#' @param colors Character vector. Colors for each field line.
#'   If \code{NULL} (default), uses black for all lines (with text labels
#'   for field identification).
#' @param linetype Character or numeric specifying the line type.
#'   Default is \code{"solid"}.
#' @param show_legend Logical. If \code{TRUE}, display the legend.
#'   Default is \code{FALSE} (uses text labels instead).
#' @param legend_position Character. Position of the legend.
#'   One of \code{"right"} (default), \code{"top"}, \code{"bottom"},
#'   \code{"left"}, \code{"none"}.
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
#' @importFrom ggplot2 ggplot aes
#' @importFrom ggplot2 ylim
#' @importFrom ggplot2 geom_line
#' @importFrom ggplot2 geom_text
#' @importFrom ggplot2 scale_x_continuous
#' @importFrom ggplot2 scale_color_manual
#' @importFrom ggplot2 labs theme
#' @export

plotFieldPIRP_gg <- function(data,
                              title = TRUE,
                              colors = NULL,
                              linetype = "solid",
                              show_legend = FALSE,
                              legend_position = "right") {
  if (all(class(data) %in% c("exametrika", "LDB"))) {} else {
    stop("Invalid input. The variable must be from exametrika output or from LDB.")
  }


  # 新名称優先、旧名称フォールバックでクラス数・フィールド数を取得
  n_cls <- .first_non_null(data$n_rank, data$Nrank, data$n_class, data$Nclass)

  n_field <- .first_non_null(data$n_field, data$Nfield)

  # 色の設定
  if (is.null(colors)) {
    use_colors <- .gg_exametrika_palette(n_field)
  } else {
    use_colors <- rep_len(colors, n_field)
  }

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

    # タイトルの設定
    if (is.logical(title) && title) {
      plot_title <- paste0("Rank ", i)
    } else if (is.logical(title) && !title) {
      plot_title <- NULL
    } else {
      plot_title <- paste0(title, " - Rank ", i)
    }

    p <- ggplot(plot_data, aes(
      x = l,
      y = k,
      group = field,
      color = field
    )) +
      scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.25)) +
      scale_x_continuous(breaks = seq(0, max(plot_data$l), 1)) +
      geom_line(linetype = linetype) +
      geom_text(aes(x = l, y = k - 0.02, label = substr(field, 7, 8)),
                show.legend = FALSE) +
      scale_color_manual(values = use_colors) +
      labs(
        title = plot_title,
        x = "PIRP(Number-Right Score) in Parent Field(s) ",
        y = "Correct Response Rate",
        color = "Field"
      )

    # 凡例の制御
    if (!show_legend) {
      p <- p + theme(legend.position = "none")
    } else {
      p <- p + theme(legend.position = legend_position)
    }

    plots[[i]] <- p
  }

  return(plots)
}
