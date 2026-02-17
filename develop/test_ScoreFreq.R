# =============================================================
# plotScoreFreq_gg テストスクリプト
# =============================================================

library(exametrika)
devtools::load_all(".")

# --- データ準備 ---
# J15S3810: 15項目×3810人の ordinal データ（4カテゴリ）
result_ord <- exametrika::LRA(J15S3810, nrank = 4, dataType = "ordinal")
result_rated <- exametrika::LRA(J15S3810, nrank = 4, dataType = "rated")

# =============================================================
# 1. 基本動作の確認
# =============================================================

# LRAordinal: デフォルト設定
p_ord <- plotScoreFreq_gg(result_ord)
print(p_ord)

# LRArated: デフォルト設定
p_rated <- plotScoreFreq_gg(result_rated)
print(p_rated)

# =============================================================
# 2. title オプションの確認
# =============================================================

# title = TRUE（デフォルト: 自動タイトル「Score Frequency Distribution」）
p_title_true <- plotScoreFreq_gg(result_ord, title = TRUE)
print(p_title_true)

# title = FALSE（タイトル非表示）
p_title_false <- plotScoreFreq_gg(result_ord, title = FALSE)
print(p_title_false)

# title = 文字列（カスタムタイトル）
p_title_custom <- plotScoreFreq_gg(result_ord, title = "スコア分布（4ランクモデル）")
print(p_title_custom)

# =============================================================
# 3. colors オプションの確認
# =============================================================

# colors = NULL（デフォルトパレット: teal + orange）
p_colors_default <- plotScoreFreq_gg(result_ord)
print(p_colors_default)

# colors = カスタム（密度曲線=青, 閾値線=赤）
p_colors_custom <- plotScoreFreq_gg(result_ord, colors = c("blue", "red"))
print(p_colors_custom)

# colors = 同じ色で統一
p_colors_same <- plotScoreFreq_gg(result_ord, colors = c("black", "black"))
print(p_colors_same)

# =============================================================
# 4. linetype オプションの確認
# =============================================================

# デフォルト: c("solid", "dashed")
p_line_default <- plotScoreFreq_gg(result_ord)
print(p_line_default)

# 両方 solid
p_line_solid <- plotScoreFreq_gg(result_ord, linetype = c("solid", "solid"))
print(p_line_solid)

# 密度曲線=dashed, 閾値=dotted
p_line_custom <- plotScoreFreq_gg(result_ord, linetype = c("dashed", "dotted"))
print(p_line_custom)

# 単一値（密度曲線に適用、閾値はデフォルトdashed）
p_line_single <- plotScoreFreq_gg(result_ord, linetype = "dotdash")
print(p_line_single)

# =============================================================
# 5. show_legend / legend_position オプションの確認
# =============================================================

# show_legend = FALSE（デフォルト: 凡例非表示）
p_nolegend <- plotScoreFreq_gg(result_ord, show_legend = FALSE)
print(p_nolegend)

# show_legend = TRUE
p_legend <- plotScoreFreq_gg(result_ord, show_legend = TRUE)
print(p_legend)

# legend_position = "bottom"
p_legend_bottom <- plotScoreFreq_gg(result_ord, show_legend = TRUE, legend_position = "bottom")
print(p_legend_bottom)

# =============================================================
# 6. ggplot2 の追加カスタマイズとの互換性確認
# =============================================================

p_custom <- plotScoreFreq_gg(result_ord) +
  ggplot2::theme_minimal() +
  ggplot2::theme(
    plot.title = ggplot2::element_text(face = "bold", size = 14)
  )
print(p_custom)

# =============================================================
# 7. combinePlots_gg との連携確認
# =============================================================

p1 <- plotScoreFreq_gg(result_ord, title = "Ordinal")
p2 <- plotScoreFreq_gg(result_rated, title = "Rated")
combinePlots_gg(list(p1, p2))

# =============================================================
# 8. エラーハンドリングの確認
# =============================================================

# IRT の結果を渡すとエラーになることを確認
irt_result <- exametrika::IRT(J15S500, model = 2)
tryCatch(
  plotScoreFreq_gg(irt_result),
  error = function(e) cat("期待通りのエラー（IRT入力）:", e$message, "\n")
)

# Biclustering の結果を渡すとエラー
bicl_result <- exametrika::Biclustering(J35S515, nfld = 5, ncls = 6)
tryCatch(
  plotScoreFreq_gg(bicl_result),
  error = function(e) cat("期待通りのエラー（Biclustering入力）:", e$message, "\n")
)

cat("\n=== 全テスト完了 ===\n")
