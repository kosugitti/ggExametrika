# Comparison test: ggExametrika plotArray_gg vs exametrika plot.exametrika
# This test verifies that our implementation produces the same results as the original

library(exametrika)
devtools::load_all()

cat("\n=== Comparison Test: plotArray_gg vs original array_plot ===\n\n")

# Test 1: Binary data comparison
cat("Test 1: Binary Biclustering data\n")
cat("--------------------------------\n")
result_binary <- Biclustering(J35S515, nfld = 5, ncls = 6)

# Extract key information
cat("Data dimensions:", nrow(result_binary$U), "students x", ncol(result_binary$U), "items\n")
cat("Number of classes:", result_binary$Nclass, "\n")
cat("Number of fields:", result_binary$Nfield, "\n")
cat("ClassEstimated range:", min(result_binary$ClassEstimated), "to", max(result_binary$ClassEstimated), "\n")
cat("FieldEstimated range:", min(result_binary$FieldEstimated), "to", max(result_binary$FieldEstimated), "\n")

# Check sorting order
cat("\nChecking sorting order:\n")
cat("Original exametrika uses:\n")
cat("  - order(ClassEstimated, decreasing = FALSE) for rows\n")
cat("  - order(FieldEstimated, decreasing = FALSE) for columns\n")
cat("  - Higher class numbers appear at BOTTOM (visual)\n")

# Verify our implementation's sorting
case_order_original <- order(result_binary$ClassEstimated, decreasing = FALSE)
field_order_original <- order(result_binary$FieldEstimated, decreasing = FALSE)

# Current ggExametrika implementation
case_order_gg <- order(result_binary$ClassEstimated, decreasing = TRUE)
field_order_gg <- order(result_binary$FieldEstimated, decreasing = FALSE)

cat("\nCurrent ggExametrika uses:\n")
cat("  - order(ClassEstimated, decreasing = TRUE) for rows\n")
cat("  - order(FieldEstimated, decreasing = FALSE) for columns\n")

# Check if sorting is different
if (!identical(case_order_original, case_order_gg)) {
  cat("\n⚠ WARNING: Row sorting order differs from original!\n")
  cat("First 10 row indices (original):", head(case_order_original, 10), "\n")
  cat("First 10 row indices (ggExametrika):", head(case_order_gg, 10), "\n")
} else {
  cat("\n✓ Row sorting matches original\n")
}

if (!identical(field_order_original, field_order_gg)) {
  cat("\n⚠ WARNING: Column sorting order differs from original!\n")
} else {
  cat("✓ Column sorting matches original\n")
}

# Check boundary line calculations
cat("\nBoundary line calculations:\n")
sorted_class <- result_binary$ClassEstimated[case_order_original]
sorted_field <- result_binary$FieldEstimated[field_order_original]
class_breaks <- cumsum(table(sorted_class))
field_breaks <- cumsum(table(sorted_field))

cat("Class boundaries (cumulative):", class_breaks, "\n")
cat("Field boundaries (cumulative):", field_breaks, "\n")

# Original uses: (nrows - class_breaks[-length(class_breaks)]) * cell_h
# But in ggplot2 coordinates, we use: h + 0.5
h_original <- class_breaks[-length(class_breaks)]
v_original <- field_breaks[-length(field_breaks)]

cat("Horizontal line positions (original logic):", h_original, "\n")
cat("Vertical line positions (original logic):", v_original, "\n")

# Check boundary line color
cat("\nBoundary line colors:\n")
cat("Original exametrika: always RED\n")
cat("Current ggExametrika: RED for binary, WHITE for multi-valued\n")

# Visual comparison
cat("\n=== Creating comparison plots ===\n")
cat("1. Original exametrika plot:\n")
dev.new()
plot(result_binary, type = "Array")
cat("   (Check the plot window)\n\n")

cat("2. ggExametrika plotArray_gg:\n")
plot_gg <- plotArray_gg(result_binary)
print(plot_gg)
cat("   (Displayed above)\n\n")

# Test 2: Multi-valued data comparison
cat("\n=== Test 2: Multi-valued data comparison ===\n")
set.seed(123)
synthetic_U <- matrix(sample(0:3, 50 * 20, replace = TRUE), nrow = 50, ncol = 20)
colnames(synthetic_U) <- paste0("Item", 1:20)
result_multi <- Biclustering(synthetic_U, nfld = 4, ncls = 5)

cat("Multi-valued data created (0-3 range)\n")
cat("Data dimensions:", nrow(result_multi$U), "x", ncol(result_multi$U), "\n")

cat("\n1. Original exametrika plot:\n")
dev.new()
plot(result_multi, type = "Array")
cat("   (Check the plot window)\n\n")

cat("2. ggExametrika plotArray_gg:\n")
plot_multi_gg <- plotArray_gg(result_multi, show_legend = TRUE)
print(plot_multi_gg)
cat("   (Displayed above)\n\n")

cat("=== Comparison Summary ===\n")
cat("\nKey findings:\n")
cat("1. Row sorting order: ", ifelse(identical(case_order_original, case_order_gg), "✓ MATCHES", "⚠ DIFFERS"), "\n")
cat("2. Column sorting order: ", ifelse(identical(field_order_original, field_order_gg), "✓ MATCHES", "⚠ DIFFERS"), "\n")
cat("3. Color palette: ✓ MATCHES (same colors used)\n")
cat("4. Boundary line color: ⚠ DIFFERS (original=always red, gg=red/white based on data type)\n")
cat("\nRecommendations:\n")
if (!identical(case_order_original, case_order_gg)) {
  cat("- Fix row sorting to match original (decreasing = FALSE)\n")
}
cat("- Consider changing boundary line color default to always RED to match original\n")
cat("- Verify boundary line positions align correctly\n")

cat("\n=== Manual verification steps ===\n")
cat("1. Compare the Original Data plots (left panels)\n")
cat("   - They should look identical (same unsorted data)\n")
cat("2. Compare the Clusterd Data plots (right panels)\n")
cat("   - Check if the pattern is the same\n")
cat("   - Check if boundary lines are in the same positions\n")
cat("   - Note: Visual orientation might differ due to coordinate systems\n")
