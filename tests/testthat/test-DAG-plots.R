# ============================================================
# Tests for DAG visualization
# plotGraph_gg: BNM, LDLRA, LDB, and BINET
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
    node_size = 15, label_size = 5, arrow_size = 4
  )[[1]], "gg")
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
  expect_length(result, fixture_LDLRA$n_class)
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
  n <- fixture_LDLRA$n_class
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

  n_ranks <- if (!is.null(fixture_LDB$n_rank)) fixture_LDB$n_rank else fixture_LDB$n_class
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
  point_data <- build$data[[2]] # geom_node_point is the 2nd layer
  # Shape 23 = diamond
  expect_true(all(point_data$shape == 23))
})

# ============================================================
# BINET tests
# ============================================================

test_that("plotGraph_gg returns single-element list for BINET", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_BINET), "BINET fixture not available")

  result <- plotGraph_gg(fixture_BINET)
  expect_type(result, "list")
  expect_length(result, 1)
  expect_s3_class(result[[1]], "gg")
})

test_that("plotGraph_gg BINET: title common option works", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_BINET), "BINET fixture not available")

  expect_s3_class(plotGraph_gg(fixture_BINET, title = TRUE)[[1]], "gg")
  expect_s3_class(plotGraph_gg(fixture_BINET, title = FALSE)[[1]], "gg")
  expect_s3_class(plotGraph_gg(fixture_BINET, title = "Custom BINET")[[1]], "gg")
})

test_that("plotGraph_gg BINET: colors common option works", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_BINET), "BINET fixture not available")

  # Default colors
  expect_s3_class(plotGraph_gg(fixture_BINET, colors = NULL)[[1]], "gg")

  # Custom colors (positional: Class, Field)
  expect_s3_class(
    plotGraph_gg(fixture_BINET, colors = c("#FF0000", "#00FF00"))[[1]], "gg"
  )

  # Named colors
  expect_s3_class(
    plotGraph_gg(fixture_BINET,
      colors = c(Class = "#FF0000", Field = "#00FF00")
    )[[1]], "gg"
  )
})

test_that("plotGraph_gg BINET: show_legend and legend_position work", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_BINET), "BINET fixture not available")

  expect_s3_class(plotGraph_gg(fixture_BINET, show_legend = TRUE)[[1]], "gg")
  expect_s3_class(plotGraph_gg(fixture_BINET, show_legend = FALSE)[[1]], "gg")
  expect_s3_class(
    plotGraph_gg(fixture_BINET,
      show_legend = TRUE,
      legend_position = "bottom"
    )[[1]], "gg"
  )
})

test_that("plotGraph_gg BINET: direction parameter works", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_BINET), "BINET fixture not available")

  for (dir in c("BT", "TB", "LR", "RL")) {
    result <- plotGraph_gg(fixture_BINET, direction = dir)
    expect_true(inherits(result[[1]], "gg"), label = paste("direction =", dir))
  }
})

test_that("plotGraph_gg BINET: both node types present", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_BINET), "BINET fixture not available")

  result <- plotGraph_gg(fixture_BINET)
  p <- result[[1]]
  build <- ggplot2::ggplot_build(p)
  point_data <- build$data[[2]] # geom_node_point is the 2nd layer

  # Must contain both Class (square=22) and Field (diamond=23) shapes
  shapes_present <- unique(point_data$shape)
  expect_true(22 %in% shapes_present, label = "Class squares present")
  expect_true(23 %in% shapes_present, label = "Field diamonds present")
})

test_that("plotGraph_gg BINET: node sizes differ by type", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_BINET), "BINET fixture not available")

  result <- plotGraph_gg(fixture_BINET)
  p <- result[[1]]
  build <- ggplot2::ggplot_build(p)
  point_data <- build$data[[2]]

  # Class nodes (shape 22) should be larger than Field nodes (shape 23)
  class_sizes <- point_data$size[point_data$shape == 22]
  field_sizes <- point_data$size[point_data$shape == 23]
  expect_true(all(class_sizes > field_sizes),
    label = "Class nodes larger than Field nodes"
  )
})

test_that("plotGraph_gg shades BNM nodes by correct response rate", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_BNM), "BNM fixture not available")

  p <- plotGraph_gg(fixture_BNM)[[1]]
  built <- ggplot2::ggplot_build(p)
  pts <- built$data[[2]]
  crr <- as.numeric(fixture_BNM$crr)
  # One node per item, each filled by its own correct response rate
  expect_equal(nrow(pts), length(crr))
  expect_equal(length(unique(pts$fill)), length(unique(crr)))
  # Higher rate -> darker fill on the default gradient
  lum <- colSums(grDevices::col2rgb(pts$fill) * c(0.299, 0.587, 0.114))
  node_crr <- p$data$crr
  expect_true(cor(lum, node_crr) < 0)
  # Scale follows the data by default; colour bar shown by default
  expect_null(p$scales$get_scales("fill")$limits)
  expect_false(identical(p$theme$legend.position, "none"))
  p01 <- plotGraph_gg(fixture_BNM, fill_limits = c(0, 1))[[1]]
  expect_equal(p01$scales$get_scales("fill")$limits, c(0, 1))
  expect_error(plotGraph_gg(fixture_BNM, fill_limits = 1), "length 2")
})

test_that("plotGraph_gg puts parents on top by default", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_BNM), "BNM fixture not available")

  y_of <- function(p) stats::setNames(p$data$y, p$data$name)
  edges <- igraph::as_edgelist(fixture_BNM$g)
  y_tb <- y_of(plotGraph_gg(fixture_BNM)[[1]])
  expect_true(all(y_tb[edges[, 1]] > y_tb[edges[, 2]]))
  y_bt <- y_of(plotGraph_gg(fixture_BNM, direction = "BT")[[1]])
  expect_true(all(y_bt[edges[, 1]] < y_bt[edges[, 2]]))
})

test_that("plotGraph_gg fill_by = 'type' keeps single-colour nodes", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_BNM), "BNM fixture not available")

  p <- plotGraph_gg(fixture_BNM, fill_by = "type")[[1]]
  pts <- ggplot2::ggplot_build(p)$data[[2]]
  expect_equal(length(unique(pts$fill)), 1)
  expect_identical(p$theme$legend.position, "none")
  expect_s3_class(plotGraph_gg(fixture_BNM, colors = c("white", "navy"))[[1]], "gg")
  expect_error(plotGraph_gg(fixture_BNM, colors = "navy"), "two colors")
})

test_that("node labels keep every digit of the item number", {
  expect_identical(
    .dag_node_number(c("Item01", "Item10", "Item14", "Item100", "PHQ9", "abc")),
    c("1", "10", "14", "100", "9", "abc")
  )
})

test_that("isolated BNM nodes are dropped with a caption, or drawn below", {
  skip_if_not_installed("exametrika")
  # Item05 has no edges
  DAG <- matrix(c("Item01", "Item02", "Item02", "Item03", "Item02", "Item04"),
    ncol = 2, byrow = TRUE
  )
  g <- igraph::add_vertices(igraph::graph_from_data_frame(DAG), 1, name = "Item05")
  res <- suppressMessages(exametrika::BNM(exametrika::J5S10, g = g))

  expect_message(p <- plotGraph_gg(res)[[1]], "isolated node\\(s\\): 5")
  expect_false("Item05" %in% p$data$name)
  expect_identical(p$labels$caption, "Isolated items: 5")

  p2 <- plotGraph_gg(res, show_isolated = TRUE)[[1]]
  expect_true("Item05" %in% p2$data$name)
  expect_null(p2$labels$caption)
  y <- stats::setNames(p2$data$y, p2$data$name)
  expect_true(y[["Item05"]] < min(y[setdiff(names(y), "Item05")]))
})
