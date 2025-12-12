#' @title Plot DAG (Directed Acyclic Graph) from exametrika
#'
#' @description
#' Creates a ggplot2-based visualization of DAG structures from exametrika
#' Bayesian network models. Supports BNM, LDLRA, LDB, and BINET models.
#'
#' @param data An object of class "exametrika" with model type BNM, LDLRA, LDB, or BINET.
#' @param layout Character string specifying the layout algorithm.
#'   Options include "sugiyama" (default, hierarchical), "fr" (Fruchterman-Reingold),
#'   "kk" (Kamada-Kawai), "tree", "circle", "grid", "stress".
#' @param rankdir Direction for hierarchical layouts. "TB" (top-to-bottom, default),
#'   "BT" (bottom-to-top), "LR" (left-to-right), "RL" (right-to-left).
#' @param node_size Numeric value for node size. Default is 8.
#' @param node_color Color for nodes. Default is "steelblue".
#' @param label_size Numeric value for label text size. Default is 3.
#' @param arrow_size Numeric value for arrow size. Default is 2.
#' @param edge_color Color for edges. Default is "gray40".
#' @param show_edge_label Logical. If TRUE, show edge labels (for BINET model).
#'   Default is TRUE.
#' @param title Optional character string for plot title. If NULL, auto-generated.
#'
#' @return A list of ggplot objects. For BNM, a single-element list.
#'   For LDLRA/LDB, one plot per rank/class. For BINET, the integrated graph.
#'
#' @details
#' This function uses the ggraph package to create network visualizations.
#' The layout algorithm can significantly affect the readability of the graph:
#' \itemize{
#'   \item "sugiyama": Best for DAGs, creates hierarchical layout
#'   \item "tree": Good for tree-like structures
#'   \item "fr": Force-directed, good for general networks
#'   \item "stress": Minimizes stress, often produces clean layouts
#' }
#'
#' @examples
#' \dontrun{
#' library(exametrika)
#' # BNM example
#' DAG <- matrix(c("Item01", "Item02", "Item02", "Item03",
#'                 "Item02", "Item04", "Item03", "Item05",
#'                 "Item04", "Item05"), ncol = 2, byrow = TRUE)
#' g <- igraph::graph_from_data_frame(DAG)
#' result <- BNM(J5S10, g = g)
#' plots <- plotGraph_gg(result)
#' plots[[1]]
#'
#' # LDLRA example
#' result_ldlra <- LDLRA(J15S500, ncls = 3)
#' plots <- plotGraph_gg(result_ldlra)
#' combinePlots_gg(plots)
#' }
#'
#' @importFrom ggraph ggraph geom_edge_link geom_node_point geom_node_text
#' @importFrom igraph V E
#' @export

plotGraph_gg <- function(data,
                         layout = "sugiyama",
                         rankdir = "TB",
                         node_size = 8,
                         node_color = "steelblue",
                         label_size = 3,
                         arrow_size = 2,
                         edge_color = "gray40",
                         show_edge_label = TRUE,
                         title = NULL) {

  # Check class
  model_class <- class(data)[2]
  if (!model_class %in% c("BNM", "LDLRA", "LDB", "BINET")) {
    stop("This function supports BNM, LDLRA, LDB, and BINET models only.")
  }

  # Helper function to create a single graph plot
  create_graph_plot <- function(g, plot_title = NULL, edge_labels = NULL) {
    # Get node names
    node_names <- igraph::V(g)$name

    # Create base plot with layout
    p <- ggraph::ggraph(g, layout = layout) +
      ggraph::geom_edge_link(
        arrow = grid::arrow(length = grid::unit(arrow_size, "mm"), type = "closed"),
        end_cap = ggraph::circle(node_size / 2, "mm"),
        start_cap = ggraph::circle(node_size / 2, "mm"),
        color = edge_color
      ) +
      ggraph::geom_node_point(size = node_size, color = node_color) +
      ggraph::geom_node_text(ggplot2::aes(label = name),
                             size = label_size,
                             repel = TRUE) +
      ggplot2::theme_void()

    # Add edge labels if provided (for BINET)
    if (!is.null(edge_labels) && show_edge_label) {
      p <- ggraph::ggraph(g, layout = layout) +
        ggraph::geom_edge_link(
          ggplot2::aes(label = edge_labels),
          arrow = grid::arrow(length = grid::unit(arrow_size, "mm"), type = "closed"),
          end_cap = ggraph::circle(node_size / 2, "mm"),
          start_cap = ggraph::circle(node_size / 2, "mm"),
          color = edge_color,
          label_dodge = grid::unit(2.5, "mm"),
          angle_calc = "along"
        ) +
        ggraph::geom_node_point(size = node_size, color = node_color) +
        ggraph::geom_node_text(ggplot2::aes(label = name),
                               size = label_size,
                               repel = TRUE) +
        ggplot2::theme_void()
    }

    # Add title if provided
    if (!is.null(plot_title)) {
      p <- p + ggplot2::ggtitle(plot_title)
    }

    return(p)
  }

  # Process based on model type
  plots <- list()

  if (model_class == "BNM") {
    # Single DAG
    plot_title <- if (is.null(title)) "Bayesian Network Model" else title
    plots[[1]] <- create_graph_plot(data$g, plot_title)

  } else if (model_class == "LDLRA") {
    # Multiple DAGs per rank/class
    n_graphs <- length(data$g_list)
    msg <- if (!is.null(data$Nclass)) "Class" else "Rank"

    for (i in seq_len(n_graphs)) {
      plot_title <- if (is.null(title)) {
        paste("Graph of", msg, i)
      } else {
        paste(title, "-", msg, i)
      }
      plots[[i]] <- create_graph_plot(data$g_list[[i]], plot_title)
    }

  } else if (model_class == "LDB") {
    # Multiple DAGs per rank
    n_graphs <- data$Nrank

    for (i in seq_len(n_graphs)) {
      plot_title <- if (is.null(title)) {
        paste("Graph at Rank", i)
      } else {
        paste(title, "- Rank", i)
      }
      plots[[i]] <- create_graph_plot(data$g_list[[i]], plot_title)
    }

  } else if (model_class == "BINET") {
    # Integrated graph with edge labels
    plot_title <- if (is.null(title)) "BINET Total Graph" else title
    edge_labels <- igraph::E(data$all_g)$Field
    plots[[1]] <- create_graph_plot(data$all_g, plot_title, edge_labels)
  }

  return(plots)
}
