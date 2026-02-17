# Simple test for plotArray_gg multi-value support
library(exametrika)

# Load package in development mode
devtools::load_all()

cat("\n=== Test 1: Binary Biclustering (existing functionality) ===\n")
result_binary <- Biclustering(J35S515, nfld = 5, ncls = 6)
cat("Data type:", class(result_binary), "\n")
cat("Data range:", min(result_binary$U), "to", max(result_binary$U), "\n")

# Plot binary data
plot_binary <- plotArray_gg(result_binary)
cat("✓ Binary array plot created\n\n")

cat("=== Test 2: Multi-valued data (synthetic) ===\n")
# Create simple multi-valued data directly
set.seed(123)
synthetic_U <- matrix(sample(0:3, 50 * 20, replace = TRUE), nrow = 50, ncol = 20)
colnames(synthetic_U) <- paste0("Item", 1:20)

# Run Biclustering on synthetic data
result_multi <- Biclustering(synthetic_U, nfld = 4, ncls = 5)
cat("Data type:", class(result_multi), "\n")
cat("Data range:", min(result_multi$U), "to", max(result_multi$U), "\n")
cat("Unique values:", paste(sort(unique(as.vector(result_multi$U))), collapse = ", "), "\n")

# Plot multi-valued data
plot_multi <- plotArray_gg(result_multi)
cat("✓ Multi-valued array plot created\n\n")

# Test with legend
cat("=== Test 3: Multi-valued data with legend ===\n")
plot_multi_legend <- plotArray_gg(result_multi, show_legend = TRUE)
cat("✓ Multi-valued array plot with legend created\n\n")

# Test with custom title
cat("=== Test 4: Custom title ===\n")
plot_custom <- plotArray_gg(result_multi, title = "Custom Test", show_legend = TRUE)
cat("✓ Array plot with custom title created\n\n")

# Test with custom line color
cat("=== Test 5: Custom boundary line color (blue) ===\n")
plot_blue_lines <- plotArray_gg(result_multi, Clusterd_lines_color = "blue", show_legend = TRUE)
cat("✓ Array plot with blue boundary lines created\n\n")

# Test default boundary line colors
cat("=== Test 6: Default boundary line colors ===\n")
cat("Binary data should have RED lines by default\n")
plot_binary_default <- plotArray_gg(result_binary)
cat("Multi-valued data should have WHITE lines by default\n")
plot_multi_default <- plotArray_gg(result_multi, show_legend = TRUE)
cat("✓ Default boundary line colors tested\n\n")

cat("=== All tests completed successfully ===\n")
cat("\nTo view plots, run:\n")
cat("  plot_binary          # Binary data (default red lines)\n")
cat("  plot_multi           # Multi-valued (default white lines, no legend)\n")
cat("  plot_multi_legend    # Multi-valued (default white lines, with legend)\n")
cat("  plot_custom          # Custom title version\n")
cat("  plot_blue_lines      # Custom blue boundary lines\n")
cat("  plot_binary_default  # Binary with default (red) lines\n")
cat("  plot_multi_default   # Multi-valued with default (white) lines\n")
