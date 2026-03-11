# ============================================================
# LDLRA DAG 描画確認スクリプト
# リファクタリング後の視覚確認用
# 実行: source("develop/check_ldlra_visual.R")
# ※ RStudioのPlotsパネルにも逐次表示されます
# ============================================================

# exametrika: ローカルソースがあればそちらを、なければインストール済みを使う
if (file.exists("../exametrika/DESCRIPTION")) {
  devtools::load_all("../exametrika", quiet = TRUE)
} else {
  library(exametrika)
}
devtools::load_all(".", quiet = TRUE)

# 表示 & 保存を同時に行うヘルパー
.show_and_save <- function(grob, path, width, height, dpi = 120) {
  gridExtra::grid.arrange(grob)           # RStudioのPlotsパネルに表示
  ggplot2::ggsave(path, grob, width = width, height = height, dpi = dpi)
  cat("Saved:", path, "\n\n")
}

# ---- データ準備 ----
dag <- data.frame(
  from = c("Item01", "Item02", "Item03", "Item04"),
  to   = c("Item02", "Item03", "Item04", "Item05")
)
g <- igraph::graph_from_data_frame(dag, directed = TRUE)
result_ldlra <- exametrika::LDLRA(exametrika::J12S5000, ncls = 3,
                                   g = list(g, g, g))

bnm_dag <- igraph::graph_from_data_frame(dag[1:3, ])
result_bnm <- exametrika::BNM(exametrika::J5S10, g = bnm_dag)

# ============================================================
cat("=== 1. LDLRA: デフォルト（全ランク、BT方向） ===\n")
# ============================================================
plots_bt <- plotGraph_gg(result_ldlra)
p1 <- gridExtra::arrangeGrob(grobs = plots_bt, ncol = 3,
                              top = "LDLRA - direction=BT (default)")
.show_and_save(p1, "develop/visual_ldlra_BT.png", width = 15, height = 6)

# ============================================================
cat("=== 2. LDLRA: LR方向 ===\n")
# ============================================================
plots_lr <- plotGraph_gg(result_ldlra, direction = "LR")
p2 <- gridExtra::arrangeGrob(grobs = plots_lr, ncol = 3,
                              top = "LDLRA - direction=LR")
.show_and_save(p2, "develop/visual_ldlra_LR.png", width = 15, height = 6)

# ============================================================
cat("=== 3. BNM vs LDLRA 比較（同じDAG構造で並べて表示） ===\n")
# ============================================================
p_bnm    <- plotGraph_gg(result_bnm,   direction = "LR", title = "BNM")[[1]]
p_ldlra1 <- plotGraph_gg(result_ldlra, direction = "LR")[[1]]  # Rank 1
p_compare <- gridExtra::arrangeGrob(p_bnm, p_ldlra1, ncol = 2,
                                    top = "BNM (left) vs LDLRA Rank1 (right)")
.show_and_save(p_compare, "develop/visual_bnm_vs_ldlra.png", width = 12, height = 6)

# ============================================================
cat("=== 4. 共通オプション確認（colors / title / legend） ===\n")
# ============================================================
p_default <- plotGraph_gg(result_ldlra, direction = "LR",
                           title = TRUE)[[1]] +
  ggplot2::labs(subtitle = "title=TRUE (auto)")

p_custom_color <- plotGraph_gg(result_ldlra, direction = "LR",
                                colors = "#2196F3",
                                title = "Custom Color")[[1]] +
  ggplot2::labs(subtitle = "colors='#2196F3'")

p_no_title <- plotGraph_gg(result_ldlra, direction = "LR",
                            title = FALSE)[[1]] +
  ggplot2::labs(subtitle = "title=FALSE")

p_legend <- plotGraph_gg(result_ldlra, direction = "LR",
                          show_legend = TRUE,
                          legend_position = "bottom")[[1]] +
  ggplot2::labs(subtitle = "show_legend=TRUE")

p_opts <- gridExtra::arrangeGrob(
  p_default, p_custom_color, p_no_title, p_legend,
  ncol = 2, top = "Common options check (LDLRA Rank 1)"
)
.show_and_save(p_opts, "develop/visual_ldlra_options.png", width = 12, height = 10)

# ============================================================
cat("=== 5. 4方向すべて確認 ===\n")
# ============================================================
dirs <- c("BT", "TB", "LR", "RL")
p_dirs <- lapply(dirs, function(d) {
  plotGraph_gg(result_ldlra, direction = d,
               title = paste0("direction='", d, "'"))[[1]]
})
p_4dir <- gridExtra::arrangeGrob(grobs = p_dirs, ncol = 2,
                                  top = "LDLRA Rank 1 - all directions")
.show_and_save(p_4dir, "develop/visual_ldlra_directions.png", width = 12, height = 10)

# ============================================================
cat("=== 完了 ===\n")
cat("生成ファイル:\n")
cat("  develop/visual_ldlra_BT.png         - 全ランク (BT方向)\n")
cat("  develop/visual_ldlra_LR.png         - 全ランク (LR方向)\n")
cat("  develop/visual_bnm_vs_ldlra.png     - BNM vs LDLRA 比較\n")
cat("  develop/visual_ldlra_options.png    - 共通オプション確認\n")
cat("  develop/visual_ldlra_directions.png - 4方向確認\n")
