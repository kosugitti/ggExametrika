# ============================================================
# Tests for IRT-specific plot functions
# plotICC_gg, plotTRF_gg, plotICC_overlay_gg
# ============================================================

# --- plotICC_gg ---

test_that("plotICC_gg returns list of ggplot objects", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_IRT_2PL), "IRT 2PL fixture not available")

  result <- plotICC_gg(fixture_IRT_2PL)
  expect_type(result, "list")
  expect_true(length(result) > 0)
  expect_s3_class(result[[1]], "gg")
})

test_that("plotICC_gg items parameter selects specific items", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_IRT_2PL), "IRT 2PL fixture not available")

  result <- plotICC_gg(fixture_IRT_2PL, items = 1:3)
  expect_type(result, "list")
  expect_length(result, 3)
  for (p in result) expect_s3_class(p, "gg")
})

test_that("plotICC_gg works with 3PL model", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_IRT_3PL), "IRT 3PL fixture not available")

  result <- plotICC_gg(fixture_IRT_3PL, items = 1)
  expect_type(result, "list")
  expect_s3_class(result[[1]], "gg")
})

test_that("plotICC_gg common options work", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_IRT_2PL), "IRT 2PL fixture not available")

  # title options
  expect_s3_class(plotICC_gg(fixture_IRT_2PL, items = 1, title = TRUE)[[1]], "gg")
  expect_s3_class(plotICC_gg(fixture_IRT_2PL, items = 1, title = FALSE)[[1]], "gg")
  expect_s3_class(plotICC_gg(fixture_IRT_2PL, items = 1, title = "Custom Title")[[1]], "gg")

  # colors, linetype
  expect_s3_class(plotICC_gg(fixture_IRT_2PL, items = 1, colors = "red")[[1]], "gg")
  expect_s3_class(plotICC_gg(fixture_IRT_2PL, items = 1, linetype = "dashed")[[1]], "gg")

  # legend
  expect_s3_class(plotICC_gg(fixture_IRT_2PL, items = 1,
    show_legend = TRUE, legend_position = "bottom")[[1]], "gg")
})

test_that("plotICC_gg rejects invalid input", {
  expect_error(plotICC_gg(NULL), "Invalid input")
  expect_error(plotICC_gg(data.frame(x = 1)), "Invalid input")
  expect_error(plotICC_gg(42), "Invalid input")
})

# --- plotTRF_gg ---

test_that("plotTRF_gg returns single ggplot object", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_IRT_2PL), "IRT 2PL fixture not available")

  result <- plotTRF_gg(fixture_IRT_2PL)
  expect_s3_class(result, "gg")
})

test_that("plotTRF_gg common options work", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_IRT_2PL), "IRT 2PL fixture not available")

  expect_s3_class(plotTRF_gg(fixture_IRT_2PL, title = FALSE), "gg")
  expect_s3_class(plotTRF_gg(fixture_IRT_2PL, title = "Custom TRF"), "gg")
  expect_s3_class(plotTRF_gg(fixture_IRT_2PL, colors = "blue", linetype = "dashed"), "gg")
  expect_s3_class(plotTRF_gg(fixture_IRT_2PL, show_legend = TRUE, legend_position = "top"), "gg")
})

test_that("plotTRF_gg rejects invalid input", {
  expect_error(plotTRF_gg(NULL), "Invalid input")
  expect_error(plotTRF_gg(data.frame(x = 1)), "Invalid input")
})

# --- plotICC_overlay_gg ---

test_that("plotICC_overlay_gg returns single ggplot", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_IRT_2PL), "IRT 2PL fixture not available")

  result <- plotICC_overlay_gg(fixture_IRT_2PL)
  expect_s3_class(result, "gg")
})

test_that("plotICC_overlay_gg items selection works", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_IRT_2PL), "IRT 2PL fixture not available")

  result <- plotICC_overlay_gg(fixture_IRT_2PL, items = 1:3)
  expect_s3_class(result, "gg")
})

test_that("plotICC_overlay_gg common options work", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_IRT_2PL), "IRT 2PL fixture not available")

  expect_s3_class(plotICC_overlay_gg(fixture_IRT_2PL, title = FALSE), "gg")
  expect_s3_class(plotICC_overlay_gg(fixture_IRT_2PL, title = "My ICC Overlay"), "gg")
  expect_s3_class(plotICC_overlay_gg(fixture_IRT_2PL, show_legend = FALSE), "gg")
  expect_s3_class(plotICC_overlay_gg(fixture_IRT_2PL, legend_position = "bottom"), "gg")
})

test_that("plotICC_overlay_gg rejects invalid input", {
  expect_error(plotICC_overlay_gg(NULL), "Invalid input")
  expect_error(plotICC_overlay_gg(data.frame(x = 1)), "Invalid input")
})
