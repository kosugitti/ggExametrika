# ============================================================
# Tests for DAG visualization
# plotGraph_gg: BNM, LDLRA, and LDB
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

# ============================================================
# LDLRA tests
# ============================================================

test_that("plotGraph_gg returns list of ggplots for LDLRA", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_LDLRA), "LDLRA fixture not available")

  result <- plotGraph_gg(fixture_LDLRA)
  expect_type(result, "list")
  expect_length(result, fixture_LDLRA$Nclass)
  for (p in result) {
    expect_s3_class(p, "gg")
  }
})

test_that("plotGraph_gg LDLRA: title common option works", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_LDLRA), "LDLRA fixture not available")

  # TRUE: auto title "LDLRA - Rank N"
  plots_auto <- plotGraph_gg(fixture_LDLRA, title = TRUE)
  expect_s3_class(plots_auto[[1]], "gg")

  # FALSE: no title
  plots_none <- plotGraph_gg(fixture_LDLRA, title = FALSE)
  expect_s3_class(plots_none[[1]], "gg")

  # Single string: appended with " - Rank N"
  plots_single <- plotGraph_gg(fixture_LDLRA, title = "Custom")
  expect_s3_class(plots_single[[1]], "gg")

  # Character vector: each rank gets own title
  n <- fixture_LDLRA$Nclass
  titles <- paste0("Rank-", seq_len(n))
  plots_vec <- plotGraph_gg(fixture_LDLRA, title = titles)
  expect_length(plots_vec, n)
  expect_s3_class(plots_vec[[1]], "gg")
})

test_that("plotGraph_gg LDLRA: colors common option works", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_LDLRA), "LDLRA fixture not available")

  # NULL: default palette
  expect_s3_class(plotGraph_gg(fixture_LDLRA, colors = NULL)[[1]], "gg")

  # Custom color
  expect_s3_class(plotGraph_gg(fixture_LDLRA, colors = "#2196F3")[[1]], "gg")
})

test_that("plotGraph_gg LDLRA: show_legend and legend_position work", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_LDLRA), "LDLRA fixture not available")

  expect_s3_class(plotGraph_gg(fixture_LDLRA, show_legend = TRUE)[[1]], "gg")
  expect_s3_class(plotGraph_gg(fixture_LDLRA, show_legend = FALSE)[[1]], "gg")
  expect_s3_class(
    plotGraph_gg(fixture_LDLRA, show_legend = TRUE, legend_position = "bottom")[[1]],
    "gg"
  )
})

test_that("plotGraph_gg LDLRA: direction parameter works", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_LDLRA), "LDLRA fixture not available")

  for (dir in c("BT", "TB", "LR", "RL")) {
    result <- plotGraph_gg(fixture_LDLRA, direction = dir)
    expect_true(inherits(result[[1]], "gg"), label = paste("direction =", dir))
  }
})

test_that("plotGraph_gg LDLRA: node appearance parameters work", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_LDLRA), "LDLRA fixture not available")

  expect_s3_class(
    plotGraph_gg(fixture_LDLRA, node_size = 15, label_size = 5, arrow_size = 4)[[1]],
    "gg"
  )
})

# ============================================================
# LDB tests
# ============================================================

test_that("plotGraph_gg returns list of ggplots for LDB", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_LDB), "LDB fixture not available")

  n_ranks <- if (!is.null(fixture_LDB$Nrank)) fixture_LDB$Nrank else fixture_LDB$Nclass
  result <- plotGraph_gg(fixture_LDB)
  expect_type(result, "list")
  expect_length(result, n_ranks)
  for (p in result) {
    expect_s3_class(p, "gg")
  }
})

test_that("plotGraph_gg LDB: title common option works", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_LDB), "LDB fixture not available")

  expect_s3_class(plotGraph_gg(fixture_LDB, title = TRUE)[[1]], "gg")
  expect_s3_class(plotGraph_gg(fixture_LDB, title = FALSE)[[1]], "gg")
  expect_s3_class(plotGraph_gg(fixture_LDB, title = "Custom LDB")[[1]], "gg")
})

test_that("plotGraph_gg LDB: colors common option works", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_LDB), "LDB fixture not available")

  expect_s3_class(plotGraph_gg(fixture_LDB, colors = NULL)[[1]], "gg")
  expect_s3_class(plotGraph_gg(fixture_LDB, colors = "#FF5722")[[1]], "gg")
})

test_that("plotGraph_gg LDB: show_legend and legend_position work", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_LDB), "LDB fixture not available")

  expect_s3_class(plotGraph_gg(fixture_LDB, show_legend = TRUE)[[1]], "gg")
  expect_s3_class(plotGraph_gg(fixture_LDB, show_legend = FALSE)[[1]], "gg")
  expect_s3_class(
    plotGraph_gg(fixture_LDB, show_legend = TRUE, legend_position = "bottom")[[1]],
    "gg"
  )
})

test_that("plotGraph_gg LDB: direction parameter works", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_LDB), "LDB fixture not available")

  for (dir in c("BT", "TB", "LR", "RL")) {
    result <- plotGraph_gg(fixture_LDB, direction = dir)
    expect_true(inherits(result[[1]], "gg"), label = paste("direction =", dir))
  }
})

test_that("plotGraph_gg LDB: node appearance parameters work", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_LDB), "LDB fixture not available")

  expect_s3_class(
    plotGraph_gg(fixture_LDB, node_size = 15, label_size = 5, arrow_size = 4)[[1]],
    "gg"
  )
})

test_that("plotGraph_gg LDB: Field nodes use diamond shape", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_LDB), "LDB fixture not available")

  result <- plotGraph_gg(fixture_LDB)
  p <- result[[1]]
  # Verify the plot contains shape scale with diamond (23) for Field
  build <- ggplot2::ggplot_build(p)
  point_data <- build$data[[2]]  # geom_node_point is the 2nd layer
  # Shape 23 = diamond
  expect_true(all(point_data$shape == 23))
})
