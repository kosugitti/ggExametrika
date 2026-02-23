# ============================================================
# Tests for LDPSR visualization (BINET only)
# plotLDPSR_gg
# ============================================================

# ---- Basic functionality ----

test_that("plotLDPSR_gg returns list of ggplots for BINET", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_BINET), "BINET fixture not available")

  result <- plotLDPSR_gg(fixture_BINET)
  expect_type(result, "list")
  expect_true(length(result) > 0)
  expect_s3_class(result[[1]], "gg")
})

test_that("plotLDPSR_gg returns one plot per edge", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_BINET), "BINET fixture not available")

  result <- plotLDPSR_gg(fixture_BINET)
  expect_equal(length(result), length(fixture_BINET$params))
})

test_that("plotLDPSR_gg all elements are ggplot objects", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_BINET), "BINET fixture not available")

  result <- plotLDPSR_gg(fixture_BINET)
  for (i in seq_along(result)) {
    expect_s3_class(result[[i]], "gg")
  }
})

# ---- Common options ----

test_that("plotLDPSR_gg title options work", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_BINET), "BINET fixture not available")

  # title = TRUE (auto-generated)
  result_auto <- plotLDPSR_gg(fixture_BINET, title = TRUE)
  expect_s3_class(result_auto[[1]], "gg")

  # title = FALSE (no title)
  result_none <- plotLDPSR_gg(fixture_BINET, title = FALSE)
  expect_s3_class(result_none[[1]], "gg")

  # title = custom string
  result_custom <- plotLDPSR_gg(fixture_BINET, title = "Custom LDPSR")
  expect_s3_class(result_custom[[1]], "gg")
})

test_that("plotLDPSR_gg colors option works", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_BINET), "BINET fixture not available")

  # Default colors (NULL)
  result_default <- plotLDPSR_gg(fixture_BINET, colors = NULL)
  expect_s3_class(result_default[[1]], "gg")

  # Custom 2 colors
  result_custom <- plotLDPSR_gg(fixture_BINET, colors = c("blue", "red"))
  expect_s3_class(result_custom[[1]], "gg")
})

test_that("plotLDPSR_gg linetype option works", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_BINET), "BINET fixture not available")

  result_dashed <- plotLDPSR_gg(fixture_BINET, linetype = "dashed")
  expect_s3_class(result_dashed[[1]], "gg")

  result_dotted <- plotLDPSR_gg(fixture_BINET, linetype = "dotted")
  expect_s3_class(result_dotted[[1]], "gg")
})

test_that("plotLDPSR_gg show_legend option works", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_BINET), "BINET fixture not available")

  result_legend <- plotLDPSR_gg(fixture_BINET, show_legend = TRUE)
  expect_s3_class(result_legend[[1]], "gg")

  result_no_legend <- plotLDPSR_gg(fixture_BINET, show_legend = FALSE)
  expect_s3_class(result_no_legend[[1]], "gg")
})

test_that("plotLDPSR_gg legend_position option works", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_BINET), "BINET fixture not available")

  for (pos in c("top", "bottom", "left", "right")) {
    result <- plotLDPSR_gg(fixture_BINET, legend_position = pos)
    expect_s3_class(result[[1]], "gg")
  }
})

# ---- Input validation ----

test_that("plotLDPSR_gg rejects invalid input", {
  expect_error(plotLDPSR_gg(NULL))
  expect_error(plotLDPSR_gg(data.frame(x = 1)))
  expect_error(plotLDPSR_gg(42))
  expect_error(plotLDPSR_gg("not a model"))
})

test_that("plotLDPSR_gg rejects non-BINET exametrika models", {
  skip_if_not_installed("exametrika")

  # IRT model should be rejected
  skip_if(is.null(fixture_IRT_2PL), "IRT 2PL fixture not available")
  expect_error(plotLDPSR_gg(fixture_IRT_2PL))

  # LCA model should be rejected
  skip_if(is.null(fixture_LCA), "LCA fixture not available")
  expect_error(plotLDPSR_gg(fixture_LCA))

  # Biclustering model should be rejected
  skip_if(is.null(fixture_Biclust), "Biclustering fixture not available")
  expect_error(plotLDPSR_gg(fixture_Biclust))

  # BNM model should be rejected
  skip_if(is.null(fixture_BNM), "BNM fixture not available")
  expect_error(plotLDPSR_gg(fixture_BNM))
})

# ---- combinePlots_gg integration ----

test_that("plotLDPSR_gg works with combinePlots_gg", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_BINET), "BINET fixture not available")

  plots <- plotLDPSR_gg(fixture_BINET)
  n_show <- min(length(plots), 4)
  result <- combinePlots_gg(plots, selectPlots = 1:n_show)
  expect_true(!is.null(result))
})
