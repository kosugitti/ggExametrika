# ============================================================
# Test script for GRM IIC and TIC functions
# 2026-02-17
# ============================================================

# Setup: Load packages
library(exametrika)
devtools::load_all()  # Load ggExametrika from source

# ============================================================
# Prepare test data
# ============================================================
cat("\n=== Loading GRM test data ===\n")
data(J5S1000)
result_grm <- GRM(J5S1000)
cat("GRM model fitted with", nrow(result_grm$params), "items\n")

cat("\n=== Loading IRT test data ===\n")
data(J15S500)
result_irt <- IRT(J15S500, model = 2)
cat("IRT model fitted with", nrow(result_irt$params), "items\n")

# ============================================================
# Test 1: GRM IIC - Single item
# ============================================================
cat("\n\n========================================")
cat("\nTest 1: GRM IIC - Single item")
cat("\n========================================\n")
plot1 <- plotIIC_gg(result_grm, items = 1)
print(plot1[[1]])

# ============================================================
# Test 2: GRM IIC - Multiple items
# ============================================================
cat("\n\n========================================")
cat("\nTest 2: GRM IIC - Multiple items (1-3)")
cat("\n========================================\n")
plots2 <- plotIIC_gg(result_grm, items = 1:3)
print(plots2[[1]])
print(plots2[[2]])
print(plots2[[3]])

# ============================================================
# Test 3: GRM IIC - Custom options
# ============================================================
cat("\n\n========================================")
cat("\nTest 3: GRM IIC - Custom options")
cat("\n========================================\n")
plot3 <- plotIIC_gg(
  result_grm,
  items = 1,
  title = "Custom Title: Item 1 Information",
  colors = "red",
  linetype = "dashed"
)
print(plot3[[1]])

# ============================================================
# Test 4: GRM IIC - No title
# ============================================================
cat("\n\n========================================")
cat("\nTest 4: GRM IIC - No title")
cat("\n========================================\n")
plot4 <- plotIIC_gg(result_grm, items = 1, title = FALSE)
print(plot4[[1]])

# ============================================================
# Test 5: GRM TIC
# ============================================================
cat("\n\n========================================")
cat("\nTest 5: GRM TIC - Default")
cat("\n========================================\n")
plot5 <- plotTIC_gg(result_grm)
print(plot5)

# ============================================================
# Test 6: GRM TIC - Custom options
# ============================================================
cat("\n\n========================================")
cat("\nTest 6: GRM TIC - Custom options")
cat("\n========================================\n")
plot6 <- plotTIC_gg(
  result_grm,
  title = "Custom Test Information Curve",
  color = "blue",
  linetype = "dotted"
)
print(plot6)

# ============================================================
# Test 7: IRT IIC (for comparison)
# ============================================================
cat("\n\n========================================")
cat("\nTest 7: IRT IIC - Items 1-3")
cat("\n========================================\n")
plots7 <- plotIIC_gg(result_irt, items = 1:3)
print(plots7[[1]])

# ============================================================
# Test 8: IRT TIC (for comparison)
# ============================================================
cat("\n\n========================================")
cat("\nTest 8: IRT TIC")
cat("\n========================================\n")
plot8 <- plotTIC_gg(result_irt)
print(plot8)

# ============================================================
# Test 9: Grid display using gridExtra
# ============================================================
cat("\n\n========================================")
cat("\nTest 9: Grid display (GRM IIC, items 1-4)")
cat("\n========================================\n")
plots9 <- plotIIC_gg(result_grm, items = 1:4)
gridExtra::grid.arrange(grobs = plots9, ncol = 2)

# ============================================================
# Summary
# ============================================================
cat("\n\n========================================")
cat("\n=== ALL TESTS COMPLETED SUCCESSFULLY ===")
cat("\n========================================\n")
cat("If you see plots without errors, the implementation is working correctly!\n\n")
