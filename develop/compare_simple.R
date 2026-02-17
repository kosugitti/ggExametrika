# Simple comparison: exametrika vs ggExametrika
library(exametrika)
devtools::load_all()

# Multi-valued data (J15S3810)
cat("\n=== J15S3810 (Multi-valued data) ===\n")
result <- Biclustering(J15S3810, ncls = 3, nfld = 4)

# Original exametrika
plot(result, type = "Array")

# ggExametrika
plotArray_gg(result, show_legend = TRUE)
