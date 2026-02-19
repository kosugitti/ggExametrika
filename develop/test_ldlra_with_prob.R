# Test LDLRA with probability display
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

cat("=== Test 1: Without probabilities ===\n")
plots_no_prob <- plotGraph_gg(result, direction = "LR", show_prob = FALSE)
ggsave("develop/ldlra_no_prob.png", plots_no_prob[[1]], width = 10, height = 6, dpi = 150)
cat("Saved: develop/ldlra_no_prob.png\n\n")

cat("=== Test 2: With probabilities ===\n")
plots_with_prob <- plotGraph_gg(result, direction = "LR", show_prob = TRUE)
ggsave("develop/ldlra_with_prob.png", plots_with_prob[[1]], width = 10, height = 6, dpi = 150)
cat("Saved: develop/ldlra_with_prob.png\n\n")

cat("=== Test 3: All ranks with probabilities (patchwork) ===\n")
combined <- plots_with_prob[[1]] / plots_with_prob[[2]] / plots_with_prob[[3]]
ggsave("develop/ldlra_all_ranks_with_prob.png", combined, width = 12, height = 18, dpi = 150)
cat("Saved: develop/ldlra_all_ranks_with_prob.png\n\n")

cat("Success! Probability display working.\n")
