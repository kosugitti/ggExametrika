# ============================================================
# Tests for LRAordinal/LRArated plot functions
# plotScoreFreq_gg, plotScoreRank_gg, plotICRP_gg, plotICBR_gg
# ============================================================

# --- plotScoreFreq_gg ---

test_that("plotScoreFreq_gg returns ggplot for LRAordinal", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_LRAord), "LRAordinal fixture not available")

  result <- plotScoreFreq_gg(fixture_LRAord)
  expect_s3_class(result, "gg")
})

test_that("plotScoreFreq_gg returns ggplot for LRArated", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_LRArated), "LRArated fixture not available")

  result <- plotScoreFreq_gg(fixture_LRArated)
  expect_s3_class(result, "gg")
})

test_that("plotScoreFreq_gg common options work", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_LRAord), "LRAordinal fixture not available")

  expect_s3_class(plotScoreFreq_gg(fixture_LRAord, title = FALSE), "gg")
  expect_s3_class(plotScoreFreq_gg(fixture_LRAord, title = "Custom ScoreFreq"), "gg")
  expect_s3_class(plotScoreFreq_gg(fixture_LRAord, colors = c("red", "blue")), "gg")
  expect_s3_class(plotScoreFreq_gg(fixture_LRAord, linetype = c("solid", "solid")), "gg")
  expect_s3_class(plotScoreFreq_gg(fixture_LRAord,
    show_legend = TRUE, legend_position = "bottom"), "gg")
})

test_that("plotScoreFreq_gg rejects invalid input", {
  expect_error(plotScoreFreq_gg(NULL))
  expect_error(plotScoreFreq_gg(data.frame(x = 1)))

  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_IRT_2PL), "IRT 2PL fixture not available")
  expect_error(plotScoreFreq_gg(fixture_IRT_2PL))
})

# --- plotScoreRank_gg ---

test_that("plotScoreRank_gg returns ggplot for LRAordinal", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_LRAord), "LRAordinal fixture not available")

  result <- plotScoreRank_gg(fixture_LRAord)
  expect_s3_class(result, "gg")
})

test_that("plotScoreRank_gg returns ggplot for LRArated", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_LRArated), "LRArated fixture not available")

  result <- plotScoreRank_gg(fixture_LRArated)
  expect_s3_class(result, "gg")
})

test_that("plotScoreRank_gg common options work", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_LRAord), "LRAordinal fixture not available")

  expect_s3_class(plotScoreRank_gg(fixture_LRAord, title = FALSE), "gg")
  expect_s3_class(plotScoreRank_gg(fixture_LRAord, title = "Custom ScoreRank"), "gg")
  expect_s3_class(plotScoreRank_gg(fixture_LRAord, colors = c("white", "blue")), "gg")
  expect_s3_class(plotScoreRank_gg(fixture_LRAord, show_legend = FALSE), "gg")
  expect_s3_class(plotScoreRank_gg(fixture_LRAord, legend_position = "top"), "gg")
})

test_that("plotScoreRank_gg rejects invalid input", {
  expect_error(plotScoreRank_gg(NULL))
  expect_error(plotScoreRank_gg(data.frame(x = 1)))

  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_IRT_2PL), "IRT 2PL fixture not available")
  expect_error(plotScoreRank_gg(fixture_IRT_2PL))
})

# --- plotICRP_gg ---

test_that("plotICRP_gg returns ggplot for LRAordinal", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_LRAord), "LRAordinal fixture not available")

  result <- plotICRP_gg(fixture_LRAord)
  expect_s3_class(result, "gg")
})

test_that("plotICRP_gg returns ggplot for LRArated", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_LRArated), "LRArated fixture not available")

  result <- plotICRP_gg(fixture_LRArated)
  expect_s3_class(result, "gg")
})

test_that("plotICRP_gg items parameter works", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_LRAord), "LRAordinal fixture not available")

  result <- plotICRP_gg(fixture_LRAord, items = 1:3)
  expect_s3_class(result, "gg")
})

test_that("plotICRP_gg common options work", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_LRAord), "LRAordinal fixture not available")

  expect_s3_class(plotICRP_gg(fixture_LRAord, items = 1:2, title = FALSE), "gg")
  expect_s3_class(plotICRP_gg(fixture_LRAord, items = 1:2, title = "Custom ICRP"), "gg")
  expect_s3_class(plotICRP_gg(fixture_LRAord, items = 1:2, show_legend = FALSE), "gg")
  expect_s3_class(plotICRP_gg(fixture_LRAord, items = 1:2, legend_position = "bottom"), "gg")
})

test_that("plotICRP_gg rejects invalid input", {
  expect_error(plotICRP_gg(NULL))
  expect_error(plotICRP_gg(data.frame(x = 1)))

  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_IRT_2PL), "IRT 2PL fixture not available")
  expect_error(plotICRP_gg(fixture_IRT_2PL))
})

# --- plotICBR_gg ---

test_that("plotICBR_gg returns ggplot for LRAordinal", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_LRAord), "LRAordinal fixture not available")

  result <- plotICBR_gg(fixture_LRAord)
  expect_s3_class(result, "gg")
})

test_that("plotICBR_gg items parameter works", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_LRAord), "LRAordinal fixture not available")

  result <- plotICBR_gg(fixture_LRAord, items = 1:3)
  expect_s3_class(result, "gg")
})

test_that("plotICBR_gg common options work", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_LRAord), "LRAordinal fixture not available")

  expect_s3_class(plotICBR_gg(fixture_LRAord, items = 1:2, title = FALSE), "gg")
  expect_s3_class(plotICBR_gg(fixture_LRAord, items = 1:2, title = "Custom ICBR"), "gg")
  expect_s3_class(plotICBR_gg(fixture_LRAord, items = 1:2, show_legend = FALSE), "gg")
  expect_s3_class(plotICBR_gg(fixture_LRAord, items = 1:2, legend_position = "bottom"), "gg")
})

test_that("plotICBR_gg rejects invalid input", {
  expect_error(plotICBR_gg(NULL))
  expect_error(plotICBR_gg(data.frame(x = 1)))

  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_IRT_2PL), "IRT 2PL fixture not available")
  expect_error(plotICBR_gg(fixture_IRT_2PL))
})
