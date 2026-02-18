#' @title Plot DAG (Directed Acyclic Graph) from exametrika
#'
#' @description
#' Creates a ggplot2-based visualization of DAG structures from exametrika
#' Bayesian network models. Supports BNM, LDLRA, LDB, and BINET models.
#' Design based on TDE figures with items as rounded rectangles and fields as diamonds.
#'
#' @param data An object of class "exametrika" with model type BNM, LDLRA, LDB, or BINET.
#' @param layout Character string specifying the layout algorithm.
#'   Options include "sugiyama" (default, hierarchical), "fr" (Fruchterman-Reingold),
#'   "kk" (Kamada-Kawai), "tree", "stress".
#' @param direction Character string for hierarchical layout direction.
#'   Controls the direction of arrows and node placement in hierarchical layouts.
#'   Only applies when \code{layout = "sugiyama"} (default).
#'   \itemize{
#'     \item \strong{"BT"} (default): Bottom-to-Top. Source nodes at bottom, arrows point upward.
#'           Use when representing progression or growth (e.g., learning paths).
#'     \item \strong{"TB"}: Top-to-Bottom. Source nodes at top, arrows point downward.
#'           Traditional hierarchical view (e.g., organizational charts).
#'     \item \strong{"LR"}: Left-to-Right. Source nodes at left, arrows point right.
#'           Good for wide displays or process flows.
#'     \item \strong{"RL"}: Right-to-Left. Source nodes at right, arrows point left.
#'           Alternative horizontal layout.
#'   }
#'   For other layouts (e.g., "fr", "kk"), this parameter is ignored.
#' @param node_size Numeric value for node size. Default is 12.
#' @param label_size Numeric value for label text size inside nodes. Default is 4.
#' @param arrow_size Numeric value for arrow size. Default is 3.
#' @param title Optional character string for plot title. If NULL, auto-generated.
#'
#' @return A list of ggplot objects. For BNM, a single-element list.
#'   For LDLRA/LDB, one plot per rank/class. For BINET, the integrated graph.
#'
#' @details
#' Design follows TDE figure specifications:
#' \itemize{
#'   \item BNM: Items shown as purple circles with numbers inside
#'   \item LDLRA: Items as circles per rank/class (to be implemented)
#'   \item LDB: Fields shown as green diamonds (to be implemented)
#'   \item BINET: Classes (blue rectangles) + Fields (green diamonds) (to be implemented)
#' }
#'
#' \strong{Direction Guidelines:}
#'
#' Choose the direction that best represents your data structure:
#' \itemize{
#'   \item Use \strong{BT (default)} for learning progression, skill development, or upward growth
#'   \item Use \strong{TB} for traditional hierarchies or causal flows
#'   \item Use \strong{LR/RL} for temporal sequences or wide-format displays
#' }
#'
#' \strong{Auto-Scaling:}
#'
#' The function automatically scales node and arrow sizes based on graph complexity:
#' \itemize{
#'   \item 1-5 nodes: 100\% size
#'   \item 6-10 nodes: 80\% size
#'   \item 11-20 nodes: 60\% size
#'   \item 21+ nodes: 50\% size
#' }
#' Arrows maintain a minimum size of 2mm to ensure visibility.
#'
#' @examples
#' \dontrun{
#' library(exametrika)
#' library(ggExametrika)
#'
#' # BNM example
#' DAG <- matrix(c("Item01", "Item02", "Item02", "Item03",
#'                 "Item02", "Item04", "Item03", "Item05",
#'                 "Item04", "Item05"), ncol = 2, byrow = TRUE)
#' g <- igraph::graph_from_data_frame(DAG)
#' result <- BNM(J5S10, g = g)
#'
#' # Default: Bottom-to-Top (arrows point upward)
#' plots <- plotGraph_gg(result)
#' plots[[1]]
#'
#' # Alternative directions
#' plotGraph_gg(result, direction = "TB")[[1]]  # Top-to-Bottom
#' plotGraph_gg(result, direction = "LR")[[1]]  # Left-to-Right
#' plotGraph_gg(result, direction = "RL")[[1]]  # Right-to-Left
#'
#' # Force-directed layout (no direction parameter)
#' plotGraph_gg(result, layout = "fr")[[1]]
#'
#' # Custom title
#' plotGraph_gg(result, title = "My Network Model")[[1]]
#' }
#'
#' @importFrom ggraph ggraph geom_edge_link geom_node_point geom_node_text
#' @importFrom ggplot2 ggplot aes theme_void ggtitle scale_fill_manual guide_legend
#' @importFrom igraph V E vcount ecount
#' @export

plotGraph_gg <- function(data,
                         layout = "sugiyama",
                         direction = "BT",
                         node_size = 12,
                         label_size = 4,
                         arrow_size = 3,
                         title = NULL) {

  # Check class
  model_class <- class(data)[2]
  if (!model_class %in% c("BNM", "LDLRA", "LDB", "BINET")) {
    stop("This function supports BNM, LDLRA, LDB, and BINET models only.")
  }

  # Currently BNM and LDLRA are implemented
  if (!model_class %in% c("BNM", "LDLRA")) {
    stop(paste0(model_class, " is not yet implemented. ",
                "Development order: BNM -> LDLRA -> LDB -> BINET"))
  }

  # ===================================================================
  # BNM Implementation
  # ===================================================================
  if (model_class == "BNM") {
    g <- data$g

    # Extract node numbers from names (e.g., "Item01" -> "1", "Item10" -> "10")
    node_names <- igraph::V(g)$name
    node_numbers <- gsub("Item0?", "", node_names)

    # Add node attributes
    igraph::V(g)$node_number <- node_numbers
    igraph::V(g)$node_type <- "Item"  # For future use with legend

    # Dynamic scaling based on number of nodes
    n_nodes <- igraph::vcount(g)
    n_edges <- igraph::ecount(g)

    # Adjust sizes based on graph complexity
    # More nodes = smaller sizes to fit in view
    if (n_nodes <= 5) {
      scale_factor <- 1.0
    } else if (n_nodes <= 10) {
      scale_factor <- 0.8
    } else if (n_nodes <= 20) {
      scale_factor <- 0.6
    } else {
      scale_factor <- 0.5
    }

    # Apply scaling to parameters
    scaled_node_size <- node_size * scale_factor
    scaled_arrow_size <- max(arrow_size * scale_factor, 2.0)  # Minimum 2mm for arrows
    scaled_label_size <- label_size * scale_factor

    # Create plot
    plot_title <- if (is.null(title)) "Bayesian Network Model" else title

    # Compute layout and apply direction transformation
    if (layout == "sugiyama") {
      # Use igraph's sugiyama layout
      lay <- igraph::layout_with_sugiyama(g)$layout

      # Apply direction transformation
      if (direction == "BT") {
        # Bottom-to-top: flip y-axis
        lay[, 2] <- -lay[, 2]
      } else if (direction == "TB") {
        # Top-to-bottom: default, no change
      } else if (direction == "LR") {
        # Left-to-right: swap x and y
        lay <- lay[, c(2, 1)]
      } else if (direction == "RL") {
        # Right-to-left: swap and flip x
        lay <- lay[, c(2, 1)]
        lay[, 1] <- -lay[, 1]
      }
    } else {
      # For non-hierarchical layouts, use ggraph's default
      lay <- layout
    }

    p <- ggraph::ggraph(g, layout = lay) +
      # Edges with arrows (scaled)
      ggraph::geom_edge_link(
        arrow = grid::arrow(length = grid::unit(scaled_arrow_size, "mm"), type = "closed"),
        end_cap = ggraph::circle(scaled_node_size / 1.5, "mm"),
        color = "gray30",
        width = 0.8 * scale_factor
      ) +
      # Nodes as circles (items are circles, not rectangles) (scaled)
      ggraph::geom_node_point(
        ggplot2::aes(fill = node_type),
        shape = 21,  # Circle with fill
        size = scaled_node_size,
        color = "black",
        stroke = 1.2 * scale_factor,
        show.legend = FALSE
      ) +
      # Numbers inside nodes (scaled)
      ggraph::geom_node_text(
        ggplot2::aes(label = node_number),
        size = scaled_label_size,
        color = "black",
        fontface = "bold"
      ) +
      # Color scale for nodes
      ggplot2::scale_fill_manual(
        values = c("Item" = "#A23B72"),  # Purple
        name = "",
        labels = c("Item" = "Item")
      ) +
      # Theme and labels
      ggplot2::theme_void() +
      ggplot2::ggtitle(plot_title) +
      ggplot2::theme(
        plot.title = ggplot2::element_text(
          size = 14,
          face = "bold",
          hjust = 0.5,
          margin = ggplot2::margin(b = 10)
        ),
        plot.margin = ggplot2::margin(15, 15, 15, 15)  # Add margin to prevent cutoff
      )

    return(list(p))
  }
}
