# ============================================================
# Tests for IIC and TIC plot functions (IRT + GRM)
# plotIIC_gg, plotTIC_gg, plotIIC_overlay_gg
# ============================================================

# --- plotIIC_gg (IRT) ---

test_that("plotIIC_gg returns list of ggplots for IRT", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_IRT_2PL), "IRT 2PL fixture not available")

  result <- plotIIC_gg(fixture_IRT_2PL)
  expect_type(result, "list")
  expect_true(length(result) > 0)
  expect_s3_class(result[[1]], "gg")
})

test_that("plotIIC_gg items parameter works for IRT", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_IRT_2PL), "IRT 2PL fixture not available")

  result <- plotIIC_gg(fixture_IRT_2PL, items = 1:2)
  expect_length(result, 2)
  for (p in result) expect_s3_class(p, "gg")
})

# --- plotIIC_gg (GRM) ---

test_that("plotIIC_gg returns list of ggplots for GRM", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_GRM), "GRM fixture not available")

  result <- plotIIC_gg(fixture_GRM)
  expect_type(result, "list")
  expect_true(length(result) > 0)
  expect_s3_class(result[[1]], "gg")
})

test_that("plotIIC_gg items parameter works for GRM", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_GRM), "GRM fixture not available")

  result <- plotIIC_gg(fixture_GRM, items = 1:2)
  expect_length(result, 2)
  for (p in result) expect_s3_class(p, "gg")
})

# --- plotIIC_gg common options ---

test_that("plotIIC_gg common options work", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_IRT_2PL), "IRT 2PL fixture not available")

  expect_s3_class(plotIIC_gg(fixture_IRT_2PL, items = 1, title = FALSE)[[1]], "gg")
  expect_s3_class(plotIIC_gg(fixture_IRT_2PL, items = 1, title = "Custom IIC")[[1]], "gg")
  expect_s3_class(plotIIC_gg(fixture_IRT_2PL, items = 1, colors = "red")[[1]], "gg")
  expect_s3_class(plotIIC_gg(fixture_IRT_2PL, items = 1, linetype = "dashed")[[1]], "gg")
  expect_s3_class(plotIIC_gg(fixture_IRT_2PL, items = 1,
    show_legend = TRUE, legend_position = "bottom")[[1]], "gg")
})

test_that("plotIIC_gg rejects invalid input", {
  expect_error(plotIIC_gg(NULL), "Invalid input")
  expect_error(plotIIC_gg(data.frame(x = 1)), "Invalid input")
})

# --- plotTIC_gg (IRT) ---

test_that("plotTIC_gg returns ggplot for IRT", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_IRT_2PL), "IRT 2PL fixture not available")

  result <- plotTIC_gg(fixture_IRT_2PL)
  expect_s3_class(result, "gg")
})

# --- plotTIC_gg (GRM) ---

test_that("plotTIC_gg returns ggplot for GRM", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_GRM), "GRM fixture not available")

  result <- plotTIC_gg(fixture_GRM)
  expect_s3_class(result, "gg")
})

# --- plotTIC_gg common options ---

test_that("plotTIC_gg common options work", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_IRT_2PL), "IRT 2PL fixture not available")

  expect_s3_class(plotTIC_gg(fixture_IRT_2PL, title = FALSE), "gg")
  expect_s3_class(plotTIC_gg(fixture_IRT_2PL, title = "Custom TIC"), "gg")
  expect_s3_class(plotTIC_gg(fixture_IRT_2PL, colors = "blue"), "gg")
  expect_s3_class(plotTIC_gg(fixture_IRT_2PL, linetype = "dotted"), "gg")
  expect_s3_class(plotTIC_gg(fixture_IRT_2PL,
    show_legend = TRUE, legend_position = "top"), "gg")
})

test_that("plotTIC_gg rejects invalid input", {
  expect_error(plotTIC_gg(NULL), "Invalid input")
  expect_error(plotTIC_gg(data.frame(x = 1)), "Invalid input")
})

# --- plotIIC_overlay_gg (IRT) ---

test_that("plotIIC_overlay_gg returns ggplot for IRT", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_IRT_2PL), "IRT 2PL fixture not available")

  result <- plotIIC_overlay_gg(fixture_IRT_2PL)
  expect_s3_class(result, "gg")
})

test_that("plotIIC_overlay_gg items selection works", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_IRT_2PL), "IRT 2PL fixture not available")

  result <- plotIIC_overlay_gg(fixture_IRT_2PL, items = 1:5)
  expect_s3_class(result, "gg")
})

# --- plotIIC_overlay_gg (GRM) ---

test_that("plotIIC_overlay_gg returns ggplot for GRM", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_GRM), "GRM fixture not available")

  result <- plotIIC_overlay_gg(fixture_GRM)
  expect_s3_class(result, "gg")
})

# --- plotIIC_overlay_gg common options ---

test_that("plotIIC_overlay_gg common options work", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_IRT_2PL), "IRT 2PL fixture not available")

  expect_s3_class(plotIIC_overlay_gg(fixture_IRT_2PL, title = FALSE), "gg")
  expect_s3_class(plotIIC_overlay_gg(fixture_IRT_2PL, title = "Custom IIC Overlay"), "gg")
  expect_s3_class(plotIIC_overlay_gg(fixture_IRT_2PL, show_legend = FALSE), "gg")
  expect_s3_class(plotIIC_overlay_gg(fixture_IRT_2PL, legend_position = "bottom"), "gg")
})

test_that("plotIIC_overlay_gg rejects invalid input", {
  expect_error(plotIIC_overlay_gg(NULL), "Invalid input")
  expect_error(plotIIC_overlay_gg(data.frame(x = 1)), "Invalid input")
})
