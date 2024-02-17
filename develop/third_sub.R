library(ggplot2)
library(Exametrika)
library(gridExtra)

result.Ranklusteing


result.LCA <- LCA(J15S500, ncls =5)

head(result.LCA$Students)

plot(result.Ranklusteing, type = "Array")

result.Ranklusteing$testlength

result.Ranklusteing$nobs

result.Ranklusteing$SOACflg

result.Ranklusteing$U

# ヒートMapでやってみる

# library(ggplot2)
# data <- matrix(rnorm(100), ncol = 5)
# colnames(data) <- c("A", "B", "C", "D", "E")
# rownames(data) <- paste0("gene", 1:nrow(data))
# head(data)
#
# dev.new()
# clr <- heatmap(data, scale = "none")
# dev.off()
#
# gene.idx  <- rownames(data)[clr$rowInd]
# group.idx <- colnames(data)[clr$colInd]
#
# df$Gene  <- factor(df$Gene, levels = gene.idx)
# df$Group <- factor(df$Group, levels = group.idx)
#
# ghm <- ggplot(df, aes(x = Group, y = Gene, fill = Value))
# ghm <- ghm + geom_tile()
# ghm <- ghm + theme_bw()
# ghm <- ghm + theme(plot.background = element_blank(),
#                    panel.grid.minor = element_blank(),
#                    panel.grid.major = element_blank(),
#                    panel.background = element_blank(),
#                    axis.line = element_blank(),
#                    axis.ticks = element_blank(),
#                    strip.background = element_rect(fill = "white", colour = "white"),
#                    axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))
# ghm <- ghm + scale_fill_gradientn("value", colours = rev(brewer.pal(9, "Spectral")), na.value = "white")
# ghm <- ghm + xlab("Group") + ylab("Gene")
# ghm

# 使い方がわからぬ

length(result.Ranklusteing$U)

row <- NULL

for (i in 1:length(result.Ranklusteing$U)) {

    row <-

        }


data

data <- as.data.frame(result.Ranklusteing$U)

data <- c()

ggplot(data,aes(x = )) +
    geom_tile()

