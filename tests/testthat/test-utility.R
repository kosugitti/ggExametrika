# ============================================================
# Tests for utility functions
# combinePlots_gg
# ============================================================

test_that("combinePlots_gg arranges multiple ggplots", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_IRT_2PL), "IRT 2PL fixture not available")

  plots <- plotICC_gg(fixture_IRT_2PL, items = 1:6)
  result <- combinePlots_gg(plots, selectPlots = 1:6)
  expect_true(inherits(result, c("gtable", "gTree", "grob", "gDesc")))
})

test_that("combinePlots_gg works with selectPlots subset", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_IRT_2PL), "IRT 2PL fixture not available")

  plots <- plotICC_gg(fixture_IRT_2PL, items = 1:6)
  result <- combinePlots_gg(plots, selectPlots = 1:3)
  expect_true(inherits(result, c("gtable", "gTree", "grob", "gDesc")))
})

test_that("combinePlots_gg works with default selectPlots", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_IRT_2PL), "IRT 2PL fixture not available")

  plots <- plotICC_gg(fixture_IRT_2PL, items = 1:6)
  result <- combinePlots_gg(plots)
  expect_true(inherits(result, c("gtable", "gTree", "grob", "gDesc")))
})
