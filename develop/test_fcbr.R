# FCBR (Field Cumulative Boundary Reference) テストスクリプト
# ordinalBiclustering用のFCBRプロットをテスト

# パッケージ読み込み
if (!require("exametrika", quietly = TRUE)) {
  cat("WARNING: exametrika package not found. Loading from source...\n")
  devtools::load_all("../exametrika")
} else {
  library(exametrika)
}
devtools::load_all()

# サンプルデータでordinal Biclusteringを実行
data(J15S3810)
result <- Biclustering(J15S3810, ncls = 4, nfld = 3,
                       dataType = "ordinal", verbose = FALSE)

cat("=== Data structure ===\n")
cat("Fields:", dim(result$FRP)[1], "\n")
cat("Classes:", dim(result$FRP)[2], "\n")
cat("Categories:", dim(result$FRP)[3], "\n\n")

# 境界確率の詳細を確認
BCRM <- result$FRP
maxQ <- dim(BCRM)[3]
n_boundaries <- maxQ

cat("=== Boundary probabilities (Field 1) ===\n")
for (b in 1:n_boundaries) {
  cat(sprintf("P(Q>=%d):", b))
  for (cc in 1:dim(BCRM)[2]) {
    prob <- sum(BCRM[1, cc, b:maxQ])
    cat(sprintf(" C%d=%.3f", cc, prob))
  }
  cat("\n")
}

# FCBRプロットのテスト
cat("\n=== Test 1: All fields ===\n")
plot1 <- plotFCBR_gg(result)
print(plot1)

cat("\n=== Test 2: Selected fields (1-2) ===\n")
plot2 <- plotFCBR_gg(result, fields = 1:2)
print(plot2)

cat("\n=== Test 3: Custom options ===\n")
plot3 <- plotFCBR_gg(result,
                     fields = 1:3,
                     title = "FCBR Test",
                     show_legend = TRUE,
                     legend_position = "bottom")
print(plot3)

cat("\n=== All tests completed ===\n")
