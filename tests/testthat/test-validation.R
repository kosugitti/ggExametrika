# ============================================================
# Cross-cutting input validation tests for ALL plot functions
# Ensures every function properly rejects invalid input
# ============================================================

# --- Helper: invalid inputs to test ---
invalid_inputs <- list(
  "NULL"       = NULL,
  "data.frame" = data.frame(x = 1:5),
  "numeric"    = 42,
  "character"  = "invalid",
  "list"       = list(a = 1, b = 2)
)

# --- IRT-only functions ---

test_that("plotICC_gg rejects all invalid input types", {
  for (nm in names(invalid_inputs)) {
    expect_error(plotICC_gg(invalid_inputs[[nm]]),
      info = paste("plotICC_gg should reject", nm))
  }
})

test_that("plotTRF_gg rejects all invalid input types", {
  for (nm in names(invalid_inputs)) {
    expect_error(plotTRF_gg(invalid_inputs[[nm]]),
      info = paste("plotTRF_gg should reject", nm))
  }
})

test_that("plotICC_overlay_gg rejects all invalid input types", {
  for (nm in names(invalid_inputs)) {
    expect_error(plotICC_overlay_gg(invalid_inputs[[nm]]),
      info = paste("plotICC_overlay_gg should reject", nm))
  }
})

# --- IRT/GRM functions ---

test_that("plotIIC_gg rejects all invalid input types", {
  for (nm in names(invalid_inputs)) {
    expect_error(plotIIC_gg(invalid_inputs[[nm]]),
      info = paste("plotIIC_gg should reject", nm))
  }
})

test_that("plotTIC_gg rejects all invalid input types", {
  for (nm in names(invalid_inputs)) {
    expect_error(plotTIC_gg(invalid_inputs[[nm]]),
      info = paste("plotTIC_gg should reject", nm))
  }
})

test_that("plotIIC_overlay_gg rejects all invalid input types", {
  for (nm in names(invalid_inputs)) {
    expect_error(plotIIC_overlay_gg(invalid_inputs[[nm]]),
      info = paste("plotIIC_overlay_gg should reject", nm))
  }
})

# --- GRM-only functions ---

test_that("plotICRF_gg rejects all invalid input types", {
  for (nm in names(invalid_inputs)) {
    expect_error(plotICRF_gg(invalid_inputs[[nm]]),
      info = paste("plotICRF_gg should reject", nm))
  }
})

# --- LCA/LRA functions ---

test_that("plotIRP_gg rejects all invalid input types", {
  for (nm in names(invalid_inputs)) {
    expect_error(plotIRP_gg(invalid_inputs[[nm]]),
      info = paste("plotIRP_gg should reject", nm))
  }
})

test_that("plotTRP_gg rejects all invalid input types", {
  for (nm in names(invalid_inputs)) {
    expect_error(plotTRP_gg(invalid_inputs[[nm]]),
      info = paste("plotTRP_gg should reject", nm))
  }
})

test_that("plotLCD_gg rejects all invalid input types", {
  for (nm in names(invalid_inputs)) {
    expect_error(plotLCD_gg(invalid_inputs[[nm]]),
      info = paste("plotLCD_gg should reject", nm))
  }
})

test_that("plotLRD_gg rejects all invalid input types", {
  for (nm in names(invalid_inputs)) {
    expect_error(plotLRD_gg(invalid_inputs[[nm]]),
      info = paste("plotLRD_gg should reject", nm))
  }
})

test_that("plotCMP_gg rejects all invalid input types", {
  for (nm in names(invalid_inputs)) {
    expect_error(plotCMP_gg(invalid_inputs[[nm]]),
      info = paste("plotCMP_gg should reject", nm))
  }
})

test_that("plotRMP_gg rejects all invalid input types", {
  for (nm in names(invalid_inputs)) {
    expect_error(plotRMP_gg(invalid_inputs[[nm]]),
      info = paste("plotRMP_gg should reject", nm))
  }
})

# --- Biclustering functions ---

test_that("plotFRP_gg rejects all invalid input types", {
  for (nm in names(invalid_inputs)) {
    expect_error(plotFRP_gg(invalid_inputs[[nm]]),
      info = paste("plotFRP_gg should reject", nm))
  }
})

test_that("plotCRV_gg rejects all invalid input types", {
  for (nm in names(invalid_inputs)) {
    expect_error(plotCRV_gg(invalid_inputs[[nm]]),
      info = paste("plotCRV_gg should reject", nm))
  }
})

test_that("plotRRV_gg rejects all invalid input types", {
  for (nm in names(invalid_inputs)) {
    expect_error(plotRRV_gg(invalid_inputs[[nm]]),
      info = paste("plotRRV_gg should reject", nm))
  }
})

test_that("plotArray_gg rejects all invalid input types", {
  for (nm in names(invalid_inputs)) {
    expect_error(plotArray_gg(invalid_inputs[[nm]]),
      info = paste("plotArray_gg should reject", nm))
  }
})

# --- Polytomous Biclustering functions ---

test_that("plotFCRP_gg rejects all invalid input types", {
  for (nm in names(invalid_inputs)) {
    expect_error(plotFCRP_gg(invalid_inputs[[nm]]),
      info = paste("plotFCRP_gg should reject", nm))
  }
})

test_that("plotFCBR_gg rejects all invalid input types", {
  for (nm in names(invalid_inputs)) {
    expect_error(plotFCBR_gg(invalid_inputs[[nm]]),
      info = paste("plotFCBR_gg should reject", nm))
  }
})

test_that("plotScoreField_gg rejects all invalid input types", {
  for (nm in names(invalid_inputs)) {
    expect_error(plotScoreField_gg(invalid_inputs[[nm]]),
      info = paste("plotScoreField_gg should reject", nm))
  }
})

# --- LRAordinal/LRArated functions ---

test_that("plotScoreFreq_gg rejects all invalid input types", {
  for (nm in names(invalid_inputs)) {
    expect_error(plotScoreFreq_gg(invalid_inputs[[nm]]),
      info = paste("plotScoreFreq_gg should reject", nm))
  }
})

test_that("plotScoreRank_gg rejects all invalid input types", {
  for (nm in names(invalid_inputs)) {
    expect_error(plotScoreRank_gg(invalid_inputs[[nm]]),
      info = paste("plotScoreRank_gg should reject", nm))
  }
})

test_that("plotICRP_gg rejects all invalid input types", {
  for (nm in names(invalid_inputs)) {
    expect_error(plotICRP_gg(invalid_inputs[[nm]]),
      info = paste("plotICRP_gg should reject", nm))
  }
})

test_that("plotICBR_gg rejects all invalid input types", {
  for (nm in names(invalid_inputs)) {
    expect_error(plotICBR_gg(invalid_inputs[[nm]]),
      info = paste("plotICBR_gg should reject", nm))
  }
})

# --- DAG function ---

test_that("plotGraph_gg rejects all invalid input types", {
  for (nm in names(invalid_inputs)) {
    expect_error(plotGraph_gg(invalid_inputs[[nm]]),
      info = paste("plotGraph_gg should reject", nm))
  }
})

# --- Wrong model type cross-checks ---

test_that("IRT functions reject non-IRT models", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_LCA), "LCA fixture not available")

  expect_error(plotICC_gg(fixture_LCA))
  expect_error(plotTRF_gg(fixture_LCA))
  expect_error(plotICC_overlay_gg(fixture_LCA))
})

test_that("LCA/LRA functions reject IRT models", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_IRT_2PL), "IRT 2PL fixture not available")

  expect_error(plotIRP_gg(fixture_IRT_2PL))
  expect_error(plotTRP_gg(fixture_IRT_2PL))
})

test_that("Biclustering functions reject IRT models", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_IRT_2PL), "IRT 2PL fixture not available")

  expect_error(plotFRP_gg(fixture_IRT_2PL))
  expect_error(plotCRV_gg(fixture_IRT_2PL))
  expect_error(plotRRV_gg(fixture_IRT_2PL))
})

test_that("LRAordinal functions reject IRT models", {
  skip_if_not_installed("exametrika")
  skip_if(is.null(fixture_IRT_2PL), "IRT 2PL fixture not available")

  expect_error(plotScoreFreq_gg(fixture_IRT_2PL))
  expect_error(plotScoreRank_gg(fixture_IRT_2PL))
  expect_error(plotICRP_gg(fixture_IRT_2PL))
  expect_error(plotICBR_gg(fixture_IRT_2PL))
})
