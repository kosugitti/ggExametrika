# Plot DAG (Directed Acyclic Graph) from exametrika

Creates a ggplot2-based visualization of DAG structures from exametrika
Bayesian network models. Supports BNM, LDLRA, LDB, and BINET models.
Design based on TDE figures with items as rounded rectangles and fields
as diamonds.

## Usage

``` r
plotGraph_gg(
  data,
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
  legend_position = "right"
)
```

## Arguments

- data:

  An object of class "exametrika" with model type BNM, LDLRA, LDB, or
  BINET.

- layout:

  Character string specifying the layout algorithm. Options include
  "sugiyama" (default, hierarchical), "fr" (Fruchterman-Reingold), "kk"
  (Kamada-Kawai), "tree", "stress".

- direction:

  Character string for hierarchical layout direction. Controls the
  direction of arrows and node placement in hierarchical layouts. Only
  applies when `layout = "sugiyama"` (default).

  - **"TB"** (default): Top-to-Bottom. Source (parent) nodes at top,
    arrows point downward. Traditional hierarchical view.

  - **"BT"**: Bottom-to-Top. Source nodes at bottom, arrows point
    upward. Use when representing progression or growth (e.g., learning
    paths). This was the default before version 1.3.0.

  - **"LR"**: Left-to-Right. Source nodes at left, arrows point right.
    Good for wide displays or process flows.

  - **"RL"**: Right-to-Left. Source nodes at right, arrows point left.
    Alternative horizontal layout.

  For other layouts (e.g., "fr", "kk"), this parameter is ignored.

- node_size:

  Numeric value for node size. Default is 12.

- label_size:

  Numeric value for label text size inside nodes. Default is 4.

- arrow_size:

  Numeric value for arrow size. Default is 3.

- title:

  Logical or character. If `TRUE` (default), display an auto-generated
  title. If `FALSE`, no title. If a character string, use it as a custom
  title. For LDLRA, a single string gets " - Rank N" appended; a
  character vector of length equal to the number of ranks assigns each
  element as the title for the corresponding rank.

- colors:

  Character vector. Colors for node types. For BNM with
  `fill_by = "crr"`: two colors for the low and high ends of the
  correct-response-rate gradient. For BNM with `fill_by = "type"` and
  LDLRA: single color for Item nodes. For LDB: single color for Field
  nodes. For BINET: two colors for Class and Field nodes (positional or
  named). If `NULL` (default), uses the default node type colors
  (Item=purple, Field=green, Class=blue).

- fill_by:

  Character. BNM only: how Item nodes are filled. `"crr"` (default)
  shades each node by the item's correct response rate (`data$crr`), so
  easy and hard items can be told apart at a glance; `"type"` uses a
  single color for all Item nodes (the behavior before version 1.3.0).
  Ignored for LDLRA, LDB and BINET.

- fill_limits:

  Numeric vector of length 2, or `NULL` (default). Range of the
  correct-response-rate color scale. `NULL` stretches the scale over the
  observed rates, which keeps differences visible when all rates are
  close (e.g. rare symptoms); `c(0, 1)` fixes the scale so plots from
  different data sets can be compared. Used only with `fill_by = "crr"`.

- show_isolated:

  Logical. Whether to draw nodes with no edges (items or fields
  unrelated to all others) for BNM, LDLRA and LDB. `FALSE` (default)
  leaves them out of the graph but lists them in a caption under the
  plot (e.g. "Isolated items: 5, 9"), so it stays visible that they
  exist and are unconnected. `TRUE` draws them in a row of their own
  after the last layer of the hierarchical layout. Ignored for BINET.

- show_legend:

  Logical. If `TRUE`, display the legend (the correct-response-rate
  color bar for BNM with `fill_by = "crr"`, otherwise the node type
  legend). If `NULL` (default), the color bar is shown for BNM with
  `fill_by = "crr"` and no legend otherwise.

- legend_position:

  Character. Position of the legend. One of `"right"` (default),
  `"top"`, `"bottom"`, `"left"`, `"none"`.

## Value

A list of ggplot objects. For BNM, a single-element list. For LDLRA/LDB,
one plot per rank/class. For BINET, the integrated graph.

## Details

Design follows TDE figure specifications:

- BNM: Items shown as circles with numbers inside, shaded by correct
  response rate (or a single purple with `fill_by = "type"`)

- LDLRA: Items as circles per rank/class, one plot per rank

- LDB: Fields shown as green diamonds, one plot per rank

- BINET: Integrated graph with Class nodes (blue squares) and Field
  nodes (green diamonds) as intermediates. Field nodes are smaller and
  placed between the Class nodes they connect

**Direction Guidelines:**

Choose the direction that best represents your data structure:

- Use **TB (default)** for traditional hierarchies or causal flows

- Use **BT** for learning progression, skill development, or upward
  growth

- Use **LR/RL** for temporal sequences or wide-format displays

**Auto-Scaling:**

The function automatically scales node and arrow sizes based on graph
complexity:

- 1-5 nodes: 100\\

- 6-10 nodes: 80\\

- 11-20 nodes: 60\\

- 21+ nodes: 50\\

Arrows maintain a minimum size of 2mm to ensure visibility.

## Note

The `linetype` common option is not applicable to DAG visualization, as
edges are drawn as directed arrows rather than standard lines.

## Examples

``` r
library(exametrika)
library(ggExametrika)

# BNM example
DAG <- matrix(c(
  "Item01", "Item02", "Item02", "Item03",
  "Item02", "Item04", "Item03", "Item05",
  "Item04", "Item05"
), ncol = 2, byrow = TRUE)
items <- J5S10$ItemLabel
adj <- matrix(0, length(items), length(items), dimnames = list(items, items))
adj[DAG] <- 1
result <- BNM(J5S10, adj_matrix = adj)

# Default: Top-to-Bottom (parents on top, arrows point downward)
plots <- plotGraph_gg(result)
plots[[1]]


# Alternative directions
plotGraph_gg(result, direction = "BT")[[1]] # Bottom-to-Top

plotGraph_gg(result, direction = "LR")[[1]] # Left-to-Right

plotGraph_gg(result, direction = "RL")[[1]] # Right-to-Left


# Force-directed layout (no direction parameter)
plotGraph_gg(result, layout = "fr")[[1]]


# Fixed 0-1 color scale (comparable across plots) or a single color
plotGraph_gg(result, fill_limits = c(0, 1))[[1]]

plotGraph_gg(result, fill_by = "type")[[1]]


# Custom title
plotGraph_gg(result, title = "My Network Model")[[1]]
```
