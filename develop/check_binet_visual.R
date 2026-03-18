# ============================================================
# Visual confirmation script for BINET DAG visualization
# Run: source("develop/check_binet_visual.R")
# ============================================================

library(exametrika)
devtools::load_all()

# ---- Create BINET fixture ----
cat("Creating BINET fixture...\n")
binet_conf <- rep(1:3, length.out = 35)
binet_edges <- data.frame(
  From  = c(1, 2, 1, 2, 1, 2),
  To    = c(2, 3, 2, 3, 2, 3),
  Field = c(1, 1, 2, 2, 3, 3)
)
binet_edge_file <- tempfile(fileext = ".csv")
write.csv(binet_edges, binet_edge_file, row.names = FALSE)
binet_result <- BINET(J35S515, ncls = 3, nfld = 3,
                      conf = binet_conf, adj_file = binet_edge_file,
                      verbose = FALSE)
unlink(binet_edge_file)
cat("BINET fixture created: Nclass =", binet_result$Nclass,
    ", Nfield =", binet_result$Nfield, "\n\n")

# ---- 1. Default BINET plot (BT direction) ----
cat("1. Default BINET plot (BT direction)\n")
plots <- plotGraph_gg(binet_result)
print(plots[[1]])
readline("Press Enter to continue...")

# ---- 2. All 4 directions ----
cat("2. All 4 directions\n")
dir_plots <- lapply(c("BT", "TB", "LR", "RL"), function(d) {
  plotGraph_gg(binet_result, direction = d, title = paste("BINET -", d))[[1]]
})
print(gridExtra::grid.arrange(grobs = dir_plots, ncol = 2))
readline("Press Enter to continue...")

# ---- 3. With legend ----
cat("3. With legend (show_legend = TRUE)\n")
p_legend <- plotGraph_gg(binet_result, show_legend = TRUE,
                         legend_position = "right")[[1]]
print(p_legend)
readline("Press Enter to continue...")

# ---- 4. Custom colors ----
cat("4. Custom colors (Class=red, Field=orange)\n")
p_colors <- plotGraph_gg(binet_result,
                         colors = c(Class = "#E53935", Field = "#FF9800"),
                         show_legend = TRUE)[[1]]
print(p_colors)
readline("Press Enter to continue...")

# ---- 5. Compare all 4 DAG models ----
cat("5. Comparing all 4 DAG models side by side\n")

# BNM
bnm_dag <- igraph::make_empty_graph(n = 5, directed = TRUE)
igraph::V(bnm_dag)$name <- paste0("Item0", 1:5)
bnm_dag <- igraph::add_edges(bnm_dag, c(1, 2, 2, 3, 3, 4, 4, 5))
bnm_result <- BNM(J5S10, g = bnm_dag)
p_bnm <- plotGraph_gg(bnm_result, title = "BNM (Items)")[[1]]

# LDLRA
ldlra_g <- igraph::graph_from_data_frame(
  data.frame(from = c("Item01", "Item02", "Item03"),
             to   = c("Item02", "Item03", "Item04")),
  directed = TRUE,
  vertices = data.frame(name = paste0("Item0", 1:5))
)
ldlra_result <- LDLRA(J12S5000, ncls = 3,
                      g_list = list(ldlra_g, ldlra_g, ldlra_g))
p_ldlra <- plotGraph_gg(ldlra_result, title = "LDLRA (Items)")[[1]]

# LDB
ldb_conf <- rep(1:3, length.out = 35)
ldb_g <- igraph::graph_from_data_frame(
  data.frame(from = c("Field01", "Field02"),
             to   = c("Field02", "Field03")),
  directed = TRUE
)
ldb_result <- LDB(J35S515, ncls = 3, conf = ldb_conf,
                  g_list = list(ldb_g, ldb_g, ldb_g))
p_ldb <- plotGraph_gg(ldb_result, title = "LDB (Fields)")[[1]]

# BINET
p_binet <- plotGraph_gg(binet_result, title = "BINET (Class+Field)",
                        show_legend = TRUE)[[1]]

print(gridExtra::grid.arrange(p_bnm, p_ldlra, p_ldb, p_binet, ncol = 2))

cat("\nVisual check complete!\n")
cat("  BNM:   Purple circles (Items)\n")
cat("  LDLRA: Purple circles (Items, per rank)\n")
cat("  LDB:   Green diamonds (Fields, per rank)\n")
cat("  BINET: Blue squares (Class) + Green diamonds (Field)\n")
