# =============================================================
# plotICBR_gg テストスクリプト
# =============================================================

library(exametrika)
devtools::load_all(".")

# --- データ準備 ---
# J15S3810: 15項目×3810人の ordinal データ（4カテゴリ）
result_ord <- exametrika::LRA(J15S3810, nrank = 4, dataType = "ordinal")

# =============================================================
# 1. 基本動作の確認
# =============================================================

cat("=== 1. 基本動作の確認 ===\n")

# デフォルト設定：最初の4項目
p1 <- plotICBR_gg(result_ord, items = 1:4)
print(p1)

# 全項目
p_all <- plotICBR_gg(result_ord)
print(p_all)

# 単一項目
p_single <- plotICBR_gg(result_ord, items = 1)
print(p_single)

# =============================================================
# 2. title オプションの確認
# =============================================================

cat("\n=== 2. title オプションの確認 ===\n")

# title = TRUE（デフォルト: 自動タイトル）
p_title_true <- plotICBR_gg(result_ord, items = 1:4, title = TRUE)
print(p_title_true)

# title = FALSE（タイトル非表示）
p_title_false <- plotICBR_gg(result_ord, items = 1:4, title = FALSE)
print(p_title_false)

# title = 文字列（カスタムタイトル）
p_title_custom <- plotICBR_gg(result_ord, items = 1:4,
                               title = "カテゴリ境界応答プロファイル（4ランクモデル）")
print(p_title_custom)

# =============================================================
# 3. colors オプションの確認
# =============================================================

cat("\n=== 3. colors オプションの確認 ===\n")

# colors = NULL（デフォルトパレット）
p_colors_default <- plotICBR_gg(result_ord, items = 1:2)
print(p_colors_default)

# colors = カスタム
p_colors_custom <- plotICBR_gg(result_ord, items = 1:2,
                                colors = c("red", "blue", "green", "purple"))
print(p_colors_custom)

# =============================================================
# 4. linetype オプションの確認
# =============================================================

cat("\n=== 4. linetype オプションの確認 ===\n")

# デフォルト: 自動割り当て
p_line_default <- plotICBR_gg(result_ord, items = 1:2)
print(p_line_default)

# 全てsolid
p_line_solid <- plotICBR_gg(result_ord, items = 1:2,
                            linetype = c("solid", "solid", "solid", "solid"))
print(p_line_solid)

# カスタム
p_line_custom <- plotICBR_gg(result_ord, items = 1:2,
                             linetype = c("solid", "dashed", "dotted", "dotdash"))
print(p_line_custom)

# =============================================================
# 5. show_legend / legend_position オプションの確認
# =============================================================

cat("\n=== 5. show_legend / legend_position オプションの確認 ===\n")

# show_legend = TRUE（デフォルト）
p_legend <- plotICBR_gg(result_ord, items = 1:4, show_legend = TRUE)
print(p_legend)

# show_legend = FALSE
p_nolegend <- plotICBR_gg(result_ord, items = 1:4, show_legend = FALSE)
print(p_nolegend)

# legend_position = "bottom"
p_legend_bottom <- plotICBR_gg(result_ord, items = 1:4,
                                show_legend = TRUE, legend_position = "bottom")
print(p_legend_bottom)

# legend_position = "top"
p_legend_top <- plotICBR_gg(result_ord, items = 1:4,
                            show_legend = TRUE, legend_position = "top")
print(p_legend_top)

# =============================================================
# 6. ggplot2 の追加カスタマイズとの互換性確認
# =============================================================

cat("\n=== 6. ggplot2 の追加カスタマイズとの互換性確認 ===\n")

p_custom <- plotICBR_gg(result_ord, items = 1:4) +
  ggplot2::theme_bw() +
  ggplot2::theme(
    plot.title = ggplot2::element_text(face = "bold", size = 14),
    strip.background = ggplot2::element_rect(fill = "lightblue")
  )
print(p_custom)

# =============================================================
# 7. 項目選択のバリエーション
# =============================================================

cat("\n=== 7. 項目選択のバリエーション ===\n")

# 連続した項目
p_seq <- plotICBR_gg(result_ord, items = 5:8)
print(p_seq)

# 飛び飛びの項目
p_skip <- plotICBR_gg(result_ord, items = c(1, 3, 5, 7))
print(p_skip)

# =============================================================
# 8. エラーハンドリングの確認
# =============================================================

cat("\n=== 8. エラーハンドリングの確認 ===\n")

# LRArated（ordinalではない）を渡すとエラー
result_rated <- exametrika::LRA(J15S3810, nrank = 4, dataType = "rated")
tryCatch(
  plotICBR_gg(result_rated),
  error = function(e) cat("期待通りのエラー（LRArated入力）:", e$message, "\n")
)

# IRTの結果を渡すとエラー
irt_result <- exametrika::IRT(J15S500, model = 2)
tryCatch(
  plotICBR_gg(irt_result),
  error = function(e) cat("期待通りのエラー（IRT入力）:", e$message, "\n")
)

# Biclusteringの結果を渡すとエラー
bicl_result <- exametrika::Biclustering(J35S515, nfld = 5, ncls = 6)
tryCatch(
  plotICBR_gg(bicl_result),
  error = function(e) cat("期待通りのエラー（Biclustering入力）:", e$message, "\n")
)

# =============================================================
# 9. 元のexametrikaとの比較
# =============================================================

cat("\n=== 9. 元のexametrikaとの比較 ===\n")

# exametrikaの元のプロット
par(mfrow = c(2, 2))
plot(result_ord, type = "ICBR", items = 1:4, nc = 2, nr = 2)
par(mfrow = c(1, 1))

# ggExametrikaのプロット
p_compare <- plotICBR_gg(result_ord, items = 1:4)
print(p_compare)

cat("\n=== 全テスト完了 ===\n")
