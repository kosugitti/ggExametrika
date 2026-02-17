# =============================================================
# ICBR (Item Category Boundary Response) データ構造の調査
# =============================================================

library(exametrika)

# --- データ準備 ---
# J15S3810: 15項目×3810人の ordinal データ（4カテゴリ）
result_ord <- exametrika::LRA(J15S3810, nrank = 4, dataType = "ordinal")

# =============================================================
# 1. ICBRデータの存在確認
# =============================================================
cat("=== ICBR データの存在確認 ===\n")
cat("result_ord$ICBR が存在するか:", "ICBR" %in% names(result_ord), "\n\n")

if ("ICBR" %in% names(result_ord)) {
  # =============================================================
  # 2. ICBRデータの構造
  # =============================================================
  cat("=== ICBR データの構造 ===\n")
  cat("クラス:", class(result_ord$ICBR), "\n")
  cat("次元:", dim(result_ord$ICBR), "\n")
  cat("列名:", paste(colnames(result_ord$ICBR), collapse = ", "), "\n\n")

  # =============================================================
  # 3. ICBRデータの最初の数行を表示
  # =============================================================
  cat("=== ICBR データの内容（最初の20行） ===\n")
  print(head(result_ord$ICBR, 20))
  cat("\n")

  # =============================================================
  # 4. 特定の項目のICBRデータを抽出
  # =============================================================
  cat("=== 項目1のICBRデータ ===\n")
  item1_icbr <- result_ord$ICBR[result_ord$ICBR$ItemLabel == "Item01", ]
  print(item1_icbr)
  cat("\n")

  # =============================================================
  # 5. exametrikaの元のプロットを確認
  # =============================================================
  cat("=== exametrikaの元のICBRプロット ===\n")
  par(mfrow = c(2, 2))
  plot(result_ord, type = "ICBR", items = 1:4, nc = 2, nr = 2)
  par(mfrow = c(1, 1))

  # =============================================================
  # 6. データ構造の詳細分析
  # =============================================================
  cat("=== データの詳細 ===\n")
  cat("ランク数:", result_ord$Nrank, "\n")
  cat("項目数:", nrow(result_ord$U), "\n")
  cat("項目ラベル:", paste(result_ord$U$ItemLabel[1:5], collapse = ", "), "...\n")

  # 各項目のカテゴリ数を確認
  cat("\n各項目のICBR行数（カテゴリ数に対応）:\n")
  for (item in unique(result_ord$ICBR$ItemLabel)[1:5]) {
    n_rows <- sum(result_ord$ICBR$ItemLabel == item)
    cat(sprintf("  %s: %d行\n", item, n_rows))
  }

} else {
  cat("ICBR データが見つかりません。\n")
  cat("利用可能なフィールド:", paste(names(result_ord), collapse = ", "), "\n")
}

cat("\n=== 調査完了 ===\n")
