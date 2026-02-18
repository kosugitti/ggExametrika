# Test script for LCD, LRD, CMP, RMP with polytomous Biclustering
# Tests both ordinal and nominal Biclustering models

library(exametrika)
devtools::load_all()

cat("==================================================\n")
cat("Test 1: ordinalBiclustering - LCD\n")
cat("==================================================\n\n")

# Load ordinal data
data(J35S500)
cat("Dataset: J35S500 (ordinal polytomous data)\n")
cat("Data range:", min(J35S500$Q, na.rm = TRUE), "to", max(J35S500$Q, na.rm = TRUE), "\n")
cat("Response type:", J35S500$response.type, "\n\n")

# Run ordinal Biclustering
result_ord <- Biclustering(J35S500, ncls = 5, nfld = 5, method = "R", mic = TRUE, maxiter = 200)

cat("Model class:", class(result_ord), "\n")
cat("Has LCD:", !is.null(result_ord$LCD), "\n")
cat("Has LRD:", !is.null(result_ord$LRD), "\n")
cat("Has CMD:", !is.null(result_ord$CMD), "\n")
cat("Has RMD:", !is.null(result_ord$RMD), "\n\n")

# Test plotLCD_gg
cat("Testing plotLCD_gg with ordinalBiclustering...\n")
tryCatch({
  p_lcd <- plotLCD_gg(result_ord)
  print(p_lcd)
  cat("✓ plotLCD_gg works\n")
}, error = function(e) {
  cat("✗ plotLCD_gg failed:", e$message, "\n")
})

cat("\n==================================================\n")
cat("Test 2: ordinalBiclustering - LRD\n")
cat("==================================================\n\n")

# Test plotLRD_gg
cat("Testing plotLRD_gg with ordinalBiclustering...\n")
tryCatch({
  p_lrd <- plotLRD_gg(result_ord)
  print(p_lrd)
  cat("✓ plotLRD_gg works\n")
}, error = function(e) {
  cat("✗ plotLRD_gg failed:", e$message, "\n")
})

cat("\n==================================================\n")
cat("Test 3: ordinalBiclustering - CMP\n")
cat("==================================================\n\n")

# Test plotCMP_gg
cat("Testing plotCMP_gg with ordinalBiclustering...\n")
tryCatch({
  p_cmp <- plotCMP_gg(result_ord)
  print(p_cmp)
  cat("✓ plotCMP_gg works\n")
}, error = function(e) {
  cat("✗ plotCMP_gg failed:", e$message, "\n")
})

cat("\n==================================================\n")
cat("Test 4: ordinalBiclustering - RMP\n")
cat("==================================================\n\n")

# Test plotRMP_gg
cat("Testing plotRMP_gg with ordinalBiclustering...\n")
tryCatch({
  p_rmp <- plotRMP_gg(result_ord)
  print(p_rmp)
  cat("✓ plotRMP_gg works\n")
}, error = function(e) {
  cat("✗ plotRMP_gg failed:", e$message, "\n")
})

cat("\n==================================================\n")
cat("Test 5: nominalBiclustering - LCD\n")
cat("==================================================\n\n")

# Load nominal data
data(J20S600)
cat("Dataset: J20S600 (nominal polytomous data)\n")
cat("Data range:", min(J20S600$Q, na.rm = TRUE), "to", max(J20S600$Q, na.rm = TRUE), "\n")
cat("Response type:", J20S600$response.type, "\n\n")

# Run nominal Biclustering
result_nom <- Biclustering(J20S600, ncls = 5, nfld = 4, maxiter = 200)

cat("Model class:", class(result_nom), "\n")
cat("Has LCD:", !is.null(result_nom$LCD), "\n")
cat("Has LRD:", !is.null(result_nom$LRD), "\n")
cat("Has CMD:", !is.null(result_nom$CMD), "\n\n")

# Test plotLCD_gg
cat("Testing plotLCD_gg with nominalBiclustering...\n")
tryCatch({
  p_lcd_nom <- plotLCD_gg(result_nom)
  print(p_lcd_nom)
  cat("✓ plotLCD_gg works\n")
}, error = function(e) {
  cat("✗ plotLCD_gg failed:", e$message, "\n")
})

cat("\n==================================================\n")
cat("Test 6: nominalBiclustering - LRD\n")
cat("==================================================\n\n")

# Test plotLRD_gg
cat("Testing plotLRD_gg with nominalBiclustering...\n")
tryCatch({
  p_lrd_nom <- plotLRD_gg(result_nom)
  print(p_lrd_nom)
  cat("✓ plotLRD_gg works\n")
}, error = function(e) {
  cat("✗ plotLRD_gg failed:", e$message, "\n")
})

cat("\n==================================================\n")
cat("Test 7: nominalBiclustering - CMP\n")
cat("==================================================\n\n")

# Test plotCMP_gg
cat("Testing plotCMP_gg with nominalBiclustering...\n")
tryCatch({
  p_cmp_nom <- plotCMP_gg(result_nom)
  print(p_cmp_nom)
  cat("✓ plotCMP_gg works\n")
}, error = function(e) {
  cat("✗ plotCMP_gg failed:", e$message, "\n")
})

cat("\n==================================================\n")
cat("Test 8: Binary Biclustering (Backward Compatibility)\n")
cat("==================================================\n\n")

# Load binary data
data(J15S500)
cat("Dataset: J15S500 (binary data)\n\n")

# Run binary Biclustering
result_bin <- Biclustering(J15S500, ncls = 4, nfld = 3, maxiter = 100)

cat("Model class:", class(result_bin), "\n\n")

# Test all plots with binary data
cat("Testing plotLCD_gg with binary Biclustering...\n")
tryCatch({
  p_lcd_bin <- plotLCD_gg(result_bin)
  print(p_lcd_bin)
  cat("✓ plotLCD_gg works\n")
}, error = function(e) {
  cat("✗ plotLCD_gg failed:", e$message, "\n")
})

cat("\nTesting plotLRD_gg with binary Biclustering...\n")
tryCatch({
  p_lrd_bin <- plotLRD_gg(result_bin)
  print(p_lrd_bin)
  cat("✓ plotLRD_gg works\n")
}, error = function(e) {
  cat("✗ plotLRD_gg failed:", e$message, "\n")
})

cat("\nTesting plotCMP_gg with binary Biclustering...\n")
tryCatch({
  p_cmp_bin <- plotCMP_gg(result_bin)
  print(p_cmp_bin)
  cat("✓ plotCMP_gg works\n")
}, error = function(e) {
  cat("✗ plotCMP_gg failed:", e$message, "\n")
})

cat("\nTesting plotRMP_gg with binary Biclustering...\n")
tryCatch({
  p_rmp_bin <- plotRMP_gg(result_bin)
  print(p_rmp_bin)
  cat("✓ plotRMP_gg works\n")
}, error = function(e) {
  cat("✗ plotRMP_gg failed:", e$message, "\n")
})

cat("\n==================================================\n")
cat("Verification Checklist\n")
cat("==================================================\n\n")

cat("□ ordinalBiclustering: plotLCD_gg\n")
cat("□ ordinalBiclustering: plotLRD_gg\n")
cat("□ ordinalBiclustering: plotCMP_gg\n")
cat("□ ordinalBiclustering: plotRMP_gg\n")
cat("□ nominalBiclustering: plotLCD_gg\n")
cat("□ nominalBiclustering: plotLRD_gg\n")
cat("□ nominalBiclustering: plotCMP_gg\n")
cat("□ binary Biclustering: All plots (backward compatibility)\n")

cat("\n==================================================\n")
cat("All tests completed!\n")
cat("==================================================\n")
