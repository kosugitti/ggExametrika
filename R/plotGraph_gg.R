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
#'     \item \strong{"TB"} (default): Top-to-Bottom. Source (parent) nodes at
#'           top, arrows point downward. Traditional hierarchical view.
#'     \item \strong{"BT"}: Bottom-to-Top. Source nodes at bottom, arrows point upward.
#'           Use when representing progression or growth (e.g., learning paths).
#'           This was the default before version 1.3.0.
#'     \item \strong{"LR"}: Left-to-Right. Source nodes at left, arrows point right.
#'           Good for wide displays or process flows.
#'     \item \strong{"RL"}: Right-to-Left. Source nodes at right, arrows point left.
#'           Alternative horizontal layout.
#'   }
#'   For other layouts (e.g., "fr", "kk"), this parameter is ignored.
#' @param node_size Numeric value for node size. Default is 12.
#' @param label_size Numeric value for label text size inside nodes. Default is 4.
#' @param arrow_size Numeric value for arrow size. Default is 3.
#' @param title Logical or character. If \code{TRUE} (default), display an
#'   auto-generated title. If \code{FALSE}, no title. If a character string,
#'   use it as a custom title. For LDLRA, a single string gets " - Rank N"
#'   appended; a character vector of length equal to the number of ranks
#'   assigns each element as the title for the corresponding rank.
#' @param colors Character vector. Colors for node types.
#'   For BNM with \code{fill_by = "crr"}: two colors for the low and high
#'   ends of the correct-response-rate gradient.
#'   For BNM with \code{fill_by = "type"} and LDLRA: single color for Item nodes.
#'   For LDB: single color for Field nodes.
#'   For BINET: two colors for Class and Field nodes (positional or named).
#'   If \code{NULL} (default), uses the default node type colors
#'   (Item=purple, Field=green, Class=blue).
#' @param fill_by Character. BNM only: how Item nodes are filled.
#'   \code{"crr"} (default) shades each node by the item's correct response
#'   rate (\code{data$crr}), so easy and hard items can be told apart at a
#'   glance; \code{"type"} uses a single color for all
#'   Item nodes (the behavior before version 1.3.0). Ignored for LDLRA, LDB
#'   and BINET.
#' @param fill_limits Numeric vector of length 2, or \code{NULL} (default).
#'   Range of the correct-response-rate color scale. \code{NULL} stretches the
#'   scale over the observed rates, which keeps differences visible when all
#'   rates are close (e.g. rare symptoms); \code{c(0, 1)} fixes the scale so
#'   plots from different data sets can be compared. Used only with
#'   \code{fill_by = "crr"}.
#' @param show_isolated Logical. Whether to draw nodes with no edges
#'   (items or fields unrelated to all others) for BNM, LDLRA and LDB.
#'   \code{FALSE} (default) leaves them out of the graph but lists them in a
#'   caption under the plot (e.g. "Isolated items: 5, 9"), so it stays
#'   visible that they exist and are unconnected. \code{TRUE} draws them in
#'   a row of their own after the last layer of the hierarchical layout.
#'   Ignored for BINET.
#' @param show_legend Logical. If \code{TRUE}, display the legend (the
#'   correct-response-rate color bar for BNM with \code{fill_by = "crr"},
#'   otherwise the node type legend). If \code{NULL} (default), the color bar
#'   is shown for BNM with \code{fill_by = "crr"} and no legend otherwise.
#' @param legend_position Character. Position of the legend.
#'   One of \code{"right"} (default), \code{"top"}, \code{"bottom"},
#'   \code{"left"}, \code{"none"}.
#'
#' @note The \code{linetype} common option is not applicable to DAG visualization,
#'   as edges are drawn as directed arrows rather than standard lines.
#'
#' @return A list of ggplot objects. For BNM, a single-element list.
#'   For LDLRA/LDB, one plot per rank/class. For BINET, the integrated graph.
#'
#' @details
#' Design follows TDE figure specifications:
#' \itemize{
#'   \item BNM: Items shown as circles with numbers inside, shaded by
#'         correct response rate (or a single purple with \code{fill_by = "type"})
#'   \item LDLRA: Items as circles per rank/class, one plot per rank
#'   \item LDB: Fields shown as green diamonds, one plot per rank
#'   \item BINET: Integrated graph with Class nodes (blue squares) and Field nodes
#'         (green diamonds) as intermediates. Field nodes are smaller and placed between
#'         the Class nodes they connect
#' }
#'
#' \strong{Direction Guidelines:}
#'
#' Choose the direction that best represents your data structure:
#' \itemize{
#'   \item Use \strong{TB (default)} for traditional hierarchies or causal flows
#'   \item Use \strong{BT} for learning progression, skill development, or upward growth
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
#' @examplesIf requireNamespace("exametrika", quietly = TRUE)
#' library(exametrika)
#' library(ggExametrika)
#'
#' # BNM example
#' DAG <- matrix(c(
#'   "Item01", "Item02", "Item02", "Item03",
#'   "Item02", "Item04", "Item03", "Item05",
#'   "Item04", "Item05"
#' ), ncol = 2, byrow = TRUE)
#' items <- J5S10$ItemLabel
#' adj <- matrix(0, length(items), length(items), dimnames = list(items, items))
#' adj[DAG] <- 1
#' result <- BNM(J5S10, adj_matrix = adj)
#'
#' # Default: Top-to-Bottom (parents on top, arrows point downward)
#' plots <- plotGraph_gg(result)
#' plots[[1]]
#'
#' # Alternative directions
#' plotGraph_gg(result, direction = "BT")[[1]] # Bottom-to-Top
#' plotGraph_gg(result, direction = "LR")[[1]] # Left-to-Right
#' plotGraph_gg(result, direction = "RL")[[1]] # Right-to-Left
#'
#' # Force-directed layout (no direction parameter)
#' plotGraph_gg(result, layout = "fr")[[1]]
#'
#' # Fixed 0-1 color scale (comparable across plots) or a single color
#' plotGraph_gg(result, fill_limits = c(0, 1))[[1]]
#' plotGraph_gg(result, fill_by = "type")[[1]]
#'
#' # Custom title
#' plotGraph_gg(result, title = "My Network Model")[[1]]
#'
#' @importFrom ggraph ggraph geom_edge_link geom_node_point geom_node_text
#' @importFrom ggplot2 ggplot aes theme_void ggtitle scale_fill_manual
#' @importFrom igraph V E vcount ecount
#' @export

plotGraph_gg <- function(data,
                         layout = "sugiyama",
                         direction = "TB",
                         node_size = 12,
                         label_size = 4,
                         arrow_size = 3,
                         title = TRUE,
                         colors = NULL,
                         fill_by = c("crr", "type"),
                         fill_limits = NULL,
                         show_isolated = FALSE,
                         show_legend = NULL,
                         legend_position = "right") {
  # Check class
  model_class <- .validate_exametrika(data, c("BNM", "LDLRA", "LDB", "BINET"))
  fill_by <- match.arg(fill_by)
  if (!is.null(fill_limits) &&
    !(is.numeric(fill_limits) && length(fill_limits) == 2 && !anyNA(fill_limits))) {
    stop("'fill_limits' must be NULL or a numeric vector of length 2.")
  }
  fill_crr <- model_class == "BNM" && fill_by == "crr"
  if (is.null(show_legend)) {
    show_legend <- fill_crr
  }

  # All four DAG models are implemented
  # Development order was: BNM -> LDLRA -> LDB -> BINET

  # ===================================================================
  # BNM Implementation
  # ===================================================================
  if (model_class == "BNM") {
    iso <- .dag_split_isolated(.dag_fit_graph(data), show_isolated, "items", "")
    g <- iso$g

    # Add node attributes
    node_names <- igraph::V(g)$name
    igraph::V(g)$node_number <- .dag_node_number(node_names)
    igraph::V(g)$node_type <- "Item"

    # Compute layout
    lay <- .dag_compute_layout(g, layout, direction, iso$isolated)

    # Apply scaling
    scales <- .dag_scale_factors(igraph::vcount(g), node_size, arrow_size, label_size)

    # Set node colors and shapes
    node_shapes <- .dag_node_shapes("Item")
    if (fill_crr) {
      igraph::V(g)$crr <- .dag_node_crr(data$crr, node_names)
      node_colors <- .dag_crr_colors(colors)
    } else {
      node_colors <- .dag_node_colors("Item", colors)
    }

    # Set title
    if (is.logical(title) && title) {
      plot_title <- "Bayesian Network Model"
    } else if (is.logical(title) && !title) {
      plot_title <- NULL
    } else {
      plot_title <- as.character(title)[1]
    }

    p <- .dag_build_plot(
      g, lay, scales, node_colors, node_shapes,
      plot_title, show_legend, legend_position,
      fill_crr = fill_crr, fill_limits = fill_limits,
      caption = iso$caption
    )

    return(list(p))
  }

  # ===================================================================
  # LDLRA Implementation
  # ===================================================================
  if (model_class == "LDLRA") {
    n_ranks <- data$n_class
    plot_list <- vector("list", n_ranks)

    for (i in seq_len(n_ranks)) {
      # Isolated nodes: dropped (listed in a caption) unless show_isolated
      iso <- .dag_split_isolated(
        .dag_fit_graph(data, i), show_isolated, "items", paste0("Rank ", i, ": ")
      )
      g <- iso$g

      # Skip empty graphs
      if (igraph::vcount(g) == 0) {
        warning("Rank ", i, ": No connected nodes found - skipping")
        next
      }

      # Add node attributes
      node_names <- igraph::V(g)$name
      igraph::V(g)$node_number <- .dag_node_number(node_names)
      igraph::V(g)$node_type <- "Item"

      # Compute layout and scaling
      lay <- .dag_compute_layout(g, layout, direction, iso$isolated)
      scales <- .dag_scale_factors(igraph::vcount(g), node_size, arrow_size, label_size)

      # Set node colors and shapes
      node_colors <- .dag_node_colors("Item", colors)
      node_shapes <- .dag_node_shapes("Item")

      # Set title (common option: logical or character vector)
      if (is.logical(title) && title) {
        plot_title <- paste0("LDLRA - Rank ", i)
      } else if (is.logical(title) && !title) {
        plot_title <- NULL
      } else if (is.character(title) && length(title) == 1) {
        plot_title <- paste0(title, " - Rank ", i)
      } else if (is.character(title) && length(title) >= i) {
        plot_title <- title[i]
      } else {
        plot_title <- paste0("LDLRA - Rank ", i)
      }

      plot_list[[i]] <- .dag_build_plot(
        g, lay, scales, node_colors, node_shapes,
        plot_title, show_legend, legend_position,
        caption = iso$caption
      )
    }

    return(plot_list)
  }

  # ===================================================================
  # LDB Implementation
  # ===================================================================
  if (model_class == "LDB") {
    n_ranks <- data$n_rank
    plot_list <- vector("list", n_ranks)

    # LDB uses Field nodes (green diamonds) instead of Item nodes (purple circles)
    node_colors <- .dag_node_colors("Field", colors)
    node_shapes <- .dag_node_shapes("Field")

    for (i in seq_len(n_ranks)) {
      # Isolated nodes: dropped (listed in a caption) unless show_isolated
      iso <- .dag_split_isolated(
        .dag_fit_graph(data, i), show_isolated, "fields", paste0("Rank ", i, ": ")
      )
      g <- iso$g

      # Skip empty graphs
      if (igraph::vcount(g) == 0) {
        warning("Rank ", i, ": No connected nodes found - skipping")
        next
      }

      # Add node attributes
      node_names <- igraph::V(g)$name
      igraph::V(g)$node_number <- .dag_node_number(node_names)
      igraph::V(g)$node_type <- "Field"

      # Compute layout and scaling
      lay <- .dag_compute_layout(g, layout, direction, iso$isolated)
      scales <- .dag_scale_factors(igraph::vcount(g), node_size, arrow_size, label_size)

      # Set title
      if (is.logical(title) && title) {
        plot_title <- paste0("LDB - Rank ", i)
      } else if (is.logical(title) && !title) {
        plot_title <- NULL
      } else if (is.character(title) && length(title) == 1) {
        plot_title <- paste0(title, " - Rank ", i)
      } else if (is.character(title) && length(title) >= i) {
        plot_title <- title[i]
      } else {
        plot_title <- paste0("LDB - Rank ", i)
      }

      plot_list[[i]] <- .dag_build_plot(
        g, lay, scales, node_colors, node_shapes,
        plot_title, show_legend, legend_position,
        caption = iso$caption
      )
    }

    return(plot_list)
  }

  # ===================================================================
  # BINET Implementation
  # ===================================================================
  if (model_class == "BINET") {
    # Expand graph: insert Field nodes as intermediates between Class nodes
    g <- .binet_expand_graph(.dag_fit_graph(data))

    # Compute layout and scaling
    lay <- .dag_compute_layout(g, layout, direction)
    scales <- .dag_scale_factors(igraph::vcount(g), node_size, arrow_size, label_size)

    # Set node colors and shapes (two types: Class + Field)
    node_types <- c("Class", "Field")
    node_colors <- .dag_node_colors(node_types, colors)
    node_shapes <- .dag_node_shapes(node_types)

    # Size maps: Class nodes larger, Field nodes smaller (60%)
    node_size_map <- c(Class = scales$node, Field = scales$node * 0.6)
    label_size_map <- c(Class = scales$label, Field = scales$label * 0.75)

    # Set title
    if (is.logical(title) && title) {
      plot_title <- "Bicluster Network Model"
    } else if (is.logical(title) && !title) {
      plot_title <- NULL
    } else {
      plot_title <- as.character(title)[1]
    }

    p <- .dag_build_plot(
      g, lay, scales, node_colors, node_shapes,
      plot_title, show_legend, legend_position,
      node_size_map = node_size_map,
      label_size_map = label_size_map
    )

    return(list(p))
  }
}

# ===================================================================
# Internal helper functions for DAG visualization
# ===================================================================

# The DAG of a fit as an igraph object, built from the adjacency matrix
# (BNM: `adj`; LDLRA/LDB: `adj_list[[i]]`) or the edge table (BINET:
# `all_edges`, columns From/To/Field) that exametrika returns. The igraph
# objects `g`, `g_list` and `all_g` in the fit are used only when the
# matrix form is missing (exametrika < 2.3.0 for BINET); they go away in
# exametrika 3.0.0.
.dag_fit_graph <- function(data, i = NULL) {
  if (inherits(data, "BINET")) {
    if (!is.null(data$all_edges)) {
      return(igraph::graph_from_data_frame(data$all_edges, directed = TRUE))
    }
    return(data$all_g)
  }
  if (is.null(i)) {
    if (!is.null(data$adj)) {
      return(igraph::graph_from_adjacency_matrix(data$adj))
    }
    return(data$g)
  }
  if (!is.null(data$adj_list)) {
    return(igraph::graph_from_adjacency_matrix(data$adj_list[[i]]))
  }
  data$g_list[[i]]
}

# Extract short node number label from node name (e.g. "Item01" -> "1", "Item10" -> "10")
# perl = TRUE matters: the default (TRE) engine treats the lazy `.*?` as greedy,
# so "Item10" used to become "0" and "Item14" "4".
.dag_node_number <- function(node_names) {
  number <- sub("^.*?(\\d+)$", "\\1", node_names, perl = TRUE)
  sub("^0+(?=\\d)", "", number, perl = TRUE)
}

# Compute scale factors based on node count
.dag_scale_factors <- function(n_nodes, node_size, arrow_size, label_size) {
  scale_factor <- if (n_nodes <= 5) {
    1.0
  } else if (n_nodes <= 10) {
    0.8
  } else if (n_nodes <= 20) {
    0.6
  } else {
    0.5
  }
  list(
    node  = node_size * scale_factor,
    arrow = max(arrow_size * scale_factor, 2.0),
    label = label_size * scale_factor,
    base  = scale_factor
  )
}

# Return node fill colors as named vector by node type
.dag_node_colors <- function(node_type, colors) {
  defaults <- c(Item = "#A23B72", Field = "#4CAF50", Class = "#1976D2")
  if (is.null(colors)) {
    defaults[node_type]
  } else if (!is.null(names(colors))) {
    colors[node_type]
  } else {
    stats::setNames(colors[seq_along(node_type)], node_type)
  }
}

# Correct response rate for each node, matched by item label.
# exametrika returns crr as a one-column matrix with item labels as row names;
# fall back to position when the labels do not line up.
.dag_node_crr <- function(crr, node_names) {
  values <- as.numeric(crr)
  labels <- rownames(crr)
  if (is.null(labels)) {
    labels <- names(crr)
  }
  if (!is.null(labels) && all(node_names %in% labels)) {
    return(values[match(node_names, labels)])
  }
  values[seq_along(node_names)]
}

# Low/high ends of the correct-response-rate gradient
.dag_crr_colors <- function(colors) {
  if (is.null(colors)) {
    return(c(low = "#F7E6EF", high = "#A23B72"))
  }
  if (length(colors) < 2) {
    stop("For fill_by = \"crr\", 'colors' needs two colors (low and high).")
  }
  stats::setNames(colors[1:2], c("low", "high"))
}

# Return node shapes as named vector by node type
.dag_node_shapes <- function(node_type) {
  shapes <- c(Item = 21, Field = 23, Class = 22) # circle, diamond, square
  shapes[node_type]
}

# Expand BINET graph: insert Field nodes as intermediates between Class nodes
# Input: all_g with Class vertices and edges with $Field attribute
# Output: igraph with Class + Field vertices, edges Class->Field->Class
.binet_expand_graph <- function(all_g) {
  edges <- igraph::as_data_frame(all_g, what = "edges")
  class_names <- igraph::V(all_g)$name

  # Build new node and edge lists
  new_nodes <- data.frame(
    name = class_names,
    node_type = "Class",
    node_number = .dag_node_number(class_names),
    stringsAsFactors = FALSE
  )
  new_edges <- data.frame(
    from = character(0), to = character(0),
    stringsAsFactors = FALSE
  )

  for (k in seq_len(nrow(edges))) {
    from_cls <- edges$from[k]
    to_cls <- edges$to[k]
    field_label <- edges$Field[k]
    # Unique intermediate node name per edge
    field_id <- paste0(field_label, "_", from_cls, "_", to_cls)
    field_num <- .dag_node_number(field_label)

    new_nodes <- rbind(new_nodes, data.frame(
      name = field_id, node_type = "Field", node_number = field_num,
      stringsAsFactors = FALSE
    ))
    new_edges <- rbind(
      new_edges,
      data.frame(from = from_cls, to = field_id, stringsAsFactors = FALSE),
      data.frame(from = field_id, to = to_cls, stringsAsFactors = FALSE)
    )
  }

  g <- igraph::graph_from_data_frame(new_edges,
    directed = TRUE,
    vertices = new_nodes
  )
  g
}

# Split off nodes with no edges.
# show_isolated = FALSE: drop them, report them in a message and a caption so
# that an unconnected item never disappears without a trace.
# show_isolated = TRUE: keep them; their names are returned so the layout can
# put them in a row of their own.
.dag_split_isolated <- function(g, show_isolated, unit, msg_prefix) {
  degree <- igraph::degree(g, mode = "all")
  isolated <- names(degree[degree == 0])
  if (length(isolated) == 0) {
    return(list(g = g, isolated = NULL, caption = NULL))
  }
  if (show_isolated) {
    return(list(g = g, isolated = isolated, caption = NULL))
  }
  numbers <- .dag_node_number(isolated)
  message(
    msg_prefix, "Removing ", length(isolated), " isolated node(s): ",
    paste(numbers, collapse = ", ")
  )
  list(
    g = igraph::delete_vertices(g, isolated),
    isolated = NULL,
    caption = paste0("Isolated ", unit, ": ", paste(numbers, collapse = ", "))
  )
}

# Compute graph layout matrix
# isolated: names of edge-less nodes to place in a row after the last layer
# (sugiyama only; otherwise they keep the position the layout gives them).
.dag_compute_layout <- function(g, layout, direction, isolated = NULL) {
  if (layout != "sugiyama") {
    return(layout)
  }
  lay <- igraph::layout_with_sugiyama(g)$layout
  is_iso <- igraph::V(g)$name %in% isolated
  if (any(is_iso)) {
    # Raw sugiyama: sources have the largest y, so "after the last layer"
    # is one step below the smallest y among connected nodes.
    y_conn <- if (any(!is_iso)) min(lay[!is_iso, 2]) else 1
    x_conn <- if (any(!is_iso)) mean(range(lay[!is_iso, 1])) else 0
    k <- sum(is_iso)
    lay[is_iso, 2] <- y_conn - 1
    lay[is_iso, 1] <- x_conn + seq_len(k) - (k + 1) / 2
  }
  if (direction == "BT") {
    lay[, 2] <- -lay[, 2]
  } else if (direction == "TB") {
    # default, no change
  } else if (direction == "LR") {
    lay <- lay[, c(2, 1)]
    lay[, 1] <- -lay[, 1]
  } else if (direction == "RL") {
    lay <- lay[, c(2, 1)]
  }
  lay
}

# Build a single DAG ggplot from a prepared igraph + layout
# node_size_map / label_size_map: optional named vectors (e.g. c(Class=12, Field=7))
#   When NULL (default), all nodes use uniform scales$node / scales$label.
#   When provided, node sizes vary by node_type (used for BINET).
.dag_build_plot <- function(g, lay, scales, node_colors, node_shapes,
                            plot_title, show_legend, legend_position,
                            node_size_map = NULL, label_size_map = NULL,
                            fill_crr = FALSE, fill_limits = NULL,
                            caption = NULL) {
  # Compute expand margin so nodes are never clipped.
  # node_size (ggplot pt units) / coordinate range determines needed padding.
  # Larger nodes need proportionally more space; clamp to [0.20, 0.45].
  expand_mult <- min(max(0.15 + scales$node * 0.012, 0.20), 0.45)

  # Variable node sizes: set vertex attributes when size map is provided
  if (!is.null(node_size_map)) {
    igraph::V(g)$node_size_val <- node_size_map[igraph::V(g)$node_type]
  }
  if (!is.null(label_size_map)) {
    igraph::V(g)$label_size_val <- label_size_map[igraph::V(g)$node_type]
  }

  p <- ggraph::ggraph(g, layout = lay) +
    ggraph::geom_edge_link(
      arrow = grid::arrow(length = grid::unit(scales$arrow, "mm"), type = "closed"),
      end_cap = ggraph::circle(scales$node / 1.5, "mm"),
      color = "gray30",
      width = 0.8 * scales$base
    )

  # Node points: variable or uniform size
  use_size_identity <- !is.null(node_size_map) || !is.null(label_size_map)
  if (!is.null(node_size_map)) {
    p <- p + ggraph::geom_node_point(
      ggplot2::aes(fill = node_type, shape = node_type, size = node_size_val),
      color = "black",
      stroke = 1.2 * scales$base,
      show.legend = show_legend
    )
  } else if (fill_crr) {
    p <- p + ggraph::geom_node_point(
      ggplot2::aes(fill = crr, shape = node_type),
      size = scales$node,
      color = "black",
      stroke = 1.2 * scales$base,
      show.legend = show_legend
    )
  } else {
    p <- p + ggraph::geom_node_point(
      ggplot2::aes(fill = node_type, shape = node_type),
      size = scales$node,
      color = "black",
      stroke = 1.2 * scales$base,
      show.legend = show_legend
    )
  }

  # Node labels: variable or uniform size
  if (!is.null(label_size_map)) {
    p <- p + ggraph::geom_node_text(
      ggplot2::aes(label = node_number, size = label_size_val),
      color = "black",
      fontface = "bold",
      show.legend = FALSE
    )
  } else {
    p <- p + ggraph::geom_node_text(
      ggplot2::aes(label = node_number),
      size = scales$label,
      color = "black",
      fontface = "bold"
    )
  }

  # Add identity scale once if any size mapping is used
  if (use_size_identity) {
    p <- p + ggplot2::scale_size_identity()
  }

  if (fill_crr) {
    p <- p +
      ggplot2::scale_fill_gradient(
        low = node_colors[["low"]],
        high = node_colors[["high"]],
        limits = fill_limits,
        name = "Correct\nresponse\nrate"
      ) +
      ggplot2::guides(shape = "none")
  } else {
    p <- p +
      ggplot2::scale_fill_manual(
        values = node_colors,
        name = ""
      )
  }
  p <- p +
    ggplot2::scale_shape_manual(
      values = node_shapes,
      name = ""
    ) +
    ggplot2::scale_x_continuous(
      expand = ggplot2::expansion(mult = expand_mult)
    ) +
    ggplot2::scale_y_continuous(
      expand = ggplot2::expansion(mult = expand_mult)
    ) +
    ggplot2::theme_void() +
    ggplot2::theme(plot.margin = ggplot2::margin(15, 15, 15, 15))

  if (!is.null(caption)) {
    p <- p + ggplot2::labs(caption = caption) +
      ggplot2::theme(plot.caption = ggplot2::element_text(hjust = 0.5))
  }

  if (!is.null(plot_title)) {
    p <- p + ggplot2::ggtitle(plot_title) +
      ggplot2::theme(
        plot.title = ggplot2::element_text(
          size = 14,
          face = "bold",
          hjust = 0.5,
          margin = ggplot2::margin(b = 10)
        )
      )
  }

  if (!show_legend) {
    p <- p + ggplot2::theme(legend.position = "none")
  } else {
    p <- p + ggplot2::theme(legend.position = legend_position)
  }

  p
}
