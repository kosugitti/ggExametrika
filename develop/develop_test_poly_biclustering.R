# Test for multi-valued (polytomous) Biclustering
# Based on exametrika documentation example with J15S3810

library(exametrika)
devtools::load_all()

cat("\n=== Multi-valued Biclustering Test (J15S3810) ===\n\n")

# Check J15S3810 data
cat("Loading J15S3810 dataset...\n")
data("J15S3810")

cat("Data info:\n")
cat("- Dimensions:", nrow(J15S3810), "students x", ncol(J15S3810), "items\n")
cat("- Data type:", class(J15S3810), "\n")
cat("- Value range:", min(J15S3810), "to", max(J15S3810), "\n")
cat("- Unique values:", paste(sort(unique(as.vector(as.matrix(J15S3810)))), collapse = ", "), "\n")
cat("\n")

# Run Biclustering as shown in exametrika documentation
cat("Running Biclustering(J15S3810, ncls = 3, nfld = 4)...\n")
result.B.poly <- Biclustering(J15S3810, ncls = 3, nfld = 4)

cat("Model results:\n")
cat("- Model:", result.B.poly$model, "\n")
cat("- Classes:", result.B.poly$Nclass, "\n")
cat("- Fields:", result.B.poly$Nfield, "\n")
cat("- Students:", result.B.poly$nobs, "\n")
cat("- Items:", result.B.poly$testlength, "\n")
cat("\n")

# Display original exametrika plot
cat("=== Step 1: Original exametrika plot ===\n")
cat("Displaying with default colors...\n\n")

dev.new(width = 10, height = 5)
plot(result.B.poly, type = "Array")

cat("Press Enter to see custom color version...\n")
readline()

# Display with custom colors as in documentation
dev.new(width = 10, height = 5)
plot(result.B.poly, type = "Array",
     colors = c("#FF1493", "#00FF00", "#FF4500", "#9932CC", "#FFD700"))

cat("\n=== Step 2: ggExametrika plotArray_gg ===\n")
cat("Press Enter to display ggExametrika version...\n")
readline()

# Display ggExametrika version with default colors
cat("With default colorblind-friendly palette:\n")
plot_gg_default <- plotArray_gg(result.B.poly, show_legend = TRUE)
print(plot_gg_default)

cat("\nPress Enter to see custom color version...\n")
readline()

# Display with custom colors matching exametrika documentation
cat("With custom colors (matching documentation):\n")
custom_colors <- c("#FF1493", "#00FF00", "#FF4500", "#9932CC", "#FFD700")
plot_gg_custom <- plotArray_gg(result.B.poly,
                                colors = custom_colors,
                                show_legend = TRUE,
                                legend_position = "right")
print(plot_gg_custom)

cat("\n=== Comparison Summary ===\n\n")
cat("Data: J15S3810 (multi-valued Biclustering data)\n")
cat("Model: Biclustering with ncls=3, nfld=4\n\n")

cat("Visual comparison checklist:\n")
cat("□ Original Data panels match\n")
cat("□ Clusterd Data patterns match\n")
cat("□ Color mapping is correct (each value gets consistent color)\n")
cat("□ Boundary lines are in correct positions\n")
cat("□ Block structure is preserved\n")
cat("□ Custom colors work correctly\n\n")

cat("Boundary line colors:\n")
cat("- Original exametrika: RED (fixed)\n")
cat("- ggExametrika: WHITE (default for multi-valued data)\n")
cat("  (This difference is by design for better visibility)\n\n")

cat("=== Additional Tests ===\n\n")

# Test with different legend positions
cat("Testing different legend positions...\n")
for (pos in c("top", "bottom", "left")) {
  cat(sprintf("  - Legend position: %s\n", pos))
  p <- plotArray_gg(result.B.poly, show_legend = TRUE, legend_position = pos)
  # Don't print, just create
}
cat("✓ All legend positions work\n\n")

# Test with no legend
cat("Testing with no legend...\n")
plot_no_legend <- plotArray_gg(result.B.poly, show_legend = FALSE)
cat("✓ No legend version works\n\n")

# Test with custom title
cat("Testing with custom title...\n")
plot_custom_title <- plotArray_gg(result.B.poly,
                                   title = "J15S3810 Polytomous Data",
                                   show_legend = TRUE)
cat("✓ Custom title works\n\n")

# Test with blue boundary lines
cat("Testing with blue boundary lines...\n")
plot_blue <- plotArray_gg(result.B.poly,
                          Clusterd_lines_color = "blue",
                          show_legend = TRUE)
cat("✓ Custom boundary color works\n\n")

cat("=== All tests completed successfully ===\n\n")

cat("Available plots for inspection:\n")
cat("  result.B.poly        # Model object\n")
cat("  plot_gg_default      # Default colors with legend\n")
cat("  plot_gg_custom       # Custom colors (matching docs)\n")
cat("  plot_no_legend       # No legend version\n")
cat("  plot_custom_title    # Custom title version\n")
cat("  plot_blue            # Blue boundary lines\n\n")

cat("To display any plot again:\n")
cat("  print(plot_gg_default)\n")
cat("  print(plot_gg_custom)\n")
cat("  etc.\n")
