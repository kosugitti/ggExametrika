# ============================================================
# Minimal test for GRM IIC/TIC
# Run this first to check if basic functionality works
# ============================================================
1
library(exametrika)
devtools::load_all()

# GRM data
data(J5S1000)
result <- GRM(J5S1000)

# Test 1: Single IIC plot
cat("Test 1: plotIIC_gg(result, items = 1)\n")
p1 <- plotIIC_gg(result, items = 1)
print(p1[[1]])

# Test 2: TIC plot
cat("\nTest 2: plotTIC_gg(result)\n")
p2 <- plotTIC_gg(result)
print(p2)

cat("\n✓ Basic tests completed!\n")
