# Test script for plotScoreField_gg
# ScoreField: Expected score heatmap for polytomous Biclustering models

library(exametrika)
devtools::load_all()

# ================================================================
# Test 1: ordinal Biclustering (Ranklustering) with J35S500
# ================================================================
cat("=== Test 1: ordinal Biclustering (J35S500) ===\n")
data(J35S500)

result_ord <- Biclustering(J35S500, ncls = 5, nfld = 5, method = "R", mic = TRUE, maxiter = 200)

cat("Model class:", class(result_ord), "\n")
cat("FRP dimensions:", dim(result_ord$FRP), "\n")
cat("Message:", result_ord$msg, "\n")

# Original exametrika plot
cat("\nOriginal exametrika ScoreField plot:\n")
plot(result_ord, type = "ScoreField")

# ggExametrika plot - basic
cat("\nggExametrika plotScoreField_gg() - basic:\n")
p1 <- plotScoreField_gg(result_ord)
print(p1)

# Custom title
cat("\nWith custom title:\n")
p2 <- plotScoreField_gg(result_ord, title = "Expected Scores by Field and Rank")
print(p2)

# Hide values
cat("\nWithout value labels:\n")
p3 <- plotScoreField_gg(result_ord, show_values = FALSE)
print(p3)

# No title
cat("\nNo title:\n")
p4 <- plotScoreField_gg(result_ord, title = FALSE)
print(p4)

# Custom colors
cat("\nCustom color gradient (blue):\n")
p5 <- plotScoreField_gg(result_ord,
                        colors = c("white", "lightblue", "blue", "darkblue"))
print(p5)

# Legend at bottom
cat("\nLegend at bottom:\n")
p6 <- plotScoreField_gg(result_ord, legend_position = "bottom")
print(p6)

# No legend
cat("\nNo legend:\n")
p7 <- plotScoreField_gg(result_ord, show_legend = FALSE)
print(p7)

# Small text
cat("\nSmaller text:\n")
p8 <- plotScoreField_gg(result_ord, text_size = 2.5)
print(p8)

# ================================================================
# Test 2: nominal Biclustering with J20S600
# ================================================================
cat("\n\n=== Test 2: nominal Biclustering (J20S600) ===\n")
data(J20S600)

result_nom <- Biclustering(J20S600, ncls = 5, nfld = 4, maxiter = 200)

cat("Model class:", class(result_nom), "\n")
cat("FRP dimensions:", dim(result_nom$FRP), "\n")
cat("Message:", result_nom$msg, "\n")

# Original exametrika plot
cat("\nOriginal exametrika ScoreField plot:\n")
plot(result_nom, type = "ScoreField")

# ggExametrika plot
cat("\nggExametrika plotScoreField_gg():\n")
p_nom1 <- plotScoreField_gg(result_nom)
print(p_nom1)

# Custom styling
cat("\nCustom styling:\n")
p_nom2 <- plotScoreField_gg(result_nom,
                            title = "Expected Scores: Nominal Biclustering",
                            colors = c("#FFFFCC", "#FFA500", "#FF4500", "#8B0000"),
                            legend_position = "right",
                            show_values = TRUE,
                            text_size = 4)
print(p_nom2)

# ================================================================
# Test 3: Error handling
# ================================================================
cat("\n\n=== Test 3: Error handling ===\n")

# Test with non-exametrika object
cat("Testing with invalid input...\n")
tryCatch({
  plotScoreField_gg(list(a = 1))
}, error = function(e) {
  cat("Expected error:", e$message, "\n")
})

# Test with binary Biclustering (should fail)
cat("\nTesting with binary Biclustering...\n")
data(J15S500)
result_binary <- Biclustering(J15S500, ncls = 3, nfld = 3)
tryCatch({
  plotScoreField_gg(result_binary)
}, error = function(e) {
  cat("Expected error:", e$message, "\n")
})

# Test with IRT model (should fail)
cat("\nTesting with IRT model...\n")
result_irt <- IRT(J15S500, ncls = 2)
tryCatch({
  plotScoreField_gg(result_irt)
}, error = function(e) {
  cat("Expected error:", e$message, "\n")
})

# ================================================================
# Test 4: Visual comparison (save plots)
# ================================================================
cat("\n\n=== Test 4: Saving comparison plots ===\n")

# Save ordinal biclustering comparison
png("test_scorefield_ordinal.png", width = 1200, height = 600, res = 100)
par(mfrow = c(1, 2))
plot(result_ord, type = "ScoreField")
print(plotScoreField_gg(result_ord), vp = grid::viewport(x = 0.75, width = 0.5))
dev.off()
cat("Saved: test_scorefield_ordinal.png\n")

# Save nominal biclustering comparison
png("test_scorefield_nominal.png", width = 1200, height = 600, res = 100)
par(mfrow = c(1, 2))
plot(result_nom, type = "ScoreField")
print(plotScoreField_gg(result_nom), vp = grid::viewport(x = 0.75, width = 0.5))
dev.off()
cat("Saved: test_scorefield_nominal.png\n")

# ================================================================
# Verification checklist
# ================================================================
cat("\n\n=== Verification Checklist ===\n")
cat("□ ordinal Biclustering displays correctly with 'Rank' labels\n")
cat("□ nominal Biclustering displays correctly with 'Class' labels\n")
cat("□ Expected scores calculated correctly (compare with original)\n")
cat("□ Color gradient shows higher scores as darker/redder\n")
cat("□ Field labels (F1, F2, ...) appear on y-axis\n")
cat("□ Latent variable labels (R1/C1, R2/C2, ...) appear on x-axis\n")
cat("□ Value labels display correctly when show_values = TRUE\n")
cat("□ Common options (title, colors, legend) work correctly\n")
cat("□ Error handling works for invalid inputs\n")
cat("□ Visual output matches exametrika's original plot\n")

cat("\n=== All tests completed ===\n")
