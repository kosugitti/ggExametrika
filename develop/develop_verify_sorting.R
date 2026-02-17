# Verification test for sorting order fix
# This test verifies that plotArray_gg now matches exametrika's sorting behavior

library(exametrika)
devtools::load_all()

cat("\n=== Sorting Order Verification Test ===\n\n")

# Create test data
result <- Biclustering(J35S515, nfld = 5, ncls = 6)

cat("Test data:\n")
cat("- Students:", nrow(result$U), "\n")
cat("- Items:", ncol(result$U), "\n")
cat("- Classes:", result$Nclass, "\n")
cat("- Fields:", result$Nfield, "\n\n")

# Verify sorting order matches exametrika
cat("Sorting verification:\n")
case_order_original <- order(result$ClassEstimated, decreasing = FALSE)
field_order_original <- order(result$FieldEstimated, decreasing = FALSE)

cat("✓ Using order(ClassEstimated, decreasing = FALSE)\n")
cat("✓ Using order(FieldEstimated, decreasing = FALSE)\n\n")

# Check sorted data structure
sorted_class <- result$ClassEstimated[case_order_original]
sorted_field <- result$FieldEstimated[field_order_original]

cat("Sorted class structure:\n")
print(table(sorted_class))
cat("\n")

cat("Sorted field structure:\n")
print(table(sorted_field))
cat("\n")

# Calculate boundary positions
class_breaks <- cumsum(table(sorted_class))
field_breaks <- cumsum(table(sorted_field))

cat("Boundary positions:\n")
cat("- Class boundaries (cumulative):", class_breaks, "\n")
cat("- Field boundaries (cumulative):", field_breaks, "\n\n")

# Create plots for visual comparison
cat("=== Creating plots for comparison ===\n\n")

cat("1. Original exametrika plot:\n")
cat("   Run: plot(result, type = 'Array')\n\n")

cat("2. ggExametrika plotArray_gg:\n")
plot_gg <- plotArray_gg(result)
print(plot_gg)
cat("\n")

cat("=== Visual inspection checklist ===\n")
cat("Compare the two plots and verify:\n")
cat("□ Original Data panels look identical\n")
cat("□ Clusterd Data panels show the same pattern\n")
cat("□ High class numbers (high ability) appear at BOTTOM\n")
cat("□ Low class numbers (low ability) appear at TOP\n")
cat("□ Boundary lines align at the same positions\n")
cat("□ Overall block diagonal structure matches\n\n")

# Test with multi-valued data
cat("=== Testing with multi-valued data ===\n")
set.seed(123)
synthetic_U <- matrix(sample(0:3, 50 * 20, replace = TRUE), nrow = 50, ncol = 20)
colnames(synthetic_U) <- paste0("Item", 1:20)
result_multi <- Biclustering(synthetic_U, nfld = 4, ncls = 5)

cat("Multi-valued test data created\n")
plot_multi <- plotArray_gg(result_multi, show_legend = TRUE)
print(plot_multi)

cat("\n=== Test completed ===\n")
cat("If the visual patterns match, the sorting fix is correct.\n")

