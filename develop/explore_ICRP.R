# =============================================================
# ICRP (Item Category Reference Profile) データ構造の調査
# =============================================================

library(exametrika)

# --- データ準備 ---
# J15S3810: 15項目×3810人の ordinal データ（4カテゴリ）
result_ord <- exametrika::LRA(J15S3810, nrank = 4, dataType = "ordinal")

# =============================================================
# 1. ICRPデータの存在確認
# =============================================================
cat("=== ICRP データの存在確認 ===\n")
cat("result_ord$ICRP が存在するか:", "ICRP" %in% names(result_ord), "\n\n")

if ("ICRP" %in% names(result_ord)) {
  # =============================================================
  # 2. ICRPデータの構造
  # =============================================================
  cat("=== ICRP データの構造 ===\n")
  cat("クラス:", class(result_ord$ICRP), "\n")
  cat("次元:", dim(result_ord$ICRP), "\n")
  cat("列名:", paste(colnames(result_ord$ICRP), collapse = ", "), "\n\n")

  # =============================================================
  # 3. ICRPデータの最初の数行を表示
  # =============================================================
  cat("=== ICRP データの内容（最初の20行） ===\n")
  print(head(result_ord$ICRP, 20))
  cat("\n")

  # =============================================================
  # 4. 特定の項目のICRPデータを抽出
  # =============================================================
  cat("=== 項目1のICRPデータ ===\n")
  item1_icrp <- result_ord$ICRP[result_ord$ICRP$ItemLabel == "V1", ]
  print(item1_icrp)
  cat("\n")

  # =============================================================
  # 5. ICRPとICBRの比較
  # =============================================================
  cat("=== ICRPとICBRの比較（項目1） ===\n")
  cat("\n--- ICRP（応答確率） ---\n")
  print(item1_icrp)

  cat("\n--- ICBR（累積確率） ---\n")
  item1_icbr <- result_ord$ICBR[result_ord$ICBR$ItemLabel == "V1", ]
  print(item1_icbr)

  cat("\n--- 各ランクでのICRP合計（1.0になるはず） ---\n")
  rank_cols <- grep("^rank[0-9]+$", colnames(item1_icrp), value = TRUE)
  for (col in rank_cols) {
    total <- sum(item1_icrp[[col]])
    cat(sprintf("%s: %.6f\n", col, total))
  }

  # =============================================================
  # 6. exametrikaの元のプロットを確認
  # =============================================================
  cat("\n=== exametrikaの元のICRPプロット ===\n")
  par(mfrow = c(2, 2))
  plot(result_ord, type = "ICRP", items = 1:4, nc = 2, nr = 2)
  par(mfrow = c(1, 1))

} else {
  cat("ICRP データが見つかりません。\n")
  cat("利用可能なフィールド:", paste(names(result_ord), collapse = ", "), "\n")
}

cat("\n=== 調査完了 ===\n")
