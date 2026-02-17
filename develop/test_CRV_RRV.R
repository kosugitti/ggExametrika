# =============================================================
# plotCRV_gg / plotRRV_gg テストスクリプト
# =============================================================

library(exametrika)
devtools::load_all(".")

# --- データ準備 ---
result <- exametrika::Biclustering(J35S515, nfld = 5, ncls = 6)

# =============================================================
# 1. 基本動作の確認
# =============================================================

# CRV: デフォルト設定
p_crv <- plotCRV_gg(result)
print(p_crv)

# RRV: デフォルト設定
p_rrv <- plotRRV_gg(result)
print(p_rrv)

# =============================================================
# 2. title オプションの確認
# =============================================================

# title = TRUE（デフォルト: 自動タイトル）
p_title_true <- plotCRV_gg(result, title = TRUE)
print(p_title_true)

# title = FALSE（タイトル非表示）
p_title_false <- plotCRV_gg(result, title = FALSE)
print(p_title_false)

# title = 文字列（カスタムタイトル）
p_title_custom <- plotCRV_gg(result, title = "カスタムタイトルのテスト")
print(p_title_custom)

# =============================================================
# 3. colors オプションの確認
# =============================================================

# colors = NULL（デフォルトパレット）
p_colors_default <- plotRRV_gg(result)
print(p_colors_default)

# colors = カスタムカラー
p_colors_custom <- plotRRV_gg(
  result,
  colors = c("red", "blue", "green", "orange", "purple", "brown")
)
print(p_colors_custom)

# =============================================================
# 4. linetype オプションの確認
# =============================================================

# linetype = "solid"（デフォルト）
p_line_solid <- plotCRV_gg(result, linetype = "solid")
print(p_line_solid)

# linetype = "dashed"
p_line_dashed <- plotCRV_gg(result, linetype = "dashed")
print(p_line_dashed)

# linetype = "dotted"
p_line_dotted <- plotCRV_gg(result, linetype = "dotted")
print(p_line_dotted)

# =============================================================
# 5. show_legend / legend_position オプションの確認
# =============================================================

# show_legend = TRUE, legend_position = "right"（デフォルト）
p_legend_right <- plotRRV_gg(result, show_legend = TRUE, legend_position = "right")
print(p_legend_right)

# show_legend = TRUE, legend_position = "bottom"
p_legend_bottom <- plotRRV_gg(result, legend_position = "bottom")
print(p_legend_bottom)

# show_legend = TRUE, legend_position = "top"
p_legend_top <- plotRRV_gg(result, legend_position = "top")
print(p_legend_top)

# show_legend = FALSE（凡例非表示）
p_legend_none <- plotRRV_gg(result, show_legend = FALSE)
print(p_legend_none)

# =============================================================
# 6. combinePlots_gg との連携確認
# =============================================================

p1 <- plotCRV_gg(result, title = "CRV")
p2 <- plotRRV_gg(result, title = "RRV")
combinePlots_gg(list(p1, p2))

# =============================================================
# 7. ggplot2 の追加カスタマイズとの互換性確認
# =============================================================

p_custom <- plotCRV_gg(result) +
  ggplot2::theme_minimal() +
  ggplot2::theme(
    plot.title = ggplot2::element_text(face = "bold", size = 14),
    axis.text.x = ggplot2::element_text(angle = 45, hjust = 1)
  )
print(p_custom)

# =============================================================
# 8. エラーハンドリングの確認
# =============================================================

# IRT の結果を渡すとエラーになることを確認
irt_result <- exametrika::IRT(J15S500, model = 2)
tryCatch(
  plotCRV_gg(irt_result),
  error = function(e) cat("期待通りのエラー（CRV に IRT）:", e$message, "\n")
)

tryCatch(
  plotRRV_gg(irt_result),
  error = function(e) cat("期待通りのエラー（RRV に IRT）:", e$message, "\n")
)

cat("\n=== 全テスト完了 ===\n")
