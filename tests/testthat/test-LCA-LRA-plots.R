# ============================================================
# Tests for LCA/LRA-based plot functions
# plotIRP_gg, plotTRP_gg, plotLCD_gg, plotLRD_gg, plotCMP_gg, plotRMP_gg
# ============================================================

# --- plotIRP_gg ---

test_that("plotIRP_gg returns list of ggplots for LCA", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_LCA), "LCA fixture not available")

  result <- plotIRP_gg(fixture_LCA)
  expect_type(result, "list")
  expect_true(length(result) > 0)
  expect_s3_class(result[[1]], "gg")
})

test_that("plotIRP_gg returns list of ggplots for LRA", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_LRA), "LRA fixture not available")

  result <- plotIRP_gg(fixture_LRA)
  expect_type(result, "list")
  expect_true(length(result) > 0)
  expect_s3_class(result[[1]], "gg")
})

test_that("plotIRP_gg common options work", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_LCA), "LCA fixture not available")

  expect_s3_class(plotIRP_gg(fixture_LCA, title = FALSE)[[1]], "gg")
  expect_s3_class(plotIRP_gg(fixture_LCA, title = "Custom IRP")[[1]], "gg")
  expect_s3_class(plotIRP_gg(fixture_LCA, colors = "red")[[1]], "gg")
  expect_s3_class(plotIRP_gg(fixture_LCA, linetype = "solid")[[1]], "gg")
  expect_s3_class(plotIRP_gg(fixture_LCA,
    show_legend = TRUE, legend_position = "bottom")[[1]], "gg")
})

test_that("plotIRP_gg rejects invalid input", {
  expect_error(plotIRP_gg(NULL), "Invalid input")
  expect_error(plotIRP_gg(data.frame(x = 1)), "Invalid input")

  # IRT is not LCA/LRA
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_IRT_2PL), "IRT 2PL fixture not available")
  expect_error(plotIRP_gg(fixture_IRT_2PL), "Invalid input")
})

# --- plotTRP_gg ---

test_that("plotTRP_gg returns ggplot for LCA", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_LCA), "LCA fixture not available")

  result <- plotTRP_gg(fixture_LCA)
  expect_s3_class(result, "gg")
})

test_that("plotTRP_gg returns ggplot for LRA", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_LRA), "LRA fixture not available")

  result <- plotTRP_gg(fixture_LRA)
  expect_s3_class(result, "gg")
})

test_that("plotTRP_gg returns ggplot for Biclustering", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_Biclust), "Biclustering fixture not available")

  result <- plotTRP_gg(fixture_Biclust)
  expect_s3_class(result, "gg")
})

test_that("plotTRP_gg Num_Students parameter works", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_LCA), "LCA fixture not available")

  expect_s3_class(plotTRP_gg(fixture_LCA, Num_Students = FALSE), "gg")
  expect_s3_class(plotTRP_gg(fixture_LCA, Num_Students = TRUE), "gg")
})

test_that("plotTRP_gg common options work", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_LCA), "LCA fixture not available")

  expect_s3_class(plotTRP_gg(fixture_LCA, title = FALSE), "gg")
  expect_s3_class(plotTRP_gg(fixture_LCA, title = "Custom TRP"), "gg")
  expect_s3_class(plotTRP_gg(fixture_LCA, colors = c("steelblue", "red")), "gg")
  expect_s3_class(plotTRP_gg(fixture_LCA, linetype = "solid"), "gg")
})

test_that("plotTRP_gg rejects invalid input", {
  expect_error(plotTRP_gg(NULL), "Invalid input")
  expect_error(plotTRP_gg(data.frame(x = 1)), "Invalid input")
})

# --- plotLCD_gg ---

test_that("plotLCD_gg returns ggplot for LCA", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_LCA), "LCA fixture not available")

  result <- plotLCD_gg(fixture_LCA)
  expect_s3_class(result, "gg")
})

test_that("plotLCD_gg warns and plots LRD for LRA input", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_LRA), "LRA fixture not available")

  expect_warning(result <- plotLCD_gg(fixture_LRA), "Latent Rank Distribution")
  expect_s3_class(result, "gg")
})

test_that("plotLCD_gg common options work", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_LCA), "LCA fixture not available")

  expect_s3_class(plotLCD_gg(fixture_LCA, title = FALSE), "gg")
  expect_s3_class(plotLCD_gg(fixture_LCA, title = "Custom LCD"), "gg")
  expect_s3_class(plotLCD_gg(fixture_LCA, colors = c("lightblue", "darkblue")), "gg")
  expect_s3_class(plotLCD_gg(fixture_LCA, Num_Students = FALSE), "gg")
})

test_that("plotLCD_gg rejects invalid input", {
  expect_error(plotLCD_gg(NULL), "Invalid input")
  expect_error(plotLCD_gg(data.frame(x = 1)), "Invalid input")
})

# --- plotLRD_gg ---

test_that("plotLRD_gg returns ggplot for LRA", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_LRA), "LRA fixture not available")

  result <- plotLRD_gg(fixture_LRA)
  expect_s3_class(result, "gg")
})

test_that("plotLRD_gg returns ggplot for Biclustering", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_Biclust), "Biclustering fixture not available")

  result <- plotLRD_gg(fixture_Biclust)
  expect_s3_class(result, "gg")
})

test_that("plotLRD_gg warns and plots LCD for LCA input", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_LCA), "LCA fixture not available")

  expect_warning(result <- plotLRD_gg(fixture_LCA), "Latent Class Distribution")
  expect_s3_class(result, "gg")
})

test_that("plotLRD_gg common options work", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_LRA), "LRA fixture not available")

  expect_s3_class(plotLRD_gg(fixture_LRA, title = FALSE), "gg")
  expect_s3_class(plotLRD_gg(fixture_LRA, title = "Custom LRD"), "gg")
  expect_s3_class(plotLRD_gg(fixture_LRA, colors = c("steelblue", "red")), "gg")
})

test_that("plotLRD_gg rejects invalid input", {
  expect_error(plotLRD_gg(NULL), "Invalid input")
  expect_error(plotLRD_gg(data.frame(x = 1)), "Invalid input")
})

# --- plotCMP_gg ---

test_that("plotCMP_gg returns list of ggplots for LCA", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_LCA), "LCA fixture not available")

  result <- plotCMP_gg(fixture_LCA)
  expect_type(result, "list")
  expect_true(length(result) > 0)
  expect_s3_class(result[[1]], "gg")
})

test_that("plotCMP_gg warns and plots RMP for LRA input", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_LRA), "LRA fixture not available")

  expect_warning(result <- plotCMP_gg(fixture_LRA), "Rank Membership Profile")
  expect_type(result, "list")
  expect_s3_class(result[[1]], "gg")
})

test_that("plotCMP_gg common options work", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_LCA), "LCA fixture not available")

  expect_s3_class(plotCMP_gg(fixture_LCA, title = FALSE)[[1]], "gg")
  expect_s3_class(plotCMP_gg(fixture_LCA, title = "Custom CMP")[[1]], "gg")
  expect_s3_class(plotCMP_gg(fixture_LCA, colors = "blue")[[1]], "gg")
  expect_s3_class(plotCMP_gg(fixture_LCA, linetype = "solid")[[1]], "gg")
})

test_that("plotCMP_gg rejects invalid input", {
  expect_error(plotCMP_gg(NULL), "Invalid input")
  expect_error(plotCMP_gg(data.frame(x = 1)), "Invalid input")
})

# --- plotRMP_gg ---

test_that("plotRMP_gg returns list of ggplots for LRA", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_LRA), "LRA fixture not available")

  result <- plotRMP_gg(fixture_LRA)
  expect_type(result, "list")
  expect_true(length(result) > 0)
  expect_s3_class(result[[1]], "gg")
})

test_that("plotRMP_gg returns list of ggplots for Biclustering", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_Biclust), "Biclustering fixture not available")

  result <- plotRMP_gg(fixture_Biclust)
  expect_type(result, "list")
  expect_true(length(result) > 0)
  expect_s3_class(result[[1]], "gg")
})

test_that("plotRMP_gg warns and plots CMP for LCA input", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_LCA), "LCA fixture not available")

  expect_warning(result <- plotRMP_gg(fixture_LCA), "Class Membership Profile")
  expect_type(result, "list")
  expect_s3_class(result[[1]], "gg")
})

test_that("plotRMP_gg common options work", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_LRA), "LRA fixture not available")

  expect_s3_class(plotRMP_gg(fixture_LRA, title = FALSE)[[1]], "gg")
  expect_s3_class(plotRMP_gg(fixture_LRA, title = "Custom RMP")[[1]], "gg")
  expect_s3_class(plotRMP_gg(fixture_LRA, colors = "green")[[1]], "gg")
})

test_that("plotRMP_gg rejects invalid input", {
  expect_error(plotRMP_gg(NULL), "Invalid input")
  expect_error(plotRMP_gg(data.frame(x = 1)), "Invalid input")
})
