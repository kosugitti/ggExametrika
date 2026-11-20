# plotRankUpShift_gg() / plotRankOdds_gg(): ordinal Ranklustering (exametrika
# 2.3.0 returns RankUpShift and the odds; earlier fits are computed here)

.rus_fit <- NULL
rus_fit <- function() {
  if (is.null(.rus_fit)) {
    set.seed(7)
    cls <- rep(1:3, each = 40)
    U <- sapply(1:6, function(j) {
      as.integer(cut((cls - 2) + rnorm(120, 0, 0.7), c(-Inf, -0.7, 0.3, 1.2, Inf)))
    })
    colnames(U) <- paste0("Item", 1:6)
    .rus_fit <<- suppressMessages(suppressWarnings(exametrika::Biclustering(
      exametrika::dataFormat(U, response.type = "ordinal"),
      ncls = 3, nfld = 2, method = "R", nstart = 0
    )))
  }
  return(.rus_fit)
}

test_that("plotRankUpShift_gg returns a ggplot with one facet per field", {
  skip_if_not(has_exametrika)
  f <- rus_fit()
  p <- plotRankUpShift_gg(f)
  expect_s3_class(p, "ggplot")
  expect_equal(nlevels(p$data$field), f$n_field)
  expect_equal(nlevels(p$data$step), f$n_class - 1)
  p1 <- plotRankUpShift_gg(f, fields = 2, title = FALSE, label_min = Inf)
  expect_equal(levels(p1$data$field), "Field2")
  expect_true(all(p1$data$label == ""))
  expect_error(plotRankUpShift_gg(f, fields = 5), "between 1 and")
})

test_that("the values are computed for a fit without RankUpShift", {
  skip_if_not(has_exametrika)
  f <- rus_fit()
  g <- f
  g$RankUpShift <- NULL
  g$Students <- g$Students[, grep("^Membership|^Estimate", colnames(g$Students))]
  if (!is.null(f$RankUpShift)) {
    expect_equal(.rank_up_shift(g), f$RankUpShift)
  }
  if ("Rank-Up Odds" %in% colnames(f$Students)) {
    expect_equal(unname(.rank_odds(g)$up), unname(f$Students[, "Rank-Up Odds"]))
    expect_equal(unname(.rank_odds(g)$down), unname(f$Students[, "Rank-Down Odds"]))
  }
  expect_s3_class(plotRankUpShift_gg(g), "ggplot")
  expect_s3_class(plotRankOdds_gg(g), "ggplot")
})

test_that("plotRankOdds_gg returns two facets and refuses a plain Biclustering", {
  skip_if_not(has_exametrika)
  p <- plotRankOdds_gg(rus_fit())
  expect_s3_class(p, "ggplot")
  expect_equal(levels(p$data$which), c("Rank-Up Odds", "Rank-Down Odds"))
  expect_true(all(p$data$value >= 1e-4))
  skip_if(is.null(fixture_ordBiclust))
  expect_error(plotRankUpShift_gg(fixture_ordBiclust), "Ranklustering")
  expect_error(plotRankOdds_gg(fixture_ordBiclust), "Ranklustering")
})
