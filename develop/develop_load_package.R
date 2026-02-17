# Load development version of ggExametrika
# Run this script from the package root directory

# Install/load required packages
if (!require("devtools")) install.packages("devtools")
if (!require("roxygen2")) install.packages("roxygen2")

# Generate documentation
cat("Generating documentation...\n")
devtools::document()

# Load all package functions
cat("Loading package...\n")
devtools::load_all()

cat("\n=== ggExametrika loaded successfully ===\n")
cat("Version:", as.character(packageVersion("ggExametrika")), "\n")
cat("\nYou can now run:\n")
cat("  source('develop_test_array_multivalue.R')\n")

