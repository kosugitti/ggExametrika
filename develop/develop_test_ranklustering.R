# Test for Ranklustering (ordinal Biclustering) with plotArray_gg
library(exametrika)

# Load package in development mode
devtools::load_all()

cat("\n=== Test 1: Ranklustering with binary data ===\n")
result_rank_binary <- Biclustering(J35S515, nfld = 5, ncls = 6, method = "R")
cat("Model:", result_rank_binary$model, "\n")
cat("Class type:", class(result_rank_binary), "\n")
cat("Data range:", min(result_rank_binary$U), "to", max(result_rank_binary$U), "\n")

# Plot binary Ranklustering
plot_rank_binary <- plotArray_gg(result_rank_binary)
cat("✓ Binary Ranklustering array plot created\n\n")

cat("=== Test 2: Ranklustering with multi-valued data ===\n")
# Create ordinal data (0, 1, 2, 3) with tendency
set.seed(456)
n_students <- 50
n_items <- 20

# Create data with some structure (higher ability -> higher scores)
synthetic_ordinal <- matrix(0, nrow = n_students, ncol = n_items)
for (i in 1:n_students) {
  ability <- (i / n_students) * 3  # ability from 0 to 3
  for (j in 1:n_items) {
    difficulty <- (j / n_items) * 2  # difficulty from 0 to 2
    # Response probability based on ability and difficulty
    score_prob <- plogis(ability - difficulty)
    # Convert to ordinal score (0-3)
    synthetic_ordinal[i, j] <- sample(0:3, 1, prob = c(
      (1 - score_prob)^2,
      2 * (1 - score_prob) * score_prob,
      score_prob^2 * (1 - score_prob/2),
      score_prob^2 * (score_prob/2)
    ))
  }
}
colnames(synthetic_ordinal) <- paste0("Item", 1:n_items)

cat("Synthetic ordinal data created\n")
cat("Unique values:", paste(sort(unique(as.vector(synthetic_ordinal))), collapse = ", "), "\n")
cat("Mean by row:", round(mean(rowMeans(synthetic_ordinal)), 2), "\n")

# Run Ranklustering on ordinal data
result_rank_multi <- Biclustering(synthetic_ordinal, nfld = 4, ncls = 5, method = "Ranklustering")
cat("Model:", result_rank_multi$model, "\n")
cat("Data range:", min(result_rank_multi$U), "to", max(result_rank_multi$U), "\n")

# Plot multi-valued Ranklustering without legend
plot_rank_multi <- plotArray_gg(result_rank_multi)
cat("✓ Multi-valued Ranklustering array plot created\n\n")

cat("=== Test 3: Ranklustering with legend and custom options ===\n")
plot_rank_legend <- plotArray_gg(
  result_rank_multi,
  title = "Ranklustering - Ordinal Data",
  show_legend = TRUE,
  legend_position = "bottom"
)
cat("✓ Ranklustering plot with legend created\n\n")

cat("=== Test 4: Comparison - Biclustering vs Ranklustering ===\n")
result_bi_multi <- Biclustering(synthetic_ordinal, nfld = 4, ncls = 5, method = "B")
cat("Biclustering model:", result_bi_multi$model, "\n")

plot_bi_multi <- plotArray_gg(
  result_bi_multi,
  title = "Biclustering - Ordinal Data",
  show_legend = TRUE
)
cat("✓ Biclustering plot for comparison created\n\n")

cat("=== All Ranklustering tests completed successfully ===\n")
cat("\nAvailable plots:\n")
cat("  plot_rank_binary   # Binary data with Ranklustering\n")
cat("  plot_rank_multi    # Ordinal data with Ranklustering (no legend)\n")
cat("  plot_rank_legend   # Ordinal data with Ranklustering (with legend)\n")
cat("  plot_bi_multi      # Ordinal data with Biclustering (for comparison)\n")
cat("\nTo compare Biclustering and Ranklustering:\n")
cat("  gridExtra::grid.arrange(plot_bi_multi, plot_rank_legend, ncol = 2)\n")

