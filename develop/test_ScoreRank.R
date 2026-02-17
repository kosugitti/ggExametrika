# =============================================================
# plotScoreRank_gg テストスクリプト
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
p_ord <- plotScoreRank_gg(result_ord)
print(p_ord)

# LRArated: デフォルト設定
p_rated <- plotScoreRank_gg(result_rated)
print(p_rated)

# =============================================================
# 2. title オプションの確認
# =============================================================

# title = TRUE（デフォルト: 自動タイトル「Score-Rank Distribution」）
p_title_true <- plotScoreRank_gg(result_ord, title = TRUE)
print(p_title_true)

# title = FALSE（タイトル非表示）
p_title_false <- plotScoreRank_gg(result_ord, title = FALSE)
print(p_title_false)

# title = 文字列（カスタムタイトル）
p_title_custom <- plotScoreRank_gg(result_ord, title = "スコア-ランク分布（4ランクモデル）")
print(p_title_custom)

# =============================================================
# 3. colors オプションの確認
# =============================================================

# colors = NULL（デフォルト: 白→黒のグレースケール）
p_colors_default <- plotScoreRank_gg(result_ord)
print(p_colors_default)

# colors = カスタム（白→青のグラデーション）
p_colors_blue <- plotScoreRank_gg(result_ord, colors = c("white", "darkblue"))
print(p_colors_blue)

# colors = 白→赤
p_colors_red <- plotScoreRank_gg(result_ord, colors = c("lightyellow", "darkred"))
print(p_colors_red)

# colors = 緑系
p_colors_green <- plotScoreRank_gg(result_ord, colors = c("white", "darkgreen"))
print(p_colors_green)

# =============================================================
# 4. show_legend / legend_position オプションの確認
# =============================================================

# show_legend = TRUE, legend_position = "right"（デフォルト）
p_legend_right <- plotScoreRank_gg(result_ord, show_legend = TRUE, legend_position = "right")
print(p_legend_right)

# show_legend = TRUE, legend_position = "bottom"
p_legend_bottom <- plotScoreRank_gg(result_ord, legend_position = "bottom")
print(p_legend_bottom)

# show_legend = TRUE, legend_position = "top"
p_legend_top <- plotScoreRank_gg(result_ord, legend_position = "top")
print(p_legend_top)

# show_legend = FALSE（凡例非表示）
p_legend_none <- plotScoreRank_gg(result_ord, show_legend = FALSE)
print(p_legend_none)

# =============================================================
# 5. ggplot2 の追加カスタマイズとの互換性確認
# =============================================================

p_custom <- plotScoreRank_gg(result_ord) +
  ggplot2::theme_minimal() +
  ggplot2::theme(
    plot.title = ggplot2::element_text(face = "bold", size = 14)
  )
print(p_custom)

# viridis カラースケールへの変更
p_viridis <- plotScoreRank_gg(result_ord, show_legend = TRUE) +
  ggplot2::scale_fill_viridis_c(option = "plasma")
print(p_viridis)

# =============================================================
# 6. combinePlots_gg との連携確認
# =============================================================

p1 <- plotScoreRank_gg(result_ord, title = "Ordinal", show_legend = FALSE)
p2 <- plotScoreRank_gg(result_rated, title = "Rated", show_legend = FALSE)
combinePlots_gg(list(p1, p2))

# =============================================================
# 7. エラーハンドリングの確認
# =============================================================

# IRT の結果を渡すとエラーになることを確認
irt_result <- exametrika::IRT(J15S500, model = 2)
tryCatch(
  plotScoreRank_gg(irt_result),
  error = function(e) cat("期待通りのエラー（IRT入力）:", e$message, "\n")
)

# Biclustering の結果を渡すとエラー
bicl_result <- exametrika::Biclustering(J35S515, nfld = 5, ncls = 6)
tryCatch(
  plotScoreRank_gg(bicl_result),
  error = function(e) cat("期待通りのエラー（Biclustering入力）:", e$message, "\n")
)

cat("\n=== 全テスト完了 ===\n")
