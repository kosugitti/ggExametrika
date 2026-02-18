# FCBR (Field Cumulative Boundary Reference) ビジュアルテスト
# 画像ファイルとして保存して比較

if (!require("exametrika", quietly = TRUE)) {
  devtools::load_all("../exametrika")
} else {
  library(exametrika)
}

# サンプルデータ
data(J15S3810)
result <- Biclustering(J15S3810, ncls = 4, nfld = 3,
                       dataType = "ordinal", verbose = FALSE)

# ggExametrikaのFCBRプロットを保存
devtools::load_all()
library(ggplot2)

cat("=== Saving ggExametrika FCBR plot ===\n")
plot_gg <- plotFCBR_gg(result)
ggsave("fcbr_ggexametrika.png", plot_gg, width = 12, height = 4, dpi = 100)

cat("ggExametrika FCBR plot saved to: fcbr_ggexametrika.png\n")

# 境界数の確認
BCRM <- result$FRP
maxQ <- dim(BCRM)[3]

cat("\n=== Boundary details ===\n")
cat(paste("Categories:", maxQ, "\n"))
cat(paste("Number of boundaries displayed:", maxQ, "\n"))
cat(paste("Boundaries: P(Q>=1) to P(Q>=", maxQ, ")\n", sep=""))
cat("Note: P(Q>=1) is always 1.0 (horizontal line at top)\n")
