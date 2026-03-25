#' @title Plot LDPSR (Local Dependence Passing Student Rate) from exametrika
#'
#' @description
#' This function takes exametrika BINET output as input and generates
#' LDPSR (Local Dependence Passing Student Rate) plots using ggplot2.
#' LDPSR visualizes the correct response rate for items within a field,
#' comparing the parent class and child class at each DAG edge.
#'
#' Each plot corresponds to one edge in the BINET DAG structure,
#' showing how item-level performance differs between the parent class
#' (lower ability) and the child class (higher ability) connected
#' through a specific field.
#'
#' @param data An object of class \code{c("exametrika", "BINET")}.
#' @param title Logical or character. If \code{TRUE} (default), display an
#'   auto-generated title showing the field and class transition.
#'   If \code{FALSE}, no title. If a character string, use it as a custom
#'   title prefix.
#' @param colors Character vector of length 2. Colors for the parent class
#'   line (\code{colors[1]}) and the child class line (\code{colors[2]}).
#'   If \code{NULL} (default), uses the package default palette.
#' @param linetype Character or numeric specifying the line type.
#'   Default is \code{"solid"}.
#' @param show_legend Logical. If \code{TRUE} (default), display the legend
#'   identifying parent and child class lines.
#' @param legend_position Character. Position of the legend.
#'   One of \code{"right"} (default), \code{"top"}, \code{"bottom"},
#'   \code{"left"}, \code{"none"}.
#'
#' @return A list of ggplot objects, one for each DAG edge. Each plot shows
#'   the correct response rate profiles for the parent class and child class
#'   on items belonging to the connecting field.
#'
#' @details
#' In BINET (Bicluster Network Model), latent classes are connected by a
#' directed acyclic graph (DAG), where edges pass through specific fields.
#' LDPSR shows the item-level passing rate for each such edge: the parent
#' class line represents the correct response rate of students in the
#' originating class, and the child class line shows the rate for students
#' in the destination class.
#'
#' The gap between the two lines indicates how much students improve on
#' each item when transitioning from the parent class to the child class
#' via the specified field.
#'
#' @examplesIf requireNamespace("exametrika", quietly = TRUE)
#' \donttest{
#' library(exametrika)
#' # BINET requires field configuration and edge structure
#' conf <- c(
#'   1, 5, 5, 5, 9, 9, 6, 6, 6, 6, 2, 7, 7, 11, 11, 7, 7,
#'   12, 12, 12, 2, 2, 3, 3, 4, 4, 4, 8, 8, 12, 1, 1, 6, 10, 10
#' )
#' edges_data <- data.frame(
#'   "From Class (Parent) >>>" = c(1, 2, 3, 4, 5, 7, 2, 4, 6, 8, 10, 6, 6, 11, 8, 9, 12),
#'   ">>> To Class (Child)" = c(2, 4, 5, 5, 6, 11, 3, 7, 9, 12, 12, 10, 8, 12, 12, 11, 13),
#'   "At Field (Locus)" = c(1, 2, 2, 3, 4, 4, 5, 5, 5, 5, 5, 7, 8, 8, 9, 9, 12)
#' )
#' tmp_file <- tempfile(fileext = ".csv")
#' write.csv(edges_data, file = tmp_file, row.names = FALSE)
#' result <- BINET(J35S515, ncls = 13, nfld = 12, conf = conf, adj_file = tmp_file)
#' unlink(tmp_file)
#' plots <- plotLDPSR_gg(result)
#' plots[[1]] # Show LDPSR for the first edge
#' }
#'
#' @seealso \code{\link{plotFRP_gg}}, \code{\link{plotArray_gg}},
#'   \code{\link{plotGraph_gg}}, \code{\link{combinePlots_gg}}
#'
#' @importFrom ggplot2 ggplot aes geom_line geom_point geom_text
#'   scale_x_continuous scale_y_continuous scale_color_manual
#'   labs theme
#' @export

plotLDPSR_gg <- function(data,
                         title = TRUE,
                         colors = NULL,
                         linetype = "solid",
                         show_legend = TRUE,
                         legend_position = "right") {
  # Input validation: BINET only
  if (!inherits(data, "exametrika") || !any(class(data) %in% "BINET")) {
    stop("Invalid input. The variable must be from exametrika BINET output.")
  }

  if (is.null(data$params) || length(data$params) == 0) {
    stop("No LDPSR parameters found in the BINET output.")
  }

  # Color setup: 2 colors for parent and child class lines
  if (is.null(colors)) {
    use_colors <- .gg_exametrika_palette(2)
  } else {
    use_colors <- rep_len(colors, 2)
  }

  plots <- list()

  for (i in seq_along(data$params)) {
    target <- data$params[[i]]
    n_items <- length(target$fld)

    # Get item labels from chap/pap names or fallback to ItemLabel/indices
    item_labels <- names(target$chap)
    if (is.null(item_labels)) {
      item_labels <- names(target$pap)
    }
    if (is.null(item_labels)) {
      if (!is.null(data$ItemLabel)) {
        item_labels <- data$ItemLabel[target$fld]
      } else {
        item_labels <- paste0("Item", target$fld)
      }
    }

    # Legend labels for parent and child class lines
    parent_label <- paste0("Class ", target$parent, " (Parent)")
    child_label <- paste0("Class ", target$child, " (Child)")

    # Build long-form data frame for ggplot
    plot_data <- data.frame(
      item_pos = rep(seq_len(n_items), 2),
      probability = c(target$pap, target$chap),
      class_type = factor(
        rep(c(parent_label, child_label), each = n_items),
        levels = c(parent_label, child_label)
      )
    )

    # Title setup (3 patterns: TRUE=auto, FALSE=none, string=custom prefix)
    if (is.logical(title) && title) {
      plot_title <- paste0(
        "Field ", target$field,
        " (Class ", target$parent,
        " -> Class ", target$child, ")"
      )
    } else if (is.logical(title) && !title) {
      plot_title <- NULL
    } else {
      plot_title <- paste0(
        title, " - Field ", target$field,
        " (Class ", target$parent,
        " -> Class ", target$child, ")"
      )
    }

    # Endpoint label data: class labels at the rightmost point of each line
    label_data <- data.frame(
      x = rep(n_items, 2),
      y = c(target$pap[n_items], target$chap[n_items]),
      label = c(paste0("C", target$parent), paste0("C", target$child))
    )

    # Build ggplot object
    p <- ggplot(plot_data, aes(
      x = item_pos, y = probability,
      color = class_type
    )) +
      geom_line(linetype = linetype) +
      geom_point() +
      geom_text(
        data = label_data,
        aes(x = x, y = y, label = label),
        inherit.aes = FALSE,
        vjust = -1, size = 3.5
      ) +
      scale_x_continuous(
        breaks = seq_len(n_items),
        labels = item_labels
      ) +
      scale_y_continuous(
        limits = c(0, 1),
        breaks = seq(0, 1, 0.25)
      ) +
      scale_color_manual(
        values = setNames(use_colors, c(parent_label, child_label))
      ) +
      labs(
        title = plot_title,
        x = "Item",
        y = "Probability",
        color = NULL
      )

    # Legend control (single conditional block for consistency)
    if (show_legend) {
      p <- p + theme(legend.position = legend_position)
    } else {
      p <- p + theme(legend.position = "none")
    }

    plots[[i]] <- p
  }

  return(plots)
}
