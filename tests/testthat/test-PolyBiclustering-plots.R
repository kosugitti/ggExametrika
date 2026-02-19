# ============================================================
# Tests for Polytomous Biclustering plot functions (v1.9.0)
# plotFCRP_gg, plotFCBR_gg, plotScoreField_gg
# ============================================================

# --- plotFCRP_gg ---

test_that("plotFCRP_gg returns ggplot for ordinal Biclustering", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_ordBiclust), "ordinal Biclustering fixture not available")

  result <- plotFCRP_gg(fixture_ordBiclust)
  expect_s3_class(result, "gg")
})

test_that("plotFCRP_gg returns ggplot for nominal Biclustering", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_nomBiclust), "nominal Biclustering fixture not available")

  result <- plotFCRP_gg(fixture_nomBiclust)
  expect_s3_class(result, "gg")
})

test_that("plotFCRP_gg style parameter works", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_ordBiclust), "ordinal Biclustering fixture not available")

  expect_s3_class(plotFCRP_gg(fixture_ordBiclust, style = "line"), "gg")
  expect_s3_class(plotFCRP_gg(fixture_ordBiclust, style = "bar"), "gg")
})

test_that("plotFCRP_gg common options work", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_ordBiclust), "ordinal Biclustering fixture not available")

  expect_s3_class(plotFCRP_gg(fixture_ordBiclust, title = FALSE), "gg")
  expect_s3_class(plotFCRP_gg(fixture_ordBiclust, title = "Custom FCRP"), "gg")
  expect_s3_class(plotFCRP_gg(fixture_ordBiclust, show_legend = FALSE), "gg")
  expect_s3_class(plotFCRP_gg(fixture_ordBiclust, legend_position = "bottom"), "gg")
})

test_that("plotFCRP_gg rejects invalid input", {
  expect_error(plotFCRP_gg(NULL))
  expect_error(plotFCRP_gg(data.frame(x = 1)))

  # Binary Biclustering should fail (requires 3+ categories)
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_Biclust), "Biclustering fixture not available")
  expect_error(plotFCRP_gg(fixture_Biclust))
})

# --- plotFCBR_gg ---

test_that("plotFCBR_gg returns ggplot for ordinal Biclustering", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_ordBiclust), "ordinal Biclustering fixture not available")

  result <- plotFCBR_gg(fixture_ordBiclust)
  expect_s3_class(result, "gg")
})

test_that("plotFCBR_gg fields parameter works", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_ordBiclust), "ordinal Biclustering fixture not available")

  result <- plotFCBR_gg(fixture_ordBiclust, fields = 1)
  expect_s3_class(result, "gg")
})

test_that("plotFCBR_gg common options work", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_ordBiclust), "ordinal Biclustering fixture not available")

  expect_s3_class(plotFCBR_gg(fixture_ordBiclust, title = FALSE), "gg")
  expect_s3_class(plotFCBR_gg(fixture_ordBiclust, title = "Custom FCBR"), "gg")
  expect_s3_class(plotFCBR_gg(fixture_ordBiclust, show_legend = FALSE), "gg")
  expect_s3_class(plotFCBR_gg(fixture_ordBiclust, legend_position = "top"), "gg")
})

test_that("plotFCBR_gg rejects invalid input", {
  expect_error(plotFCBR_gg(NULL))
  expect_error(plotFCBR_gg(data.frame(x = 1)))
})

# --- plotScoreField_gg ---

test_that("plotScoreField_gg returns ggplot for ordinal Biclustering", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_ordBiclust), "ordinal Biclustering fixture not available")

  result <- plotScoreField_gg(fixture_ordBiclust)
  expect_s3_class(result, "gg")
})

test_that("plotScoreField_gg returns ggplot for nominal Biclustering", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_nomBiclust), "nominal Biclustering fixture not available")

  result <- plotScoreField_gg(fixture_nomBiclust)
  expect_s3_class(result, "gg")
})

test_that("plotScoreField_gg show_values parameter works", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_ordBiclust), "ordinal Biclustering fixture not available")

  expect_s3_class(plotScoreField_gg(fixture_ordBiclust, show_values = TRUE), "gg")
  expect_s3_class(plotScoreField_gg(fixture_ordBiclust, show_values = FALSE), "gg")
})

test_that("plotScoreField_gg common options work", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_ordBiclust), "ordinal Biclustering fixture not available")

  expect_s3_class(plotScoreField_gg(fixture_ordBiclust, title = FALSE), "gg")
  expect_s3_class(plotScoreField_gg(fixture_ordBiclust, title = "Custom ScoreField"), "gg")
  expect_s3_class(plotScoreField_gg(fixture_ordBiclust, show_legend = FALSE), "gg")
  expect_s3_class(plotScoreField_gg(fixture_ordBiclust, legend_position = "bottom"), "gg")
  expect_s3_class(plotScoreField_gg(fixture_ordBiclust, text_size = 5), "gg")
})

test_that("plotScoreField_gg rejects invalid input", {
  expect_error(plotScoreField_gg(NULL))
  expect_error(plotScoreField_gg(data.frame(x = 1)))

  # Binary Biclustering should fail (requires 3D FRP)
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_Biclust), "Biclustering fixture not available")
  expect_error(plotScoreField_gg(fixture_Biclust))
})
