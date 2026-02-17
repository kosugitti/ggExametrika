# GRM Item Category Response Function のサンプルコード
devtools::load_all(".")
library(exametrika)

# GRMの実行
result <- GRM(J5S1000)

# 全アイテムのICRFプロット
plots <- plotICRF_gg(result)
plots[[1]] # 1つ目のアイテム
combinePlots_gg(plots, selectPlots = 1:5) # 全5アイテム

# 共通オプションの使用例
# カスタムタイトル、凡例を下に配置
plotICRF_gg(result, items = 1, title = "Custom Title", legend_position = "bottom")

# 凡例非表示
plotICRF_gg(result, items = 1, show_legend = FALSE)
