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

test_that("plotCRV_gg works with polytomous data (stat parameter)", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_ordBiclust), "ordinal Biclustering fixture not available")

  # CRV now supports polytomous data via stat parameter
  expect_s3_class(plotCRV_gg(fixture_ordBiclust), "gg")
  expect_s3_class(plotCRV_gg(fixture_ordBiclust, stat = "mean"), "gg")
  expect_s3_class(plotCRV_gg(fixture_ordBiclust, stat = "median"), "gg")
  expect_s3_class(plotCRV_gg(fixture_ordBiclust, stat = "mode"), "gg")
  expect_s3_class(plotCRV_gg(fixture_ordBiclust, show_labels = TRUE), "gg")
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

# --- Value-correctness regression tests (issue: long-form index mismatch) ---

test_that("plotCRV_gg / plotRRV_gg map binary FRP values to (field, rank) correctly", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_Biclust), "Biclustering fixture not available")

  FRP <- fixture_Biclust$FRP # field x class matrix
  n_fld <- nrow(FRP)
  n_cls <- ncol(FRP)

  pdat_C <- plotCRV_gg(fixture_Biclust)$data
  pdat_R <- plotRRV_gg(fixture_Biclust)$data

  for (f in seq_len(n_fld)) {
    for (k in seq_len(n_cls)) {
      expected <- FRP[f, k]
      got_C <- pdat_C$value[pdat_C$field == f & pdat_C$class == paste0("C", k)]
      got_R <- pdat_R$value[pdat_R$field == f & pdat_R$rank == paste0("R", k)]
      expect_equal(got_C, expected,
        info = sprintf("CRV mismatch at field=%d, class=%d", f, k)
      )
      expect_equal(got_R, expected,
        info = sprintf("RRV mismatch at field=%d, rank=%d", f, k)
      )
    }
  }
})

test_that("plotRRV_gg maps polytomous expected scores to (field, rank) correctly", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_ordBiclust), "ordinal Biclustering fixture not available")

  BCRM <- fixture_ordBiclust$FRP # field x class x category
  n_fld <- dim(BCRM)[1]
  n_cls <- dim(BCRM)[2]
  maxQ <- dim(BCRM)[3]

  expected_mean <- matrix(0, n_fld, n_cls)
  for (f in seq_len(n_fld)) {
    for (k in seq_len(n_cls)) {
      expected_mean[f, k] <- sum(seq_len(maxQ) * BCRM[f, k, ])
    }
  }

  pdat <- plotRRV_gg(fixture_ordBiclust, stat = "mean")$data
  for (f in seq_len(n_fld)) {
    for (k in seq_len(n_cls)) {
      got <- pdat$value[pdat$field == f & pdat$rank == paste0("R", k)]
      expect_equal(got, expected_mean[f, k],
        info = sprintf("polytomous RRV mismatch at field=%d, rank=%d", f, k)
      )
    }
  }
})
