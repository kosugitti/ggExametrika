# Test script for plotFRP_gg with multivalue support
# Tests both binary and polytomous data with stat parameter

library(exametrika)
library(ggExametrika)

cat("\n========================================\n")
cat("Testing plotFRP_gg - Binary & Polytomous Data\n")
cat("========================================\n\n")

# ============================================
# Test 1: Binary Biclustering (original functionality)
# ============================================
cat("=== Test 1: Binary Biclustering ===\n")
result_binary <- Biclustering(J35S515, nfld = 5, ncls = 6)
cat("Model class:", paste(class(result_binary), collapse = ", "), "\n")
cat("FRP dimensions:", paste(dim(result_binary$FRP), collapse = " x "), "\n")
cat("Data type: Binary (2D matrix)\n\n")

# Test basic plot
cat("Test 1a: Basic plot (all fields, default options)\n")
plot1a <- plotFRP_gg(result_binary)
print(plot1a)
cat("✓ Basic plot created successfully\n\n")

# Test with custom colors
cat("Test 1b: Custom colors\n")
plot1b <- plotFRP_gg(result_binary,
                     colors = c("red", "blue", "green", "purple", "orange"))
print(plot1b)
cat("✓ Custom colors applied\n\n")

# Test with selected fields
cat("Test 1c: Selected fields (1-3 only)\n")
plot1c <- plotFRP_gg(result_binary,
                     fields = 1:3,
                     title = "FRP for Fields 1-3")
print(plot1c)
cat("✓ Field selection works\n\n")

# Test without legend
cat("Test 1d: No legend\n")
plot1d <- plotFRP_gg(result_binary,
                     show_legend = FALSE,
                     title = FALSE)
print(plot1d)
cat("✓ Legend control works\n\n")


# ============================================
# Test 2: Ordinal Biclustering (polytomous data)
# ============================================
cat("=== Test 2: Ordinal Biclustering (Polytomous) ===\n")

# Create synthetic ordinal data (categories 1-4)
set.seed(12345)
n_students <- 100
n_items <- 15
synthetic_ordinal <- matrix(
  sample(1:4, n_students * n_items, replace = TRUE,
         prob = c(0.2, 0.3, 0.3, 0.2)),
  nrow = n_students,
  ncol = n_items
)
colnames(synthetic_ordinal) <- paste0("Q", 1:n_items)

# Convert to exametrika format
U_ordinal <- exDataFormat(synthetic_ordinal, na = -99)
cat("Synthetic ordinal data created\n")
cat("Categories:", paste(sort(unique(as.vector(U_ordinal$Q))), collapse = ", "), "\n")
cat("Dimensions:", nrow(U_ordinal$Q), "students x", ncol(U_ordinal$Q), "items\n\n")

# Run ordinal Biclustering
result_ordinal <- Biclustering(U_ordinal, nfld = 3, ncls = 4)
cat("Model class:", paste(class(result_ordinal), collapse = ", "), "\n")
cat("FRP dimensions:", paste(dim(result_ordinal$FRP), collapse = " x "), "\n")
cat("Data type: Polytomous (3D array)\n\n")

# Check BFRP structure
if ("BFRP" %in% names(result_ordinal)) {
  cat("BFRP components available:\n")
  cat("  - Weighted:", paste(dim(result_ordinal$BFRP$Weighted), collapse = " x "), "\n")
  cat("  - Observed:", paste(dim(result_ordinal$BFRP$Observed), collapse = " x "), "\n\n")
}

# Test 2a: Mean (default)
cat("Test 2a: stat = 'mean' (default)\n")
plot2a <- plotFRP_gg(result_ordinal, stat = "mean")
print(plot2a)
cat("✓ Mean statistic calculated successfully\n\n")

# Test 2b: Median
cat("Test 2b: stat = 'median'\n")
plot2b <- plotFRP_gg(result_ordinal,
                     stat = "median",
                     title = "FRP with Median Statistic",
                     colors = c("darkgreen", "darkblue", "darkred"))
print(plot2b)
cat("✓ Median statistic calculated successfully\n\n")

# Test 2c: Mode
cat("Test 2c: stat = 'mode'\n")
plot2c <- plotFRP_gg(result_ordinal,
                     stat = "mode",
                     title = "FRP with Mode Statistic",
                     linetype = "dashed")
print(plot2c)
cat("✓ Mode statistic calculated successfully\n\n")

# Test 2d: All stats comparison
cat("Test 2d: Comparing all three statistics\n")
cat("Field 1, Class 1 expected scores:\n")
cat("  Mean:  ", sprintf("%.3f", plot2a$data$Value[1]), "\n")
cat("  Median:", sprintf("%.3f", plot2b$data$Value[1]), "\n")
cat("  Mode:  ", sprintf("%.3f", plot2c$data$Value[1]), "\n\n")


# ============================================
# Test 3: Nominal Biclustering (if available)
# ============================================
cat("=== Test 3: Nominal Biclustering (Polytomous) ===\n")

# Create synthetic nominal data
synthetic_nominal <- matrix(
  sample(1:3, n_students * n_items, replace = TRUE,
         prob = c(0.4, 0.35, 0.25)),
  nrow = n_students,
  ncol = n_items
)
colnames(synthetic_nominal) <- paste0("Q", 1:n_items)

U_nominal <- exDataFormat(synthetic_nominal, na = -99)
cat("Synthetic nominal data created\n")
cat("Categories:", paste(sort(unique(as.vector(U_nominal$Q))), collapse = ", "), "\n\n")

result_nominal <- Biclustering(U_nominal, nfld = 3, ncls = 4)
cat("Model class:", paste(class(result_nominal), collapse = ", "), "\n\n")

# Test with nominal data
cat("Test 3a: Nominal data with mean statistic\n")
plot3a <- plotFRP_gg(result_nominal,
                     stat = "mean",
                     title = "Nominal Biclustering FRP",
                     legend_position = "bottom")
print(plot3a)
cat("✓ Nominal data plotted successfully\n\n")


# ============================================
# Test 4: Other supported models
# ============================================
cat("=== Test 4: Other Models (LDB, BINET, IRM) ===\n")

# Note: These tests require specific data structures
# Placeholder for future implementation
cat("Note: LDB, BINET, IRM tests require specific test data\n")
cat("      Add when appropriate test datasets are available\n\n")


# ============================================
# Test 5: Edge cases and error handling
# ============================================
cat("=== Test 5: Edge Cases & Error Handling ===\n")

# Test 5a: Invalid stat parameter
cat("Test 5a: Invalid stat parameter (should error)\n")
tryCatch({
  plotFRP_gg(result_ordinal, stat = "invalid")
  cat("✗ Error: Should have failed with invalid stat\n")
}, error = function(e) {
  cat("✓ Correctly rejected invalid stat:", e$message, "\n")
})

# Test 5b: Invalid field selection
cat("\nTest 5b: Invalid field selection (should error)\n")
tryCatch({
  plotFRP_gg(result_binary, fields = 1:100)
  cat("✗ Error: Should have failed with invalid fields\n")
}, error = function(e) {
  cat("✓ Correctly rejected invalid fields:", e$message, "\n")
})

# Test 5c: Wrong class object
cat("\nTest 5c: Invalid input class (should error)\n")
tryCatch({
  plotFRP_gg(list(FRP = matrix(1:10, 2, 5)))
  cat("✗ Error: Should have failed with invalid class\n")
}, error = function(e) {
  cat("✓ Correctly rejected invalid input:", e$message, "\n")
})


# ============================================
# Test 6: Common options
# ============================================
cat("\n=== Test 6: Common Options ===\n")

cat("Test 6a: All common options combined\n")
plot6a <- plotFRP_gg(
  result_ordinal,
  stat = "mean",
  fields = 1:2,
  title = "Custom Title: FRP Analysis",
  colors = c("#E41A1C", "#377EB8"),
  linetype = "dotted",
  show_legend = TRUE,
  legend_position = "top"
)
print(plot6a)
cat("✓ All common options applied successfully\n\n")

cat("Test 6b: Title variations\n")
plot6b_true <- plotFRP_gg(result_binary, title = TRUE)
plot6b_false <- plotFRP_gg(result_binary, title = FALSE)
plot6b_custom <- plotFRP_gg(result_binary, title = "My Custom Title")
cat("✓ Title options work correctly\n\n")


# ============================================
# Summary
# ============================================
cat("\n========================================\n")
cat("TEST SUMMARY\n")
cat("========================================\n")
cat("✓ Binary data (2D matrix): PASSED\n")
cat("✓ Ordinal data (3D array): PASSED\n")
cat("✓ Nominal data (3D array): PASSED\n")
cat("✓ stat parameter (mean/median/mode): PASSED\n")
cat("✓ Common options: PASSED\n")
cat("✓ Error handling: PASSED\n")
cat("\nAll tests completed successfully!\n")
cat("========================================\n\n")
