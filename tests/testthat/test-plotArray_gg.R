test_that("plotArray_gg works with binary Biclustering data", {
  skip_if_not_installed("exametrika")

  # Create binary Biclustering
  result <- exametrika::Biclustering(exametrika::J35S515, nfld = 3, ncls = 4)

  # Test basic plot
  plot <- plotArray_gg(result)
  expect_true(inherits(plot, c("gtable", "gTree", "grob", "gDesc")))

  # Test with only Original
  plot_orig <- plotArray_gg(result, Clusterd = FALSE)
  expect_true(inherits(plot_orig, "list"))
  expect_length(plot_orig, 1)
  expect_s3_class(plot_orig[[1]], "gg")

  # Test with only Clusterd
  plot_clust <- plotArray_gg(result, Original = FALSE)
  expect_true(inherits(plot_clust, "list"))
  expect_length(plot_clust, 1)
  expect_s3_class(plot_clust[[1]], "gg")
})

test_that("plotArray_gg works with multi-valued data", {
  skip_if_not_installed("exametrika")

  # Create synthetic multi-valued data
  set.seed(123)
  synthetic_data <- matrix(sample(0:3, 30 * 15, replace = TRUE), nrow = 30, ncol = 15)
  colnames(synthetic_data) <- paste0("Item", 1:15)

  # Run Biclustering
  result <- exametrika::Biclustering(synthetic_data, nfld = 3, ncls = 4)

  # Test plot with multi-valued data
  plot <- plotArray_gg(result)
  expect_true(inherits(plot, c("gtable", "gTree", "grob", "gDesc")))

  # Test with legend
  plot_legend <- plotArray_gg(result, show_legend = TRUE)
  expect_true(inherits(plot_legend, c("gtable", "gTree", "grob", "gDesc")))

  # Test with custom colors
  custom_colors <- c("#FFFFFF", "#FFD700", "#FF6347", "#4169E1")
  plot_custom <- plotArray_gg(result, colors = custom_colors, show_legend = TRUE)
  expect_true(inherits(plot_custom, c("gtable", "gTree", "grob", "gDesc")))
})

test_that("plotArray_gg works with Ranklustering", {
  skip_if_not_installed("exametrika")

  # Create synthetic data
  set.seed(456)
  synthetic_data <- matrix(sample(0:2, 25 * 12, replace = TRUE), nrow = 25, ncol = 12)
  colnames(synthetic_data) <- paste0("Item", 1:12)

  # Run Ranklustering
  result <- exametrika::Biclustering(synthetic_data, nfld = 3, ncls = 4, method = "R")

  # Test plot
  plot <- plotArray_gg(result)
  expect_true(inherits(plot, c("gtable", "gTree", "grob", "gDesc")))
})

test_that("plotArray_gg title options work correctly", {
  skip_if_not_installed("exametrika")

  set.seed(123)
  synthetic_data <- matrix(sample(0:1, 20 * 10, replace = TRUE), nrow = 20, ncol = 10)
  colnames(synthetic_data) <- paste0("Item", 1:10)
  result <- exametrika::Biclustering(synthetic_data, nfld = 2, ncls = 3)

  # Test with TRUE (default)
  plot_true <- plotArray_gg(result, Original = FALSE, title = TRUE)
  expect_s3_class(plot_true[[1]], "gg")

  # Test with FALSE (no title)
  plot_false <- plotArray_gg(result, Original = FALSE, title = FALSE)
  expect_s3_class(plot_false[[1]], "gg")

  # Test with custom string
  plot_custom <- plotArray_gg(result, Original = FALSE, title = "Custom Title")
  expect_s3_class(plot_custom[[1]], "gg")
})

test_that("plotArray_gg legend options work correctly", {
  skip_if_not_installed("exametrika")

  set.seed(789)
  synthetic_data <- matrix(sample(0:2, 20 * 10, replace = TRUE), nrow = 20, ncol = 10)
  colnames(synthetic_data) <- paste0("Item", 1:10)
  result <- exametrika::Biclustering(synthetic_data, nfld = 2, ncls = 3)

  # Test legend positions
  for (pos in c("right", "left", "top", "bottom", "none")) {
    plot <- plotArray_gg(result, Original = FALSE, show_legend = TRUE, legend_position = pos)
    expect_s3_class(plot[[1]], "gg")
  }

  # Test show_legend = FALSE
  plot_no_legend <- plotArray_gg(result, Original = FALSE, show_legend = FALSE)
  expect_s3_class(plot_no_legend[[1]], "gg")
})

test_that("plotArray_gg handles edge cases", {
  skip_if_not_installed("exametrika")

  # Test with 5 categories
  set.seed(999)
  synthetic_5cat <- matrix(sample(0:4, 20 * 10, replace = TRUE), nrow = 20, ncol = 10)
  colnames(synthetic_5cat) <- paste0("Item", 1:10)
  result_5cat <- exametrika::Biclustering(synthetic_5cat, nfld = 2, ncls = 3)

  plot_5cat <- plotArray_gg(result_5cat, Original = FALSE, show_legend = TRUE)
  expect_s3_class(plot_5cat[[1]], "gg")

  # Test with Clusterd_lines = FALSE
  plot_no_lines <- plotArray_gg(result_5cat, Original = FALSE, Clusterd_lines = FALSE)
  expect_s3_class(plot_no_lines[[1]], "gg")
})

test_that("plotArray_gg validates input classes", {
  # Test with invalid input
  expect_error(
    plotArray_gg(data.frame(x = 1:5)),
    "Invalid input"
  )

  # Test with NULL
  expect_error(
    plotArray_gg(NULL),
    "Invalid input"
  )
})
