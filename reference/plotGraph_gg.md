# Plot DAG (Directed Acyclic Graph) from exametrika

Creates a ggplot2-based visualization of DAG structures from exametrika
Bayesian network models. Supports BNM, LDLRA, LDB, and BINET models.

## Usage

``` r
plotGraph_gg(
  data,
  layout = "sugiyama",
  rankdir = "TB",
  node_size = 8,
  node_color = "steelblue",
  label_size = 3,
  arrow_size = 2,
  edge_color = "gray40",
  show_edge_label = TRUE,
  title = NULL
)
```

## Arguments

- data:

  An object of class "exametrika" with model type BNM, LDLRA, LDB, or
  BINET.

- layout:

  Character string specifying the layout algorithm. Options include
  "sugiyama" (default, hierarchical), "fr" (Fruchterman-Reingold), "kk"
  (Kamada-Kawai), "tree", "circle", "grid", "stress".

- rankdir:

  Direction for hierarchical layouts. "TB" (top-to-bottom, default),
  "BT" (bottom-to-top), "LR" (left-to-right), "RL" (right-to-left).

- node_size:

  Numeric value for node size. Default is 8.

- node_color:

  Color for nodes. Default is "steelblue".

- label_size:

  Numeric value for label text size. Default is 3.

- arrow_size:

  Numeric value for arrow size. Default is 2.

- edge_color:

  Color for edges. Default is "gray40".

- show_edge_label:

  Logical. If TRUE, show edge labels (for BINET model). Default is TRUE.

- title:

  Optional character string for plot title. If NULL, auto-generated.

## Value

A list of ggplot objects. For BNM, a single-element list. For LDLRA/LDB,
one plot per rank/class. For BINET, the integrated graph.

## Details

This function uses the ggraph package to create network visualizations.
The layout algorithm can significantly affect the readability of the
graph:

- "sugiyama": Best for DAGs, creates hierarchical layout

- "tree": Good for tree-like structures

- "fr": Force-directed, good for general networks

- "stress": Minimizes stress, often produces clean layouts

## Examples

``` r
if (FALSE) { # \dontrun{
library(exametrika)
# BNM example
DAG <- matrix(c("Item01", "Item02", "Item02", "Item03",
                "Item02", "Item04", "Item03", "Item05",
                "Item04", "Item05"), ncol = 2, byrow = TRUE)
g <- igraph::graph_from_data_frame(DAG)
result <- BNM(J5S10, g = g)
plots <- plotGraph_gg(result)
plots[[1]]

# LDLRA example
result_ldlra <- LDLRA(J15S500, ncls = 3)
plots <- plotGraph_gg(result_ldlra)
combinePlots_gg(plots)
} # }
```
