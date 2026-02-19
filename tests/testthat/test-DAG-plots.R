# ============================================================
# Tests for DAG visualization
# plotGraph_gg (BNM only currently)
# ============================================================

test_that("plotGraph_gg returns list of ggplots for BNM", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_BNM), "BNM fixture not available")

  result <- plotGraph_gg(fixture_BNM)
  expect_type(result, "list")
  expect_true(length(result) > 0)
  expect_s3_class(result[[1]], "gg")
})

test_that("plotGraph_gg common options work", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_BNM), "BNM fixture not available")

  expect_s3_class(plotGraph_gg(fixture_BNM, title = FALSE)[[1]], "gg")
  expect_s3_class(plotGraph_gg(fixture_BNM, title = "Custom DAG")[[1]], "gg")
  expect_s3_class(plotGraph_gg(fixture_BNM, show_legend = TRUE)[[1]], "gg")
  expect_s3_class(plotGraph_gg(fixture_BNM, legend_position = "bottom")[[1]], "gg")
})

test_that("plotGraph_gg layout parameter works", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_BNM), "BNM fixture not available")

  expect_s3_class(plotGraph_gg(fixture_BNM, layout = "sugiyama")[[1]], "gg")
})

test_that("plotGraph_gg node appearance parameters work", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_BNM), "BNM fixture not available")

  expect_s3_class(plotGraph_gg(fixture_BNM,
    node_size = 15, label_size = 5, arrow_size = 4)[[1]], "gg")
})

test_that("plotGraph_gg rejects invalid input", {
  expect_error(plotGraph_gg(NULL))
  expect_error(plotGraph_gg(data.frame(x = 1)))

  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_IRT_2PL), "IRT 2PL fixture not available")
  expect_error(plotGraph_gg(fixture_IRT_2PL))
})
