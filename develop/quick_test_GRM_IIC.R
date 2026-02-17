# Quick test for GRM IIC/TIC
# Run this in RStudio after devtools::load_all()

# Required packages
library(exametrika)

# Load development version of ggExametrika
devtools::load_all()

# Load sample data
data(J5S1000)

# Run GRM analysis
cat("Running GRM analysis...\n")
result_grm <- GRM(J5S1000)

cat("\nGRM Parameters:\n")
print(result_grm$params)

# Test plotIIC_gg with GRM
cat("\n=== Testing plotIIC_gg with GRM ===\n")
plots_iic <- plotIIC_gg(result_grm, items = 1:2)
print(plots_iic[[1]])
print(plots_iic[[2]])

# Test plotTIC_gg with GRM
cat("\n=== Testing plotTIC_gg with GRM ===\n")
plot_tic <- plotTIC_gg(result_grm)
print(plot_tic)

cat("\n=== Tests completed! ===\n")
cat("If you see the plots without errors, the implementation is working!\n")
