test_that("plotArray_gg works with binary Biclustering data", {
  skip_if_not_installed("exametrika")

  # Create binary Biclustering
  result <- exametrika::Biclustering(exametrika::J35S515, nfld = 3, ncls = 4)

  # Test basic plot
  plot <- plotArray_gg(result)
  expect_true(inherits(plot, c("gtable", "gTree", "grob", "gDesc")))

  # Test with only Original
  plot_orig <- plotArray_gg(result, Clustered = FALSE)
  expect_true(inherits(plot_orig, "list"))
  expect_length(plot_orig, 1)
  expect_s3_class(plot_orig[[1]], "gg")

  # Test with only Clustered
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

  # Test with Clustered_lines = FALSE
  plot_no_lines <- plotArray_gg(result_5cat, Original = FALSE, Clustered_lines = FALSE)
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

test_that("the default palette for ordered categories is sequential", {
  ramp <- .gg_exametrika_sequential(4)
  expect_length(ramp, 4)
  expect_equal(length(unique(ramp)), 4)

  # lightest first: luminance decreases along the ramp
  lum <- apply(grDevices::col2rgb(ramp), 2, function(x) {
    sum(x * c(0.2126, 0.7152, 0.0722))
  })
  expect_true(all(diff(lum) < 0))

  expect_equal(.gg_exametrika_sequential(1), "#4C9A5A")
})

test_that("one colour per valid category is not shifted by missing data", {
  skip_if_not_installed("exametrika")

  set.seed(456)
  synthetic_data <- matrix(sample(0:3, 30 * 15, replace = TRUE), nrow = 30, ncol = 15)
  synthetic_data[1, 1] <- NA
  colnames(synthetic_data) <- paste0("Item", 1:15)
  result <- exametrika::Biclustering(synthetic_data, nfld = 3, ncls = 4)

  # Four categories and missing data means five slots. Supplying four colours
  # used to consume the first one for missing and wrap the last category
  # around, with only a generic recycling warning to show for it.
  four <- c("#E3F0DC", "#A8D5A2", "#4C9A5A", "#14532D")
  expect_no_warning(plot_four <- plotArray_gg(result, colors = four, show_legend = TRUE))
  expect_true(inherits(plot_four, c("gtable", "gTree", "grob", "gDesc")))

  # Passing every slot explicitly is still honoured.
  five <- c("#FFFFFF", four)
  plot_five <- plotArray_gg(result, colors = five, show_legend = TRUE)
  expect_true(inherits(plot_five, c("gtable", "gTree", "grob", "gDesc")))
})
