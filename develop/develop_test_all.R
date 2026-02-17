# Comprehensive test suite for plotArray_gg multi-value support
# Run all tests for binary and multi-valued data
library(exametrika)

# Load package in development mode
cat("Loading ggExametrika in development mode...\n")
devtools::load_all()
cat("✓ Package loaded\n\n")

# ============================================================================
# Test 1: Binary Biclustering (baseline)
# ============================================================================
cat("=" %>% rep(70) %>% paste(collapse = ""), "\n")
cat("Test 1: Binary Biclustering (existing functionality)\n")
cat("=" %>% rep(70) %>% paste(collapse = ""), "\n")

result_binary <- Biclustering(J35S515, nfld = 5, ncls = 6, method = "B")
cat("✓ Binary Biclustering completed\n")
cat("  - Data range:", min(result_binary$U), "to", max(result_binary$U), "\n")
cat("  - Classes:", result_binary$Nclass, ", Fields:", result_binary$Nfield, "\n")

plot_binary <- plotArray_gg(result_binary)
cat("✓ Binary array plot created\n\n")

# ============================================================================
# Test 2: Multi-valued Biclustering
# ============================================================================
cat("=" %>% rep(70) %>% paste(collapse = ""), "\n")
cat("Test 2: Multi-valued Biclustering (new feature)\n")
cat("=" %>% rep(70) %>% paste(collapse = ""), "\n")

set.seed(123)
synthetic_multi <- matrix(sample(0:3, 50 * 20, replace = TRUE), nrow = 50, ncol = 20)
colnames(synthetic_multi) <- paste0("Item", 1:20)

result_multi <- Biclustering(synthetic_multi, nfld = 4, ncls = 5, method = "B")
cat("✓ Multi-valued Biclustering completed\n")
cat("  - Data range:", min(result_multi$U), "to", max(result_multi$U), "\n")
cat("  - Unique values:", paste(sort(unique(as.vector(result_multi$U))), collapse = ", "), "\n")
cat("  - Classes:", result_multi$Nclass, ", Fields:", result_multi$Nfield, "\n")

plot_multi_no_legend <- plotArray_gg(result_multi, show_legend = FALSE)
cat("✓ Multi-valued array plot (no legend) created\n")

plot_multi_legend <- plotArray_gg(result_multi, show_legend = TRUE)
cat("✓ Multi-valued array plot (with legend) created\n\n")

# ============================================================================
# Test 3: Ranklustering (ordinal structure)
# ============================================================================
cat("=" %>% rep(70) %>% paste(collapse = ""), "\n")
cat("Test 3: Ranklustering with multi-valued data\n")
cat("=" %>% rep(70) %>% paste(collapse = ""), "\n")

result_rank <- Biclustering(synthetic_multi, nfld = 4, ncls = 5, method = "R")
cat("✓ Ranklustering completed\n")
cat("  - Model:", result_rank$model, "\n")
cat("  - Data range:", min(result_rank$U), "to", max(result_rank$U), "\n")

plot_rank <- plotArray_gg(result_rank, title = "Ranklustering", show_legend = TRUE)
cat("✓ Ranklustering array plot created\n\n")

# ============================================================================
# Test 4: Custom options
# ============================================================================
cat("=" %>% rep(70) %>% paste(collapse = ""), "\n")
cat("Test 4: Custom plot options\n")
cat("=" %>% rep(70) %>% paste(collapse = ""), "\n")

# Custom colors
custom_colors <- c("#FFFFFF", "#FFD700", "#FF6347", "#4169E1")
plot_custom_colors <- plotArray_gg(
  result_multi,
  colors = custom_colors,
  show_legend = TRUE,
  legend_position = "bottom"
)
cat("✓ Plot with custom colors created\n")

# Custom title
plot_custom_title <- plotArray_gg(
  result_multi,
  title = "My Custom Array Plot",
  show_legend = TRUE
)
cat("✓ Plot with custom title created\n")

# No title, no legend
plot_minimal <- plotArray_gg(
  result_multi,
  title = FALSE,
  show_legend = FALSE
)
cat("✓ Minimal plot (no title, no legend) created\n\n")

# ============================================================================
# Test 5: Edge cases
# ============================================================================
cat("=" %>% rep(70) %>% paste(collapse = ""), "\n")
cat("Test 5: Edge cases\n")
cat("=" %>% rep(70) %>% paste(collapse = ""), "\n")

# 5 categories
set.seed(789)
synthetic_5cat <- matrix(sample(0:4, 40 * 15, replace = TRUE), nrow = 40, ncol = 15)
colnames(synthetic_5cat) <- paste0("Item", 1:15)

result_5cat <- Biclustering(synthetic_5cat, nfld = 3, ncls = 4)
cat("✓ 5-category Biclustering completed\n")
cat("  - Unique values:", paste(sort(unique(as.vector(result_5cat$U))), collapse = ", "), "\n")

plot_5cat <- plotArray_gg(result_5cat, show_legend = TRUE, legend_position = "right")
cat("✓ 5-category array plot created\n\n")

# ============================================================================
# Summary
# ============================================================================
cat("=" %>% rep(70) %>% paste(collapse = ""), "\n")
cat("All tests completed successfully!\n")
cat("=" %>% rep(70) %>% paste(collapse = ""), "\n\n")

cat("Available plots:\n")
cat("  plot_binary           # Binary (0/1) data - Biclustering\n")
cat("  plot_multi_no_legend  # Multi-valued (0-3) - no legend\n")
cat("  plot_multi_legend     # Multi-valued (0-3) - with legend\n")
cat("  plot_rank             # Multi-valued (0-3) - Ranklustering\n")
cat("  plot_custom_colors    # Custom color palette\n")
cat("  plot_custom_title     # Custom title\n")
cat("  plot_minimal          # No title, no legend\n")
cat("  plot_5cat             # 5 categories (0-4)\n")
cat("\nTo view a plot, type its name (e.g., plot_multi_legend)\n")
cat("\nTo compare plots side by side:\n")
cat("  gridExtra::grid.arrange(plot_binary, plot_multi_legend, ncol = 2)\n")
