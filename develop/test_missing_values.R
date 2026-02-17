# Test for missing values (-1) in multi-valued data
library(exametrika)
devtools::load_all()

cat("\n=== Test: Missing Values (-1) Handling ===\n\n")

# Create synthetic data with missing values (-1)
set.seed(456)
n_students <- 40
n_items <- 15

# Create data with values 0, 1, 2, 3, and -1 (missing)
synthetic_with_missing <- matrix(
  sample(c(-1, 0, 1, 2, 3), n_students * n_items,
         replace = TRUE,
         prob = c(0.1, 0.3, 0.3, 0.2, 0.1)),  # 10% missing
  nrow = n_students,
  ncol = n_items
)
colnames(synthetic_with_missing) <- paste0("Item", 1:n_items)

cat("Test data created:\n")
cat("- Dimensions:", n_students, "x", n_items, "\n")
cat("- Values:", paste(sort(unique(as.vector(synthetic_with_missing))), collapse = ", "), "\n")
cat("- Missing values (-1):", sum(synthetic_with_missing == -1), "cells\n\n")

# Run Biclustering
result <- Biclustering(synthetic_with_missing, nfld = 3, ncls = 4)

cat("Biclustering completed:\n")
cat("- Classes:", result$Nclass, "\n")
cat("- Fields:", result$Nfield, "\n\n")

# Plot with ggExametrika
cat("Creating plot with legend...\n")
plot_gg <- plotArray_gg(result, show_legend = TRUE, legend_position = "right")
print(plot_gg)

cat("\n=== Verification Checklist ===\n")
cat("□ Legend shows: 0, 1, 2, 3, NA\n")
cat("□ NA is displayed (not -1)\n")
cat("□ Missing values (-1) are shown in BLACK\n")
cat("□ Other values use colorblind-friendly palette\n")
cat("□ Boundary lines are WHITE (multi-valued data default)\n")
