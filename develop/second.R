library(ggplot2)
library(Exametrika)
library(gridExtra)



LCA(J15S500, ncls = 4)

result.LCA <- LCA(J15S500, ncls =5)

head(result.LCA$Students)

plot(result.LCA, type = "IRP", items = 1:6, nc = 2, nr = 3)

plot(result.LCA, type = "CMP", students = 1:9, nc = 3, nr = 3)

plot(result.LCA, type = "TRP")

plot(result.LCA, type = "LCD")

plotIRP_gg <- function(data) {
    if (all(class(data) %in% c("Exametrika", "LCA"))) {
        xlabel <- "Latent Class"
    } else if (all(class(data) %in% c("Exametrika", "LRA"))||all(class(data) %in% c("Exametrika", "LDLRA"))){
        xlabel <- "Latent Rank"
    } else {
        stop("Invalid input. The variable must be from Exametrika output or an output from LCA, LRA, Biclustering, or LDLRA.")
    }


    n_cls <- ncol(data$IRP)

    if (n_cls < 2 || n_cls > 20) {
        stop("Invalid number of classes or Ranks")
    }

    plots <- list()

    for (i in 1:nrow(data$IRP)) {

        x <- data.frame(
            CRR = c(data$IRP[i,]),
            rank = c(1:n_cls))

        plots[[i]] <- ggplot(x, aes(x = rank, y = CRR)) +
            ylim(0, 1) +
            geom_point() +
            geom_line(linetype = "dashed" ) +
            scale_x_continuous(breaks = seq(1, n_cls, 1)) +
            labs(
                title = paste0("Item Reference Profile, ", rownames(data$IRP)[i]),
                x = xlabel,
                y = "Correct Response Rate"
            )
    }

    return(plots)
}

plotIRP_gg(result.LDLRA)

a <- plotICC_gg(result.IRT)
a <- plotIRP_gg(result.LCA)
a <- plotIRP_gg(result.LRA)
a <- plotIRP_gg(result.Ranklusteing)
a <- plotIRP_gg(result.LDLRA)

combinePlots_gg(a, selectPlots = c(1:12))

b <- a[1:4]

# 中身の確認
result.LCA$Students

m <- result.LCA$IRP

length(result.LCA$IRP)

ncol(result.LCA$IRP)

length(result.LCA$IRP[1,])

x <- data.frame(
    CRR = c(result.LCA$IRP[1,]),
    rank = c(1:7))

result.LCA$IRP

class(result.LCA)

plots <- ggplot(x, aes(x = rank, y = CRR)) +
    ylim(0, 1) +
    geom_point() +
    geom_line(linetype = "dashed" ) +
    scale_x_continuous(breaks = seq(1,4,1))


plots

plots2 <- ggplot(m, aes(x = point, y = CRR)) +
    ylim(0, 1) +
    geom_point() +
    geom_line() +
    scale_x_continuous(breaks = seq(1,4,1))

plots2

data <- data.frame(
    x = c(1, 2, 3, 4, 5),
    y = c(3, 5, 2, 8, 4)
)

#
# library(ggplot2)
#
# k <- result.LCA$IRP[1,2] - result.LCA$IRP[1,1]
# k * 0.1 + result.LCA$IRP[1,1]
# k * 0.9 + result.LCA$IRP[1,1]
#
# m <- data.frame(
#     point = c(x[1,2]+0.1,x[1,2]+0.9,x[2,2]+0.1,x[2,2]+0.9,x[3,2]+0.1,x[3,2]+0.9),
#     CRR = c((x[2,1] - x[1,1])*0.1 + x[1,1], (x[2,1] - x[1,1])*0.9 + x[1,1],
#             (x[3,1] - x[2,1])*0.1 + x[2,1], (x[3,1] - x[2,1])*0.9 + x[2,1],
#             (x[4,1] - x[3,1])*0.1 + x[3,1], (x[4,1] - x[3,1])*0.9 + x[3,1]
#     )
# )
#
# m
#
# (x[2,1] - x[1,1])*0.1 + x[1,1]
#
# result.LCA$IRP[2,1]
#
#
# library(ggplot2)
#
# # サンプルデータ
# x <- data.frame(
#     IRP = c(0.2, 0.5, 0.8, 0.3),
#     CRR = c(0.1, 0.6, 0.9, 0.4)
# )
#
# # 新しいデータフレームの作成
# m <- data.frame(
#     point = c(x[1, "IRP"] + 0.1, x[1, "IRP"] + 0.9,
#               x[2, "IRP"] + 0.1, x[2, "IRP"] + 0.9,
#               x[3, "IRP"] + 0.1, x[3, "IRP"] + 0.9),
#     CRR = c((x[2, "CRR"] - x[1, "CRR"]) * 0.1 + x[1, "CRR"], (x[2, "CRR"] - x[1, "CRR"]) * 0.9 + x[1, "CRR"],
#             (x[3, "CRR"] - x[2, "CRR"]) * 0.1 + x[2, "CRR"], (x[3, "CRR"] - x[2, "CRR"]) * 0.9 + x[2, "CRR"],
#             (x[4, "CRR"] - x[3, "CRR"]) * 0.1 + x[3, "CRR"], (x[4, "CRR"] - x[3, "CRR"]) * 0.9 + x[3, "CRR"])
# )
#
# # 長い線のみを抽出
# long_lines <- m[m$point %% 1 == 0.1, ]
#
# # ggplot2プロット
# plots2 <- ggplot(m, aes(x = point, y = CRR)) +
#     ylim(0, 1) +
#     geom_point(data = long_lines) +
#     geom_line(data = long_lines)
#
# # プロットを表示
# print(plots2)


# LRAでのIRP作成

result.LRA

result.LRA$IRP

LRA(J15S500, ncls = 6)

plotIRP_gg(result.LRA)

result.LRA <- LRA(J15S500, ncls = 21)
head(result.LRA$Students)

plot(result.LRA, type = "IRP", items = 1:6, nc = 2, nr = 3)

all(class(result.IRT) %in% c("Exametrika", "IRT"))

class(result.IRT)

plot(result.LRA, type = "IRP", items = 1:6, nc = 2, nr = 3)

result.LRA$IRP

# BiclustringでのIRP(保留)
Biclustering(J35S515, nfld = 5, ncls = 6, method = "B")

result.Ranklusteing <- Biclustering(J35S515, nfld = 5, ncls = 6, method = "R")

result.Ranklusteing$FRP

plot(result.Ranklusteing, type = "IRP", items = 1:6, nc = 2, nr = 3)

nrow()

# LDLRAでのIRP
DAG_dat <- matrix(c(
    "From", "To", "Rank",
    "Item01", "Item02", 1,
    "Item04", "Item05", 1,
    "Item01", "Item02", 2,
    "Item02", "Item03", 2,
    "Item04", "Item05", 2,
    "Item08", "Item09", 2,
    "Item08", "Item10", 2,
    "Item09", "Item10", 2,
    "Item08", "Item11", 2,
    "Item01", "Item02", 3,
    "Item02", "Item03", 3,
    "Item04", "Item05", 3,
    "Item08", "Item09", 3,
    "Item08", "Item10", 3,
    "Item09", "Item10", 3,
    "Item08", "Item11", 3,
    "Item02", "Item03", 4,
    "Item04", "Item06", 4,
    "Item04", "Item07", 4,
    "Item05", "Item06", 4,
    "Item05", "Item07", 4,
    "Item08", "Item10", 4,
    "Item08", "Item11", 4,
    "Item09", "Item11", 4,
    "Item02", "Item03", 5,
    "Item04", "Item06", 5,
    "Item04", "Item07", 5,
    "Item05", "Item06", 5,
    "Item05", "Item07", 5,
    "Item09", "Item11", 5,
    "Item10", "Item11", 5,
    "Item10", "Item12", 5
), ncol = 3, byrow = TRUE)

# save csv file
write.csv(DAG_dat, "develop/DAG_file.csv", row.names = FALSE, quote = TRUE)

g_csv <- read.csv("develop/DAG_file.csv")
colnames(g_csv) <- c("From", "To", "Rank")
adj_list <- list()
g_list <- list()
for (i in 1:5) {
    adj_R <- g_csv[g_csv$Rank == i, 1:2]
    g_tmp <- igraph::graph_from_data_frame(adj_R)
    adj_tmp <- igraph::get.adjacency(g_tmp)
    g_list[[i]] <- g_tmp
    adj_list[[i]] <- adj_tmp
}
## Example of graph list
g_list

adj_list

result.LDLRA <- LDLRA(J12S5000,
                      ncls = 5,
                      adj_file = "develop/DAG_file.csv"
)

result.LDLRA$IRP

plot(result.LDLRA, type = "IRP", nc = 4, nr = 3)

class(result.LDLRA)
