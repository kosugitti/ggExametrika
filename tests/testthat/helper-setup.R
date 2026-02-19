# ============================================================
# helper-setup.R
# Common test fixtures for ggExametrika
# Computed once before all tests
# ============================================================

has_exametrika <- requireNamespace("exametrika", quietly = TRUE)

if (has_exametrika) {

  # ---- IRT fixtures (fast) ----
  fixture_IRT_2PL <- tryCatch(
    exametrika::IRT(exametrika::J15S500, model = 2),
    error = function(e) NULL
  )

  fixture_IRT_3PL <- tryCatch(
    exametrika::IRT(exametrika::J15S500, model = 3),
    error = function(e) NULL
  )

  # ---- GRM fixture (fast) ----
  fixture_GRM <- tryCatch(
    exametrika::GRM(exametrika::J5S1000),
    error = function(e) NULL
  )

  # ---- LCA fixture ----
  fixture_LCA <- tryCatch(
    exametrika::LCA(exametrika::J15S500, ncls = 3),
    error = function(e) NULL
  )

  # ---- LRA fixture ----
  fixture_LRA <- tryCatch(
    exametrika::LRA(exametrika::J15S500, nrank = 3),
    error = function(e) NULL
  )

  # ---- Binary Biclustering fixture ----
  fixture_Biclust <- tryCatch(
    exametrika::Biclustering(exametrika::J35S515, nfld = 3, ncls = 4),
    error = function(e) NULL
  )

  # ---- Ordinal Biclustering fixture (synthetic small data) ----
  set.seed(42)
  .synth_ordinal <- matrix(sample(0:3, 40 * 12, replace = TRUE),
    nrow = 40, ncol = 12
  )
  colnames(.synth_ordinal) <- paste0("Item", 1:12)
  fixture_ordBiclust <- tryCatch(
    exametrika::Biclustering(.synth_ordinal,
      nfld = 2, ncls = 3,
      dataType = "ordinal"
    ),
    error = function(e) NULL
  )

  # ---- Nominal Biclustering fixture (synthetic small data) ----
  # Use 4 categories (0:3) to ensure FRP 3rd dimension >= 3 for FCRP tests
  set.seed(43)
  .synth_nominal <- matrix(sample(0:3, 40 * 12, replace = TRUE),
    nrow = 40, ncol = 12
  )
  colnames(.synth_nominal) <- paste0("Item", 1:12)
  fixture_nomBiclust <- tryCatch(
    exametrika::Biclustering(.synth_nominal,
      nfld = 2, ncls = 3,
      dataType = "nominal"
    ),
    error = function(e) NULL
  )

  # ---- LRAordinal fixture ----
  fixture_LRAord <- tryCatch(
    exametrika::LRA(exametrika::J15S3810,
      nrank = 3,
      dataType = "ordinal"
    ),
    error = function(e) NULL
  )

  # ---- LRArated fixture ----
  fixture_LRArated <- tryCatch(
    exametrika::LRA(exametrika::J15S3810,
      nrank = 3,
      dataType = "rated"
    ),
    error = function(e) NULL
  )

  # ---- BNM fixture (fast) ----
  fixture_BNM <- tryCatch(
    exametrika::BNM(exametrika::J5S10),
    error = function(e) NULL
  )

  # Clean up temporary variables
  rm(.synth_ordinal, .synth_nominal)
}
