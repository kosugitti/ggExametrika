# Test script for plotRRV_gg with polytomous (multi-value) support
# Tests both binary and polytomous Biclustering models

library(exametrika)
devtools::load_all()

cat("==================================================\n")
cat("Test 1: Binary Biclustering (Backward Compatibility)\n")
cat("==================================================\n\n")

# Load binary data
data(J15S500)
cat("Dataset: J15S500 (binary data)\n")
cat("Data dimensions:", dim(J15S500$Q), "\n\n")

# Run binary Biclustering
result_bin <- Biclustering(J15S500, ncls = 4, nfld = 3, maxiter = 100)

cat("Model class:", class(result_bin), "\n")
cat("FRP dimensions:", dim(result_bin$FRP), "(2D = binary)\n")
cat("Message:", result_bin$msg, "\n\n")

# Original exametrika plot
cat("Original exametrika RRV plot:\n")
plot(result_bin, type = "RRV")

# ggExametrika plot (should work as before)
cat("\nggExametrika plotRRV_gg() - binary data:\n")
p_bin <- plotRRV_gg(result_bin)
print(p_bin)

# Test with various options
cat("\nBinary with custom title:\n")
p_bin2 <- plotRRV_gg(result_bin, title = "Rank Performance - Binary Data")
print(p_bin2)

cat("\nBinary with no legend:\n")
p_bin3 <- plotRRV_gg(result_bin, show_legend = FALSE)
print(p_bin3)

# stat parameter should be ignored for binary data
cat("\nBinary with stat='median' (should be ignored):\n")
p_bin4 <- plotRRV_gg(result_bin, stat = "median")
print(p_bin4)

cat("\n==================================================\n")
cat("Test 2: Ordinal Biclustering (Polytomous) with stat='mean'\n")
cat("==================================================\n\n")

# Load ordinal data
data(J35S500)
cat("Dataset: J35S500 (polytomous/ordinal data)\n")
cat("Data range:", min(J35S500$Q, na.rm = TRUE), "to", max(J35S500$Q, na.rm = TRUE), "\n")
cat("Response type:", J35S500$response.type, "\n\n")

# Run ordinal Biclustering
result_ord <- Biclustering(J35S500, ncls = 5, nfld = 5, method = "R", mic = TRUE, maxiter = 200)

cat("Model class:", class(result_ord), "\n")
cat("FRP dimensions:", dim(result_ord$FRP), "(3D = polytomous)\n")
cat("Message:", result_ord$msg, "\n")
cat("Number of categories:", dim(result_ord$FRP)[3], "\n\n")

# Original exametrika plot
cat("Original exametrika RRV plot (stat='mean'):\n")
plot(result_ord, type = "RRV", stat = "mean")

# ggExametrika plot with stat='mean' (default)
cat("\nggExametrika plotRRV_gg() - stat='mean':\n")
p_ord_mean <- plotRRV_gg(result_ord)  # Default is mean
print(p_ord_mean)

cat("\n==================================================\n")
cat("Test 3: Ordinal Biclustering with stat='median'\n")
cat("==================================================\n\n")

# Original exametrika plot
cat("Original exametrika RRV plot (stat='median'):\n")
plot(result_ord, type = "RRV", stat = "median")

# ggExametrika plot with stat='median'
cat("\nggExametrika plotRRV_gg() - stat='median':\n")
p_ord_median <- plotRRV_gg(result_ord, stat = "median")
print(p_ord_median)

cat("\n==================================================\n")
cat("Test 4: Ordinal Biclustering with stat='mode'\n")
cat("==================================================\n\n")

# Original exametrika plot
cat("Original exametrika RRV plot (stat='mode'):\n")
plot(result_ord, type = "RRV", stat = "mode")

# ggExametrika plot with stat='mode'
cat("\nggExametrika plotRRV_gg() - stat='mode':\n")
p_ord_mode <- plotRRV_gg(result_ord, stat = "mode")
print(p_ord_mode)

cat("\n==================================================\n")
cat("Test 5: Nominal Biclustering (Polytomous)\n")
cat("==================================================\n\n")

# Load nominal data
data(J20S600)
cat("Dataset: J20S600 (polytomous/nominal data)\n")
cat("Data range:", min(J20S600$Q, na.rm = TRUE), "to", max(J20S600$Q, na.rm = TRUE), "\n")
cat("Response type:", J20S600$response.type, "\n\n")

# Run nominal Biclustering
result_nom <- Biclustering(J20S600, ncls = 5, nfld = 4, maxiter = 200)

cat("Model class:", class(result_nom), "\n")
cat("FRP dimensions:", dim(result_nom$FRP), "(3D = polytomous)\n")
cat("Message:", result_nom$msg, "\n")
cat("Number of categories:", dim(result_nom$FRP)[3], "\n\n")

# Original exametrika plot
cat("Original exametrika RRV plot:\n")
plot(result_nom, type = "RRV", stat = "mean")

# ggExametrika plot
cat("\nggExametrika plotRRV_gg() - nominal biclustering:\n")
p_nom <- plotRRV_gg(result_nom)
print(p_nom)

cat("\n==================================================\n")
cat("Test 6: Custom Styling with Polytomous Data\n")
cat("==================================================\n\n")

# Custom colors
custom_colors <- c("#1b9e77", "#d95f02", "#7570b3", "#e7298a", "#66a61e")

cat("Custom colors and styling:\n")
p_custom <- plotRRV_gg(result_ord,
  title = "Rank Performance Across Fields (Mean Score)",
  colors = custom_colors,
  legend_position = "bottom",
  stat = "mean"
)
print(p_custom)

cat("\n==================================================\n")
cat("Test 7: Error Handling\n")
cat("==================================================\n\n")

# Test with invalid stat parameter
cat("Testing invalid stat parameter...\n")
tryCatch({
  plotRRV_gg(result_ord, stat = "invalid")
}, error = function(e) {
  cat("Expected error:", e$message, "\n")
})

# Test with non-Biclustering object
cat("\nTesting with non-Biclustering object...\n")
tryCatch({
  plotRRV_gg(list(a = 1))
}, error = function(e) {
  cat("Expected error:", e$message, "\n")
})

# Test with IRT model (should fail)
cat("\nTesting with IRT model...\n")
result_irt <- IRT(J15S500, ncls = 2)
tryCatch({
  plotRRV_gg(result_irt)
}, error = function(e) {
  cat("Expected error:", e$message, "\n")
})

cat("\n==================================================\n")
cat("Test 8: Visual Comparison (Save plots)\n")
cat("==================================================\n\n")

# Save comparison: Binary
png("test_rrv_binary_comparison.png", width = 1200, height = 600, res = 100)
par(mfrow = c(1, 2))
plot(result_bin, type = "RRV")
print(plotRRV_gg(result_bin), vp = grid::viewport(x = 0.75, width = 0.5))
dev.off()
cat("Saved: test_rrv_binary_comparison.png\n")

# Save comparison: Ordinal with mean
png("test_rrv_ordinal_mean.png", width = 1200, height = 600, res = 100)
par(mfrow = c(1, 2))
plot(result_ord, type = "RRV", stat = "mean")
print(plotRRV_gg(result_ord, stat = "mean"), vp = grid::viewport(x = 0.75, width = 0.5))
dev.off()
cat("Saved: test_rrv_ordinal_mean.png\n")

# Save comparison: Ordinal with median
png("test_rrv_ordinal_median.png", width = 1200, height = 600, res = 100)
par(mfrow = c(1, 2))
plot(result_ord, type = "RRV", stat = "median")
print(plotRRV_gg(result_ord, stat = "median"), vp = grid::viewport(x = 0.75, width = 0.5))
dev.off()
cat("Saved: test_rrv_ordinal_median.png\n")

# Save comparison: Ordinal with mode
png("test_rrv_ordinal_mode.png", width = 1200, height = 600, res = 100)
par(mfrow = c(1, 2))
plot(result_ord, type = "RRV", stat = "mode")
print(plotRRV_gg(result_ord, stat = "mode"), vp = grid::viewport(x = 0.75, width = 0.5))
dev.off()
cat("Saved: test_rrv_ordinal_mode.png\n")

# Save comparison: Nominal
png("test_rrv_nominal.png", width = 1200, height = 600, res = 100)
par(mfrow = c(1, 2))
plot(result_nom, type = "RRV", stat = "mean")
print(plotRRV_gg(result_nom, stat = "mean"), vp = grid::viewport(x = 0.75, width = 0.5))
dev.off()
cat("Saved: test_rrv_nominal.png\n")

cat("\n==================================================\n")
cat("Verification Checklist\n")
cat("==================================================\n\n")

cat("□ Binary Biclustering: displays correctly (y-axis: 0-1, CRR)\n")
cat("□ Binary Biclustering: backward compatible (no changes to existing behavior)\n")
cat("□ Binary Biclustering: stat parameter ignored (no error)\n")
cat("□ Ordinal Biclustering: displays correctly with stat='mean'\n")
cat("□ Ordinal Biclustering: displays correctly with stat='median'\n")
cat("□ Ordinal Biclustering: displays correctly with stat='mode'\n")
cat("□ Nominal Biclustering: displays correctly\n")
cat("□ Y-axis range: 0-1 for binary, 1-maxQ for polytomous\n")
cat("□ Y-axis label: 'Correct Response Rate' for binary, 'Expected Score (stat)' for polytomous\n")
cat("□ Title updates correctly: includes stat name for polytomous\n")
cat("□ Common options work: title, colors, show_legend, legend_position\n")
cat("□ Error handling: invalid stat, non-Biclustering objects\n")
cat("□ Visual output matches exametrika's original RRV plots\n")

cat("\n==================================================\n")
cat("All tests completed!\n")
cat("==================================================\n")
