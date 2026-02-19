# ============================================================
# Tests for GRM-specific plot functions
# plotICRF_gg
# ============================================================

# --- plotICRF_gg ---

test_that("plotICRF_gg returns list of ggplot objects", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_GRM), "GRM fixture not available")

  result <- plotICRF_gg(fixture_GRM)
  expect_type(result, "list")
  expect_true(length(result) > 0)
  expect_s3_class(result[[1]], "gg")
})

test_that("plotICRF_gg items parameter works", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_GRM), "GRM fixture not available")

  result <- plotICRF_gg(fixture_GRM, items = 1:2)
  expect_length(result, 2)
  for (p in result) expect_s3_class(p, "gg")
})

test_that("plotICRF_gg single item works", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_GRM), "GRM fixture not available")

  result <- plotICRF_gg(fixture_GRM, items = 1)
  expect_length(result, 1)
  expect_s3_class(result[[1]], "gg")
})

test_that("plotICRF_gg common options work", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_GRM), "GRM fixture not available")

  expect_s3_class(plotICRF_gg(fixture_GRM, items = 1, title = FALSE)[[1]], "gg")
  expect_s3_class(plotICRF_gg(fixture_GRM, items = 1, title = "Custom ICRF")[[1]], "gg")
  expect_s3_class(plotICRF_gg(fixture_GRM, items = 1, linetype = "dashed")[[1]], "gg")
  expect_s3_class(plotICRF_gg(fixture_GRM, items = 1,
    show_legend = FALSE)[[1]], "gg")
  expect_s3_class(plotICRF_gg(fixture_GRM, items = 1,
    legend_position = "bottom")[[1]], "gg")
})

test_that("plotICRF_gg rejects invalid input", {
  expect_error(plotICRF_gg(NULL))
  expect_error(plotICRF_gg(data.frame(x = 1)))

  # IRT is not GRM
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_IRT_2PL), "IRT 2PL fixture not available")
  expect_error(plotICRF_gg(fixture_IRT_2PL))
})
