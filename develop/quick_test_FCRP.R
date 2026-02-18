# Quick test for plotFCRP_gg()
# This script creates small simulated data and tests the function

cat("=== Quick FCRP Test ===\n\n")

# Load ggExametrika
cat("Loading ggExametrika...\n")
devtools::load_all(".")

# Load exametrika
library(exametrika)

cat("\n=== Creating simulated data ===\n")
set.seed(42)

# Small simulated ordinal data (5 categories)
n_students <- 100
n_items <- 15
Q <- matrix(sample(1:5, n_students * n_items, replace = TRUE),
  nrow = n_students, ncol = n_items
)

cat("Running Biclustering (this may take 30 seconds)...\n")
result <- Biclustering(Q, ncls = 3, nfld = 3, method = "R", maxiter = 30)

cat("Converged:", result$converge, "\n")
cat("Model class:", class(result), "\n")
cat("FRP dimensions:", dim(result$FRP), "\n\n")

# Check if FRP has 3+ categories
if (dim(result$FRP)[3] < 3) {
  cat("ERROR: FRP has less than 3 categories\n")
  cat("Creating new data with explicit category structure...\n")

  # Force multiple categories
  Q2 <- matrix(0, nrow = n_students, ncol = n_items)
  for (i in 1:n_students) {
    Q2[i, ] <- sample(1:5, n_items, replace = TRUE,
      prob = c(0.1, 0.2, 0.4, 0.2, 0.1)
    )
  }

  result <- Biclustering(Q2, ncls = 3, nfld = 3, method = "R", maxiter = 30)
  cat("New FRP dimensions:", dim(result$FRP), "\n\n")
}

cat("=== Testing plotFCRP_gg() ===\n\n")

# Test 1: Line style (default)
cat("Test 1: Line style\n")
tryCatch(
  {
    p1 <- plotFCRP_gg(result, style = "line")
    print(p1)
    cat("✓ Line style works\n\n")
  },
  error = function(e) {
    cat("✗ Error:", e$message, "\n\n")
  }
)

# Test 2: Bar style
cat("Test 2: Bar style\n")
tryCatch(
  {
    p2 <- plotFCRP_gg(result, style = "bar")
    print(p2)
    cat("✓ Bar style works\n\n")
  },
  error = function(e) {
    cat("✗ Error:", e$message, "\n\n")
  }
)

# Test 3: Custom options
cat("Test 3: Custom options\n")
tryCatch(
  {
    p3 <- plotFCRP_gg(result,
      style = "line",
      title = "Custom FCRP Title",
      colors = c("#E69F00", "#56B4E9", "#009E73", "#F0E442", "#CC79A7"),
      show_legend = TRUE,
      legend_position = "bottom"
    )
    print(p3)
    cat("✓ Custom options work\n\n")
  },
  error = function(e) {
    cat("✗ Error:", e$message, "\n\n")
  }
)

# Test 4: No legend
cat("Test 4: No legend\n")
tryCatch(
  {
    p4 <- plotFCRP_gg(result,
      style = "bar",
      show_legend = FALSE,
      title = FALSE
    )
    print(p4)
    cat("✓ No legend option works\n\n")
  },
  error = function(e) {
    cat("✗ Error:", e$message, "\n\n")
  }
)

cat("=== Test completed ===\n")
cat("\nIf all tests passed, you can:\n")
cat("1. Run full tests: source('develop/test_FCRP.R')\n")
cat("2. Commit changes\n")
cat("3. Update version and NEWS.md\n")
