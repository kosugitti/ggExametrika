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

  # ---- LDLRA fixture ----
  # LDLRA requires a DAG list (one igraph per rank)
  fixture_LDLRA <- tryCatch(
    {
      ldlra_dag <- data.frame(
        from = c("Item01", "Item02", "Item03"),
        to   = c("Item02", "Item03", "Item04")
      )
      ldlra_g <- igraph::graph_from_data_frame(ldlra_dag, directed = TRUE)
      exametrika::LDLRA(exametrika::J12S5000,
        ncls = 3,
        g = list(ldlra_g, ldlra_g, ldlra_g)
      )
    },
    error = function(e) NULL
  )

  # ---- LDB fixture ----
  # LDB requires field assignments (conf) and a DAG list (g_list).
  fixture_LDB <- tryCatch(
    {
      ldb_conf <- rep(1:3, length.out = 35)
      ldb_g <- igraph::graph_from_data_frame(
        data.frame(
          from = c("Field01", "Field02"),
          to = c("Field02", "Field03")
        ),
        directed = TRUE
      )
      exametrika::LDB(exametrika::J35S515,
        ncls = 3, conf = ldb_conf,
        g_list = list(ldb_g, ldb_g, ldb_g)
      )
    },
    error = function(e) NULL
  )

  # ---- BNM fixture (fast) ----
  # BNM requires a DAG (directed acyclic graph) as input
  fixture_BNM <- tryCatch(
    {
      # Create a simple DAG for J5S10 (5 items)
      bnm_dag <- igraph::make_empty_graph(n = 5, directed = TRUE)
      igraph::V(bnm_dag)$name <- exametrika::J5S10$ItemLabel
      # Add edges: Item01->Item03, Item02->Item04, Item03->Item05
      bnm_dag <- igraph::add_edges(bnm_dag, c(1, 3, 2, 4, 3, 5))
      exametrika::BNM(exametrika::J5S10, g = bnm_dag)
    },
    error = function(e) NULL
  )

  # ---- BINET fixture ----
  # BINET requires field assignments (conf) and DAG edge file (adj_file).
  # Note: BINET's adj_list input path has a known bug (g_csv undefined),
  # so we use adj_file with a temporary CSV instead.
  fixture_BINET <- tryCatch(
    {
      binet_conf <- rep(1:3, length.out = 35)
      # Create temporary edge CSV: From, To, Field
      binet_edges <- data.frame(
        From  = c(1, 2, 1, 2, 1, 2),
        To    = c(2, 3, 2, 3, 2, 3),
        Field = c(1, 1, 2, 2, 3, 3)
      )
      binet_edge_file <- tempfile(fileext = ".csv")
      write.csv(binet_edges, binet_edge_file, row.names = FALSE)
      result <- exametrika::BINET(exametrika::J35S515,
        ncls = 3, nfld = 3,
        conf = binet_conf, adj_file = binet_edge_file,
        verbose = FALSE
      )
      unlink(binet_edge_file)
      result
    },
    error = function(e) NULL
  )

  # ---- Rated Biclustering fixture (synthetic small data) ----
  # Rated data: items scored 0-4 (e.g. 5-point Likert scale)
  set.seed(44)
  .synth_rated <- matrix(sample(0:4, 40 * 12, replace = TRUE),
    nrow = 40, ncol = 12
  )
  colnames(.synth_rated) <- paste0("Item", 1:12)
  fixture_ratedBiclust <- tryCatch(
    exametrika::Biclustering(.synth_rated,
      nfld = 2, ncls = 3,
      dataType = "rated"
    ),
    error = function(e) NULL
  )

  # ---- DistractorAnalysis fixtures (from LRA.rated) ----
  fixture_DA_lra <- tryCatch(
    {
      lra_rated <- exametrika::LRA(exametrika::J21S300, nrank = 5, mic = TRUE)
      exametrika::DistractorAnalysis(lra_rated)
    },
    error = function(e) NULL
  )

  # ---- DistractorAnalysis fixtures (from ratedBiclustering) ----
  fixture_DA_biclust <- tryCatch(
    {
      bic_rated <- exametrika::Biclustering(exametrika::J21S300,
        ncls = 5, nfld = 3, method = "R", maxiter = 100
      )
      exametrika::DistractorAnalysis(bic_rated)
    },
    error = function(e) NULL
  )

  # Clean up temporary variables
  rm(.synth_ordinal, .synth_nominal, .synth_rated)
}
