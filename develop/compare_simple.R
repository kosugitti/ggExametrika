# Comparison test: exametrika vs ggExametrika
library(exametrika)
devtools::load_all()

# Test 1: Multi-valued data (J15S3810)
cat("\n=== Test 1: J15S3810 (Multi-valued data) ===\n")
result1 <- Biclustering(J15S3810, ncls = 3, nfld = 4)

cat("Original exametrika:\n")
plot(result1, type = "Array")

cat("\nggExametrika:\n")
plotArray_gg(result1, show_legend = TRUE)


# Test 2: Data with missing values (-1)
cat("\n\n=== Test 2: Data with missing values (-1) ===\n")
set.seed(456)
synthetic_with_missing <- matrix(
  sample(c(-1, 0, 1, 2, 3), 40 * 15,
         replace = TRUE,
         prob = c(0.1, 0.3, 0.3, 0.2, 0.1)),
  nrow = 40, ncol = 15
)
colnames(synthetic_with_missing) <- paste0("Item", 1:15)

cat("Data info:\n")
cat("- Values:", paste(sort(unique(as.vector(synthetic_with_missing))), collapse = ", "), "\n")
cat("- Missing (-1):", sum(synthetic_with_missing == -1), "cells\n\n")

result2 <- Biclustering(synthetic_with_missing, nfld = 3, ncls = 4)

cat("Original exametrika:\n")
plot(result2, type = "Array")

cat("\nggExametrika:\n")
plotArray_gg(result2, show_legend = TRUE)

cat("\n\n=== Verification ===\n")
cat("□ Test 1: Patterns match between original and ggExametrika\n")
cat("□ Test 2: Missing values (-1) shown as 'NA' in ggExametrika legend\n")
cat("□ Test 2: Missing values displayed in BLACK\n")

