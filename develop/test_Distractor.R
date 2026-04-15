# Test script for plotDistractor_gg
# Distractor Analysis: stacked bar charts of response category proportions by rank/class

library(exametrika)
devtools::load_all()

# ================================================================
# Test 1: LRA.rated (J21S300, 5 ranks)
# ================================================================
cat("=== Test 1: LRA.rated (J21S300, nrank=5) ===\n")

result_lra <- LRA(J21S300, nrank = 5, mic = TRUE)
da_lra <- DistractorAnalysis(result_lra)

cat("Class:", paste(class(da_lra), collapse = ", "), "\n")
cat("Items:", da_lra$nitems, "\n")
cat("Ranks:", da_lra$n_rank, "\n")
cat("MaxQ:", da_lra$maxQ, "\n")
cat("CA:", paste(da_lra$CA, collapse = ", "), "\n\n")

# --- Original exametrika plot ---
cat("--- Original exametrika plot (items 1:6) ---\n")
plot(da_lra, items = 1:6, nc = 3, nr = 2)

readline("Press Enter to continue to ggExametrika plots...")

# --- ggExametrika: basic ---
cat("\n--- ggExametrika: basic (items 1:6) ---\n")
plots_lra <- plotDistractor_gg(da_lra, items = 1:6)
combinePlots_gg(plots_lra, selectPlots = 1:6)

readline("Press Enter to continue...")

# --- ggExametrika: single item ---
cat("\n--- Single item (Item01, CA=Cat1) ---\n")
p_single <- plotDistractor_gg(da_lra, items = 1)
print(p_single[[1]])

readline("Press Enter to continue...")

# --- ggExametrika: selected ranks ---
cat("\n--- Selected ranks (1, 3, 5 only) ---\n")
p_ranks <- plotDistractor_gg(da_lra, items = 1:3, ranks = c(1, 3, 5))
combinePlots_gg(p_ranks, selectPlots = 1:3)

readline("Press Enter to continue...")

# --- Title options ---
cat("\n--- Title = FALSE ---\n")
p_notitle <- plotDistractor_gg(da_lra, items = 1, title = FALSE)
print(p_notitle[[1]])

readline("Press Enter to continue...")

cat("\n--- Custom title ---\n")
p_custom <- plotDistractor_gg(da_lra, items = 1, title = "Distractor Analysis")
print(p_custom[[1]])

readline("Press Enter to continue...")

# --- Custom colors ---
cat("\n--- Custom colors ---\n")
p_colors <- plotDistractor_gg(da_lra, items = 1,
  colors = c("tomato", "steelblue", "gold", "gray50"))
print(p_colors[[1]])

readline("Press Enter to continue...")

# --- Legend options ---
cat("\n--- Legend hidden ---\n")
p_noleg <- plotDistractor_gg(da_lra, items = 1, show_legend = FALSE)
print(p_noleg[[1]])

readline("Press Enter to continue...")

cat("\n--- Legend at bottom ---\n")
p_bottom <- plotDistractor_gg(da_lra, items = 1, legend_position = "bottom")
print(p_bottom[[1]])

readline("Press Enter to continue...")

# --- Items with different correct answers ---
cat("\n--- Items with CA=Cat1, CA=Cat2, CA=Cat3 (Items 1, 8, 15) ---\n")
p_diff_ca <- plotDistractor_gg(da_lra, items = c(1, 8, 15))
combinePlots_gg(p_diff_ca, selectPlots = 1:3)

readline("Press Enter to continue...")

# ================================================================
# Test 2: Biclustering.rated (J21S300, 5 classes, 3 fields)
# ================================================================
cat("\n=== Test 2: Biclustering.rated (J21S300, ncls=5, nfld=3) ===\n")

result_bic <- Biclustering(J21S300, ncls = 5, nfld = 3, method = "R", maxiter = 300)
da_bic <- DistractorAnalysis(result_bic)

cat("Class:", paste(class(da_bic), collapse = ", "), "\n")
cat("msg:", da_bic$msg, "\n")
cat("n_field:", da_bic$n_field, "\n")
cat("FieldEstimated:", paste(da_bic$FieldEstimated, collapse = ", "), "\n\n")

# --- Original exametrika plot ---
cat("--- Original exametrika plot (items 1:6) ---\n")
plot(da_bic, items = 1:6, nc = 3, nr = 2)

readline("Press Enter to continue to ggExametrika plots...")

# --- ggExametrika: basic ---
cat("\n--- ggExametrika: Biclustering DA (items 1:6) ---\n")
plots_bic <- plotDistractor_gg(da_bic, items = 1:6)
combinePlots_gg(plots_bic, selectPlots = 1:6)

readline("Press Enter to continue...")

# --- X-axis label check (should be "Class" not "Rank") ---
cat("\n--- Check x-axis label (should use 'Class') ---\n")
p_cls <- plotDistractor_gg(da_bic, items = 1)
print(p_cls[[1]])

readline("Press Enter to continue...")

# ================================================================
# Test 3: All items at once
# ================================================================
cat("\n=== Test 3: All items from LRA DA ===\n")
plots_all <- plotDistractor_gg(da_lra)
cat("Number of plots:", length(plots_all), "\n")
cat("Plot names:", paste(names(plots_all), collapse = ", "), "\n")

combinePlots_gg(plots_all, selectPlots = 1:12)

cat("\nAll tests complete.\n")
