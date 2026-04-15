# ============================================================
# test-distractor-plots.R
# Tests for plotDistractor_gg
# ============================================================

test_that("plotDistractor_gg returns list of ggplots from LRA.rated", {
  skip_if_not(has_exametrika)
  skip_if(is.null(fixture_DA_lra))

  plots <- plotDistractor_gg(fixture_DA_lra, items = 1:3)
  expect_type(plots, "list")
  expect_length(plots, 3)
  for (p in plots) {
    expect_s3_class(p, "gg")
  }
})

test_that("plotDistractor_gg returns all items by default", {
  skip_if_not(has_exametrika)
  skip_if(is.null(fixture_DA_lra))

  plots <- plotDistractor_gg(fixture_DA_lra)
  expect_length(plots, fixture_DA_lra$nitems)
})

test_that("plotDistractor_gg respects ranks argument", {
  skip_if_not(has_exametrika)
  skip_if(is.null(fixture_DA_lra))

  plots <- plotDistractor_gg(fixture_DA_lra, items = 1, ranks = c(1, 3, 5))
  p <- plots[[1]]
  expect_s3_class(p, "gg")

  # Check that the plot data has only 3 rank levels
  build <- ggplot2::ggplot_build(p)
  # 3 ranks x maxQ categories
  expect_equal(
    length(unique(build$data[[1]]$x)),
    3
  )
})

test_that("plotDistractor_gg title options work", {
  skip_if_not(has_exametrika)
  skip_if(is.null(fixture_DA_lra))

  # Auto title
  p1 <- plotDistractor_gg(fixture_DA_lra, items = 1, title = TRUE)[[1]]
  expect_true(grepl("CA=Cat", p1$labels$title))

  # No title
  p2 <- plotDistractor_gg(fixture_DA_lra, items = 1, title = FALSE)[[1]]
  expect_null(p2$labels$title)

  # Custom title
  p3 <- plotDistractor_gg(fixture_DA_lra, items = 1, title = "Custom")[[1]]
  expect_true(grepl("Custom", p3$labels$title))
})

test_that("plotDistractor_gg custom colors work", {
  skip_if_not(has_exametrika)
  skip_if(is.null(fixture_DA_lra))

  custom_colors <- c("red", "blue", "green", "orange")
  plots <- plotDistractor_gg(fixture_DA_lra, items = 1, colors = custom_colors)
  expect_s3_class(plots[[1]], "gg")
})

test_that("plotDistractor_gg legend options work", {
  skip_if_not(has_exametrika)
  skip_if(is.null(fixture_DA_lra))

  # Legend hidden
  p1 <- plotDistractor_gg(fixture_DA_lra, items = 1, show_legend = FALSE)[[1]]
  expect_equal(p1$theme$legend.position, "none")

  # Legend at bottom
  p2 <- plotDistractor_gg(fixture_DA_lra,
    items = 1,
    legend_position = "bottom"
  )[[1]]
  expect_equal(p2$theme$legend.position, "bottom")
})

test_that("plotDistractor_gg rejects invalid input", {
  expect_error(
    plotDistractor_gg(list(a = 1)),
    "Invalid input"
  )
})

test_that("plotDistractor_gg works with ratedBiclustering DA", {
  skip_if_not(has_exametrika)
  skip_if(is.null(fixture_DA_biclust))

  plots <- plotDistractor_gg(fixture_DA_biclust, items = 1:3)
  expect_type(plots, "list")
  expect_length(plots, 3)
  for (p in plots) {
    expect_s3_class(p, "gg")
  }
})

test_that("plotDistractor_gg names match item labels", {
  skip_if_not(has_exametrika)
  skip_if(is.null(fixture_DA_lra))

  plots <- plotDistractor_gg(fixture_DA_lra, items = c(1, 5, 10))
  expect_equal(
    names(plots),
    fixture_DA_lra$ItemLabel[c(1, 5, 10)]
  )
})
