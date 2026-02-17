# Test script for plotIIC_overlay_gg
library(exametrika)
devtools::load_all()

# Test 1: IRT 2PL model
cat("=== Test 1: IRT 2PL model - Overlay all items ===\n")
result_2pl <- IRT(J15S500, model = 2)

cat("\nOriginal exametrika (overlay = TRUE):\n")
plot(result_2pl, type = "IIC", overlay = TRUE)

cat("\nggExametrika plotIIC_overlay_gg():\n")
p1 <- plotIIC_overlay_gg(result_2pl, show_legend = TRUE)
print(p1)


# Test 2: IRT 3PL model with subset of items
cat("\n\n=== Test 2: IRT 3PL model - First 5 items only ===\n")
result_3pl <- IRT(J15S500, model = 3)

cat("\nOriginal exametrika (items 1-5, overlay = TRUE):\n")
plot(result_3pl, type = "IIC", items = 1:5, overlay = TRUE)

cat("\nggExametrika (items 1-5):\n")
p2 <- plotIIC_overlay_gg(result_3pl, items = 1:5, show_legend = TRUE, legend_position = "bottom")
print(p2)


# Test 3: Custom colors and title
cat("\n\n=== Test 3: Custom colors and title ===\n")
custom_colors <- c("#E69F00", "#56B4E9", "#009E73", "#F0E442", "#CC79A7")
p3 <- plotIIC_overlay_gg(
  result_3pl,
  items = 1:5,
  title = "Item Information Functions (3PL Model)",
  colors = custom_colors,
  show_legend = TRUE,
  legend_position = "topright"
)
print(p3)


# Test 4: No legend
cat("\n\n=== Test 4: Without legend ===\n")
p4 <- plotIIC_overlay_gg(result_2pl, show_legend = FALSE, title = FALSE)
print(p4)


cat("\n\n=== Verification ===\n")
cat("□ All item curves are displayed on a single plot\n")
cat("□ Colors distinguish different items\n")
cat("□ Legend shows item names\n")
cat("□ Y-axis shows information (not probability)\n")
cat("□ Curves match the original exametrika output\n")
