# フィクスチャそのものの検査
#
# helper-setup.R は各フィクスチャを tryCatch(..., error = function(e) NULL) で
# 組み，各テストは skip_if(is.null(fixture_X)) で守っている。exametrika は
# Suggests なので未導入の環境で落とさないための作りだが，**導入済みの環境で
# フィクスチャが壊れても黙ってスキップされる**という穴がある。
# 実際 2026-08-20 に，フィクスチャのデータを小さくしすぎて 2 つが NULL になり，
# 15 件のテストが静かに飛んだまま「FAIL 0」と報告された。
# ここで明示的に検査して，その手の事故を失敗として見えるようにする。

test_that("every fixture builds when exametrika is installed", {
  skip_if_not_installed("exametrika")

  fixtures <- c(
    "fixture_IRT_2PL", "fixture_IRT_3PL", "fixture_GRM",
    "fixture_LCA", "fixture_LRA", "fixture_LRAord", "fixture_LRArated",
    "fixture_Biclust", "fixture_ordBiclust", "fixture_nomBiclust",
    "fixture_ratedBiclust", "fixture_LDLRA", "fixture_LDB",
    "fixture_BNM", "fixture_BINET", "fixture_DA_lra", "fixture_DA_biclust"
  )

  missing <- Filter(function(n) !exists(n) || is.null(get(n)), fixtures)
  expect_equal(missing, character(0))
})
