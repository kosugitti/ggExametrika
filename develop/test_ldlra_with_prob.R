# Test LDLRA DAG visualization with common options
devtools::load_all("../exametrika", quiet = TRUE)
devtools::load_all(".", quiet = TRUE)

library(patchwork)

data(J12S5000)

# Simple DAG
dag <- data.frame(
  from = c("Item01", "Item02", "Item03"),
  to = c("Item02", "Item03", "Item04")
)
g <- igraph::graph_from_data_frame(dag, directed = TRUE)
result <- LDLRA(J12S5000, ncls = 3, g = list(g, g, g))

cat("=== Test 1: Default (auto title, LR direction) ===\n")
plots_default <- plotGraph_gg(result, direction = "LR")
ggsave("develop/ldlra_default.png", plots_default[[1]], width = 10, height = 6, dpi = 150)
cat("Saved: develop/ldlra_default.png\n\n")

cat("=== Test 2: Custom title ===\n")
plots_custom <- plotGraph_gg(result, direction = "LR", title = "My LDLRA")
ggsave("develop/ldlra_custom_title.png", plots_custom[[1]], width = 10, height = 6, dpi = 150)
cat("Saved: develop/ldlra_custom_title.png\n\n")

cat("=== Test 3: No title ===\n")
plots_no_title <- plotGraph_gg(result, direction = "LR", title = FALSE)
ggsave("develop/ldlra_no_title.png", plots_no_title[[1]], width = 10, height = 6, dpi = 150)
cat("Saved: develop/ldlra_no_title.png\n\n")

cat("=== Test 4: Custom color ===\n")
plots_color <- plotGraph_gg(result, direction = "LR", colors = "#2196F3")
ggsave("develop/ldlra_custom_color.png", plots_color[[1]], width = 10, height = 6, dpi = 150)
cat("Saved: develop/ldlra_custom_color.png\n\n")

cat("=== Test 5: All ranks combined (patchwork) ===\n")
combined <- plots_default[[1]] / plots_default[[2]] / plots_default[[3]]
ggsave("develop/ldlra_all_ranks.png", combined, width = 12, height = 18, dpi = 150)
cat("Saved: develop/ldlra_all_ranks.png\n\n")

cat("Success! LDLRA visualization with common options working.\n")
