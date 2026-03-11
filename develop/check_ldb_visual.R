# ============================================================
# LDB DAG 描画確認スクリプト
# BNM/LDLRA/LDB の統一感確認用
# 実行: source("develop/check_ldb_visual.R")
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
  gridExtra::grid.arrange(grob)
  ggplot2::ggsave(path, grob, width = width, height = height, dpi = dpi)
  cat("Saved:", path, "\n\n")
}

# ---- データ準備 ----
# BNM: 項目ノード
bnm_dag <- igraph::graph_from_data_frame(
  data.frame(from = c("Item01", "Item02", "Item03"),
             to   = c("Item02", "Item03", "Item04")),
  directed = TRUE
)
result_bnm <- BNM(J5S10, g = bnm_dag)

# LDLRA: 項目ノード（ランクごと）
ldlra_dag <- data.frame(
  from = c("Item01", "Item02", "Item03", "Item04"),
  to   = c("Item02", "Item03", "Item04", "Item05")
)
ldlra_g <- igraph::graph_from_data_frame(ldlra_dag, directed = TRUE)
result_ldlra <- LDLRA(J12S5000, ncls = 3, g = list(ldlra_g, ldlra_g, ldlra_g))

# LDB: フィールドノード（本物）
ldb_conf <- rep(1:3, length.out = 35)
ldb_g <- igraph::graph_from_data_frame(
  data.frame(from = c("Field01", "Field02"),
             to   = c("Field02", "Field03")),
  directed = TRUE
)
result_ldb <- LDB(J35S515, ncls = 3, conf = ldb_conf,
                  g_list = list(ldb_g, ldb_g, ldb_g))

# ============================================================
cat("=== 1. BNM vs LDLRA vs LDB 比較（統一感確認） ===\n")
# ============================================================
p_bnm    <- plotGraph_gg(result_bnm,   direction = "LR", title = "BNM (Item)")[[1]]
p_ldlra  <- plotGraph_gg(result_ldlra, direction = "LR", title = "LDLRA (Item)")[[1]]
p_ldb    <- plotGraph_gg(result_ldb,   direction = "LR", title = "LDB (Field)")[[1]]
p_compare <- gridExtra::arrangeGrob(
  p_bnm, p_ldlra, p_ldb, ncol = 3,
  top = "BNM (purple circle) vs LDLRA (purple circle) vs LDB (green diamond)"
)
.show_and_save(p_compare, "develop/visual_ldb_compare.png", width = 18, height = 6)

# ============================================================
cat("=== 2. LDB: 全ランク (LR方向) ===\n")
# ============================================================
plots_lr <- plotGraph_gg(result_ldb, direction = "LR")
p2 <- gridExtra::arrangeGrob(grobs = plots_lr, ncol = 3,
                              top = "LDB - direction=LR")
.show_and_save(p2, "develop/visual_ldb_LR.png", width = 15, height = 6)

# ============================================================
cat("=== 3. LDB: 共通オプション確認 ===\n")
# ============================================================
p_default <- plotGraph_gg(result_ldb, direction = "LR",
                           title = TRUE)[[1]] +
  ggplot2::labs(subtitle = "title=TRUE (auto)")

p_custom_color <- plotGraph_gg(result_ldb, direction = "LR",
                                colors = "#FF5722",
                                title = "Custom Color")[[1]] +
  ggplot2::labs(subtitle = "colors='#FF5722'")

p_no_title <- plotGraph_gg(result_ldb, direction = "LR",
                            title = FALSE)[[1]] +
  ggplot2::labs(subtitle = "title=FALSE")

p_legend <- plotGraph_gg(result_ldb, direction = "LR",
                          show_legend = TRUE,
                          legend_position = "bottom")[[1]] +
  ggplot2::labs(subtitle = "show_legend=TRUE")

p_opts <- gridExtra::arrangeGrob(
  p_default, p_custom_color, p_no_title, p_legend,
  ncol = 2, top = "Common options check (LDB Rank 1)"
)
.show_and_save(p_opts, "develop/visual_ldb_options.png", width = 12, height = 10)

# ============================================================
cat("=== 4. 4方向すべて確認 ===\n")
# ============================================================
dirs <- c("BT", "TB", "LR", "RL")
p_dirs <- lapply(dirs, function(d) {
  plotGraph_gg(result_ldb, direction = d,
               title = paste0("direction='", d, "'"))[[1]]
})
p_4dir <- gridExtra::arrangeGrob(grobs = p_dirs, ncol = 2,
                                  top = "LDB Rank 1 - all directions")
.show_and_save(p_4dir, "develop/visual_ldb_directions.png", width = 12, height = 10)

# ============================================================
cat("=== 完了 ===\n")
cat("生成ファイル:\n")
cat("  develop/visual_ldb_compare.png    - BNM vs LDLRA vs LDB 比較\n")
cat("  develop/visual_ldb_LR.png         - 全ランク (LR方向)\n")
cat("  develop/visual_ldb_options.png    - 共通オプション確認\n")
cat("  develop/visual_ldb_directions.png - 4方向確認\n")
cat("\n")
cat("確認ポイント:\n")
cat("  - BNM/LDLRA: 紫丸（Item）\n")
cat("  - LDB: 緑ダイヤ（Field）\n")
cat("  - ノード形状とカラーが正しく区別されているか\n")
cat("  - レイアウト・矢印・テキストの統一感\n")
