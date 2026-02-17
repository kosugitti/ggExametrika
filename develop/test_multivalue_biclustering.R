# Test script for multi-value Biclustering with new sample data
library(exametrika)
devtools::load_all()

# ================================================================
# Test 1: ordinal Biclustering (Ranklustering) with J35S500
# Structure: 5cls × 5fld × 5cat (cumulative pattern)
# ================================================================
cat("=== Test 1: ordinal Biclustering with J35S500 ===\n")
data(J35S500)
cat("Data type:", class(J35S500), "\n")
cat("Q matrix dimensions:", dim(J35S500$Q), "\n")
cat("Q data range:", min(J35S500$Q, na.rm = TRUE), "to", max(J35S500$Q, na.rm = TRUE), "\n")
cat("Response type:", J35S500$response.type, "\n")
cat("Categories:", unique(J35S500$categories), "\n")

result_ord <- Biclustering(J35S500, ncls = 5, nfld = 5, method = "R", mic = TRUE, maxiter = 200)

cat("\nModel class:", class(result_ord), "\n")
cat("Convergence:", result_ord$converge, "\n")
cat("FRP dimensions:", dim(result_ord$FRP), "\n")
cat("U matrix range:", min(result_ord$U, na.rm = TRUE), "to", max(result_ord$U, na.rm = TRUE), "\n")

# Original exametrika plot
cat("\nOriginal exametrika Array plot:\n")
plot(result_ord, type = "Array")

# ggExametrika plot
cat("\nggExametrika plotArray_gg():\n")
plot_ord <- plotArray_gg(result_ord)
print("Ordinal Biclustering plot completed")

# Test with legend
plot_ord_legend <- plotArray_gg(result_ord, show_legend = TRUE, legend_position = "bottom")
print("Ordinal Biclustering with legend completed")


# ================================================================
# Test 2: nominal Biclustering with J20S600
# Structure: 5cls × 4fld × 4cat (cyclic pattern)
# ================================================================
cat("\n\n=== Test 2: nominal Biclustering with J20S600 ===\n")
data(J20S600)
cat("Data type:", class(J20S600), "\n")
cat("Q matrix dimensions:", dim(J20S600$Q), "\n")
cat("Q data range:", min(J20S600$Q, na.rm = TRUE), "to", max(J20S600$Q, na.rm = TRUE), "\n")
cat("Response type:", J20S600$response.type, "\n")
cat("Categories:", unique(J20S600$categories), "\n")

result_nom <- Biclustering(J20S600, ncls = 5, nfld = 4, maxiter = 200)

cat("\nModel class:", class(result_nom), "\n")
cat("Convergence:", result_nom$converge, "\n")
cat("FRP dimensions:", dim(result_nom$FRP), "\n")
cat("U matrix range:", min(result_nom$U, na.rm = TRUE), "to", max(result_nom$U, na.rm = TRUE), "\n")

# Original exametrika plot
cat("\nOriginal exametrika Array plot:\n")
plot(result_nom, type = "Array")

# ggExametrika plot
cat("\nggExametrika plotArray_gg():\n")
plot_nom <- plotArray_gg(result_nom)
print("Nominal Biclustering plot completed")

# Test with custom colors
custom_colors <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442")
plot_nom_custom <- plotArray_gg(result_nom, colors = custom_colors, Clusterd_lines_color = "white")
print("Nominal Biclustering with custom colors completed")


# ================================================================
# Verification
# ================================================================
cat("\n\n=== Verification ===\n")
cat("□ ordinal Biclustering (J35S500) - 5 categories displayed correctly\n")
cat("□ nominal Biclustering (J20S600) - 4 categories displayed correctly\n")
cat("□ Colors are distinct and colorblind-friendly\n")
cat("□ Clustering boundaries (red/white lines) are visible\n")
cat("□ Original vs ggExametrika plots match\n")

cat("\n=== All tests completed ===\n")
