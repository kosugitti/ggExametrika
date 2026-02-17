# Test script for multi-value plotArray_gg
library(exametrika)
library(ggExametrika)

# Test 1: Binary data (original functionality)
cat("\n=== Test 1: Binary Biclustering ===\n")
result_binary <- Biclustering(J35S515, nfld = 5, ncls = 6)
print(class(result_binary))
print(paste("Data range:", min(result_binary$U), "to", max(result_binary$U)))

# Test array plot
plot_binary <- plotArray_gg(result_binary)
print("Binary data plotArray_gg completed successfully")

# Test 2: Ordinal data (multi-value)
cat("\n=== Test 2: Ordinal Biclustering ===\n")
# Check if ordinal sample data exists
data_files <- data(package = "exametrika")$results[, "Item"]
cat("Available datasets in exametrika:\n")
print(data_files)

# Try to find ordinal/nominal sample data
if ("J15S500" %in% data_files) {
  data(J15S500, package = "exametrika")
  cat("\nTesting with J15S500 data\n")
  print(str(J15S500))
}

# Test with synthetic ordinal data
cat("\n=== Test 3: Synthetic ordinal data ===\n")
set.seed(123)
# Create synthetic ordinal data (0, 1, 2, 3)
synthetic_data <- matrix(sample(0:3, 50 * 20, replace = TRUE), nrow = 50, ncol = 20)
colnames(synthetic_data) <- paste0("Item", 1:20)

# Convert to exametrika format
U_ordinal <- exDataFormat(synthetic_data, na = -99)
print(paste("Synthetic data categories:", paste(unique(as.vector(U_ordinal$Q)), collapse = ", ")))

# Run ordinal Biclustering
result_ordinal <- Biclustering(U_ordinal, nfld = 4, ncls = 5)
print(class(result_ordinal))
print(paste("Result data range:", min(result_ordinal$U), "to", max(result_ordinal$U)))

# Test array plot with multi-value data
plot_ordinal <- plotArray_gg(result_ordinal)
print("Ordinal data plotArray_gg completed successfully")

# Test with show_legend = TRUE
plot_ordinal_legend <- plotArray_gg(result_ordinal, show_legend = TRUE)
print("Ordinal data with legend completed successfully")

cat("\n=== All tests completed ===\n")
