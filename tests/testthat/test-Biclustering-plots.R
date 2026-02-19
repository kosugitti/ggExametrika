# ============================================================
# Tests for Biclustering plot functions
# plotFRP_gg, plotCRV_gg, plotRRV_gg
# ============================================================

# --- plotFRP_gg (binary) ---

test_that("plotFRP_gg returns ggplot for binary Biclustering", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_Biclust), "Biclustering fixture not available")

  result <- plotFRP_gg(fixture_Biclust)
  expect_s3_class(result, "gg")
})

test_that("plotFRP_gg fields parameter works for binary", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_Biclust), "Biclustering fixture not available")

  result <- plotFRP_gg(fixture_Biclust, fields = 1:2)
  expect_s3_class(result, "gg")
})

# --- plotFRP_gg (ordinal multi-value) ---

test_that("plotFRP_gg works with ordinal Biclustering", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_ordBiclust), "ordinal Biclustering fixture not available")

  result <- plotFRP_gg(fixture_ordBiclust)
  expect_s3_class(result, "gg")
})

test_that("plotFRP_gg stat parameter works for ordinal", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_ordBiclust), "ordinal Biclustering fixture not available")

  expect_s3_class(plotFRP_gg(fixture_ordBiclust, stat = "mean"), "gg")
  expect_s3_class(plotFRP_gg(fixture_ordBiclust, stat = "median"), "gg")
  expect_s3_class(plotFRP_gg(fixture_ordBiclust, stat = "mode"), "gg")
})

# --- plotFRP_gg (nominal multi-value) ---

test_that("plotFRP_gg works with nominal Biclustering", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_nomBiclust), "nominal Biclustering fixture not available")

  result <- plotFRP_gg(fixture_nomBiclust)
  expect_s3_class(result, "gg")
})

# --- plotFRP_gg common options ---

test_that("plotFRP_gg common options work", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_Biclust), "Biclustering fixture not available")

  expect_s3_class(plotFRP_gg(fixture_Biclust, title = FALSE), "gg")
  expect_s3_class(plotFRP_gg(fixture_Biclust, title = "Custom FRP"), "gg")
  expect_s3_class(plotFRP_gg(fixture_Biclust, colors = c("red", "blue", "green")), "gg")
  expect_s3_class(plotFRP_gg(fixture_Biclust, linetype = "dashed"), "gg")
  expect_s3_class(plotFRP_gg(fixture_Biclust, show_legend = FALSE), "gg")
  expect_s3_class(plotFRP_gg(fixture_Biclust, legend_position = "bottom"), "gg")
})

test_that("plotFRP_gg rejects invalid input", {
  expect_error(plotFRP_gg(NULL), "Invalid input")
  expect_error(plotFRP_gg(data.frame(x = 1)), "Invalid input")

  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_IRT_2PL), "IRT 2PL fixture not available")
  expect_error(plotFRP_gg(fixture_IRT_2PL), "Invalid input")
})

test_that("plotFRP_gg rejects invalid stat parameter", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_ordBiclust), "ordinal Biclustering fixture not available")

  expect_error(plotFRP_gg(fixture_ordBiclust, stat = "invalid"), "stat")
})

# --- plotCRV_gg ---

test_that("plotCRV_gg returns ggplot for binary Biclustering", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_Biclust), "Biclustering fixture not available")

  result <- plotCRV_gg(fixture_Biclust)
  expect_s3_class(result, "gg")
})

test_that("plotCRV_gg errors on polytomous data (3D FRP not supported by t())", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_ordBiclust), "ordinal Biclustering fixture not available")

  # CRV uses t(data$FRP) which cannot handle 3D arrays from polytomous models
  expect_error(plotCRV_gg(fixture_ordBiclust))
})

test_that("plotCRV_gg common options work", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_Biclust), "Biclustering fixture not available")

  expect_s3_class(plotCRV_gg(fixture_Biclust, title = FALSE), "gg")
  expect_s3_class(plotCRV_gg(fixture_Biclust, title = "Custom CRV"), "gg")
  expect_s3_class(plotCRV_gg(fixture_Biclust, linetype = "dashed"), "gg")
  expect_s3_class(plotCRV_gg(fixture_Biclust, show_legend = FALSE), "gg")
  expect_s3_class(plotCRV_gg(fixture_Biclust, legend_position = "top"), "gg")
})

test_that("plotCRV_gg rejects invalid input", {
  expect_error(plotCRV_gg(NULL))
  expect_error(plotCRV_gg(data.frame(x = 1)))

  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_IRT_2PL), "IRT 2PL fixture not available")
  expect_error(plotCRV_gg(fixture_IRT_2PL))
})

# --- plotRRV_gg ---

test_that("plotRRV_gg returns ggplot for binary Biclustering", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_Biclust), "Biclustering fixture not available")

  result <- plotRRV_gg(fixture_Biclust)
  expect_s3_class(result, "gg")
})

test_that("plotRRV_gg works with ordinal Biclustering", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_ordBiclust), "ordinal Biclustering fixture not available")

  result <- plotRRV_gg(fixture_ordBiclust)
  expect_s3_class(result, "gg")
})

test_that("plotRRV_gg stat parameter works for ordinal", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_ordBiclust), "ordinal Biclustering fixture not available")

  expect_s3_class(plotRRV_gg(fixture_ordBiclust, stat = "mean"), "gg")
  expect_s3_class(plotRRV_gg(fixture_ordBiclust, stat = "median"), "gg")
  expect_s3_class(plotRRV_gg(fixture_ordBiclust, stat = "mode"), "gg")
})

test_that("plotRRV_gg common options work", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_Biclust), "Biclustering fixture not available")

  expect_s3_class(plotRRV_gg(fixture_Biclust, title = FALSE), "gg")
  expect_s3_class(plotRRV_gg(fixture_Biclust, title = "Custom RRV"), "gg")
  expect_s3_class(plotRRV_gg(fixture_Biclust, linetype = "dotted"), "gg")
  expect_s3_class(plotRRV_gg(fixture_Biclust, show_legend = FALSE), "gg")
  expect_s3_class(plotRRV_gg(fixture_Biclust, legend_position = "bottom"), "gg")
})

test_that("plotRRV_gg rejects invalid input", {
  expect_error(plotRRV_gg(NULL))
  expect_error(plotRRV_gg(data.frame(x = 1)))

  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_IRT_2PL), "IRT 2PL fixture not available")
  expect_error(plotRRV_gg(fixture_IRT_2PL))
})
