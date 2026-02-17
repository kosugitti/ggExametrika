# Side-by-side comparison with SAME data
# This ensures both original and ggExametrika use identical input

library(exametrika)
devtools::load_all()

cat("\n=== Side-by-Side Comparison: Same Data ===\n\n")

# Test 1: Binary data (J35S515)
cat("Test 1: Binary Biclustering (J35S515)\n")
cat("=====================================\n\n")

result_binary <- Biclustering(J35S515, nfld = 5, ncls = 6)

cat("Data info:\n")
cat("- Data: J35S515\n")
cat("- Students:", nrow(result_binary$U), "\n")
cat("- Items:", ncol(result_binary$U), "\n")
cat("- Data range:", min(result_binary$U), "to", max(result_binary$U), "\n")
cat("- Classes:", result_binary$Nclass, "\n")
cat("- Fields:", result_binary$Nfield, "\n\n")

cat("Step 1: Display ORIGINAL exametrika plot\n")
cat("  (A new plot window will open with base graphics)\n\n")

# Original exametrika plot
dev.new(width = 10, height = 5)
plot(result_binary, type = "Array")

cat("Step 2: Display ggExametrika plot\n")
cat("  (Press Enter to continue...)\n")
readline()

# ggExametrika plot
plot_gg <- plotArray_gg(result_binary)
print(plot_gg)

cat("\n")
cat("VISUAL COMPARISON CHECKLIST (Binary data):\n")
cat("□ Both use the same data (J35S515)\n")
cat("□ Original Data panels look identical\n")
cat("□ Clusterd Data panels show the same pattern\n")
cat("□ Boundary lines are in the same positions\n")
cat("□ Block diagonal structure matches\n")
cat("□ Both use red boundary lines (2値データのデフォルト)\n\n")

cat("Press Enter to continue to Test 2...\n")
readline()

# Test 2: Multi-valued data
cat("\n\nTest 2: Multi-valued Biclustering (0-3 range)\n")
cat("==============================================\n\n")

set.seed(123)
synthetic_U <- matrix(sample(0:3, 50 * 20, replace = TRUE), nrow = 50, ncol = 20)
colnames(synthetic_U) <- paste0("Item", 1:20)

result_multi <- Biclustering(synthetic_U, nfld = 4, ncls = 5)

cat("Data info:\n")
cat("- Data: Synthetic multi-valued\n")
cat("- Students:", nrow(result_multi$U), "\n")
cat("- Items:", ncol(result_multi$U), "\n")
cat("- Data range:", min(result_multi$U), "to", max(result_multi$U), "\n")
cat("- Unique values:", paste(sort(unique(as.vector(result_multi$U))), collapse = ", "), "\n")
cat("- Classes:", result_multi$Nclass, "\n")
cat("- Fields:", result_multi$Nfield, "\n\n")

cat("Step 1: Display ORIGINAL exametrika plot\n")
cat("  (A new plot window will open with base graphics)\n\n")

# Original exametrika plot
dev.new(width = 10, height = 5)
plot(result_multi, type = "Array")

cat("Step 2: Display ggExametrika plot\n")
cat("  (Press Enter to continue...)\n")
readline()

# ggExametrika plot with legend
plot_multi_gg <- plotArray_gg(result_multi, show_legend = TRUE)
print(plot_multi_gg)

cat("\n")
cat("VISUAL COMPARISON CHECKLIST (Multi-valued data):\n")
cat("□ Both use the same synthetic data (0-3 range)\n")
cat("□ Original Data panels look identical\n")
cat("□ Clusterd Data panels show the same pattern\n")
cat("□ Same color palette (Orange=#E69F00, Blue=#0173B2, etc.)\n")
cat("□ Boundary lines are in the same positions\n")
cat("□ Block structure matches\n")
cat("□ Original uses RED lines, ggExametrika uses WHITE lines (by design)\n\n")

cat("=== Comparison Complete ===\n")
cat("\nNOTE: The only intentional difference is boundary line color:\n")
cat("  - Original exametrika: always RED\n")
cat("  - ggExametrika: RED for binary, WHITE for multi-valued\n")
cat("  (This is by design for better visibility)\n\n")
cat("If patterns and positions match, the implementation is correct!\n")

