# ============================================================
# Tests for plotGridSearch_gg
# ============================================================

test_that("plotGridSearch_gg returns ggplot for an LCA grid search", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_GS_LCA), "GridSearch LCA fixture not available")

  p <- plotGridSearch_gg(fixture_GS_LCA)
  expect_s3_class(p, "gg")
  # one point per converged setting, the optimum among them
  d <- ggplot2::layer_data(p, 2)
  expect_equal(nrow(d), sum(!is.na(fixture_GS_LCA$index_vec)))
  expect_equal(p$labels$x, "Number of classes")
  expect_equal(p$labels$y, "BIC")
})

test_that("plotGridSearch_gg returns ggplot for a Biclustering grid search", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_GS_Bicl), "GridSearch Biclustering fixture not available")

  p <- plotGridSearch_gg(fixture_GS_Bicl)
  expect_s3_class(p, "gg")
  d <- ggplot2::layer_data(p, 2)
  expect_equal(nrow(d), sum(!is.na(fixture_GS_Bicl$index_matrix)))

  p_tile <- plotGridSearch_gg(fixture_GS_Bicl, style = "tile")
  expect_s3_class(p_tile, "gg")
  expect_equal(nrow(ggplot2::layer_data(p_tile, 1)), length(fixture_GS_Bicl$index_matrix))
  expect_equal(p_tile$labels$y, "Number of fields")
})

test_that("plotGridSearch_gg common options work", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_GS_LCA) || is.null(fixture_GS_Bicl))

  expect_s3_class(plotGridSearch_gg(fixture_GS_LCA, title = FALSE), "gg")
  expect_s3_class(plotGridSearch_gg(fixture_GS_LCA, title = "Custom"), "gg")
  expect_s3_class(plotGridSearch_gg(fixture_GS_LCA, colors = "red"), "gg")
  expect_s3_class(plotGridSearch_gg(fixture_GS_LCA, linetype = "dashed"), "gg")
  expect_s3_class(plotGridSearch_gg(fixture_GS_LCA, show_legend = FALSE), "gg")
  expect_s3_class(plotGridSearch_gg(fixture_GS_Bicl, legend_position = "bottom"), "gg")
  expect_s3_class(plotGridSearch_gg(fixture_GS_Bicl, colors = c("red", "blue")), "gg")
  expect_s3_class(plotGridSearch_gg(fixture_GS_Bicl, style = "tile", colors = c("white", "black")), "gg")
})

test_that("plotGridSearch_gg marks empty settings and skips failed ones", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_GS_LCA))

  gs <- fixture_GS_LCA
  gs$index_vec[2] <- NA # a failed setting
  gs$empty_vec <- c(TRUE, FALSE, FALSE) # the first setting left a class empty
  names(gs$empty_vec) <- names(gs$index_vec)
  p <- plotGridSearch_gg(gs)
  d <- ggplot2::layer_data(p, 2)
  expect_equal(nrow(d), 2)
  expect_true(2 %in% d$shape) # the open triangle of the empty setting
})

test_that("plotGridSearch_gg rejects other objects", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_IRT_2PL))
  expect_error(plotGridSearch_gg(fixture_IRT_2PL), "GridSearch")
  expect_error(plotGridSearch_gg(list()), "GridSearch")
})
