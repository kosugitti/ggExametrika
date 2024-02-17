library(ggplot2)
library(Exametrika)
library(gridExtra)

result.Ranklusteing$U

ncol(result.Ranklusteing$U)
nrow(result.Ranklusteing$U)

itemn <- NULL

for (i in 1:ncol(result.Ranklusteing$U)) {

    itemn <- c(itemn, rep(i,nrow(result.Ranklusteing$U)))

}



rown <- rep(1:nrow(result.Ranklusteing$U),ncol(result.Ranklusteing$U))

rown

bw <- c(!(result.Ranklusteing$U))


data <- cbind(itemn, rown, bw)

data <- as.data.frame(data)

ggplot(data, aes(x = itemn, y = rown, fill = bw)) +
    geom_tile() +
    scale_fill_gradient2(low = "black", high = "white", mid = "black",
                         midpoint = 0, limit = c(-1, 1),
                         name = "Rho", space = "Lab")

bw


# sortしたバージョン
x <- result.Ranklusteing

sorted <- x$U[, order(x$FieldEstimated, decreasing = FALSE)]
sorted <- sorted[order(x$ClassEstimated, decreasing = TRUE), ]

itemn <- NULL

for (i in 1:ncol(result.Ranklusteing$U)) {

    itemn <- c(itemn, rep(i,nrow(result.Ranklusteing$U)))

}



rown <- rep(1:nrow(result.Ranklusteing$U),ncol(result.Ranklusteing$U))

rown

bw <- c(!(sorted))

bw

data <- cbind(itemn, rown, bw)

data <- as.data.frame(data)

test_plot <- ggplot(data, aes(x = itemn, y = rown, fill = bw)) +
    geom_tile() +
    scale_fill_gradient2(low = "black", high = "white", mid = "black",
                         midpoint = 0, limit = c(-1, 1),
                         name = "Rho", space = "Lab") +
    labs(title = "Original Data") +
    theme(legend.position = "none",
          plot.title = element_text(hjust = 0.5),
          axis.ticks = element_blank(),
          axis.text = element_blank(),
          axis.title = element_blank(),
          axis.line = element_blank(),
          panel.background = element_blank(),
          )

h <- hl[1:result.Ranklusteing$Nclass - 1]
v <- vl[1:result.Ranklusteing$Nfield - 1] + 0.5

test_plot + geom_hline(yintercept = c(nrow(result.Ranklusteing$U) - h), color = "red")
test_plot + geom_vline(xintercept = c(v), color = "red")

v

vl <- cumsum(table(sort(x$FieldEstimated)))
vl

hl <- nobs - cumsum(table(sort(x$ClassEstimated)))
hl

result.Ranklusteing$Nclass - 1

stepx <- 300 / x$testlength
stepy <- 600 / x$nobs

vl <- cumsum(table(sort(x$FieldEstimated)))

vl

for (i in 1:(x$Nfield - 1)) {
    lines(x = c(vl[i] * stepx, vl[i] * stepx), y = c(0, 600), col = "red")
}
hl <- cumsum(table(sort(x$ClassEstimated)))
for (j in 1:(x$Nclass - 1)) {
    lines(x = c(0, 300), y = c(hl[j] * stepy, hl[j] * stepy), col = "red")
}

515 - hl



result.Ranklusteing$nobs

result.Ranklusteing$FieldMembership

sorted

c(sorted)

data

result.Ranklusteing$ClassMembership
plot(result.BNM, type = "Array")


plotArray_gg <- function(data,
                       Original = TRUE,
                       Clusterd = TRUE,
                       Clusterd_lines = TRUE,
                       title = TRUE) {
    if (all(class(data) %in% c("Exametrika", "Biclustering")) ||
        all(class(data) %in% c("Exametrika", "IRM")) ||
        all(class(data) %in% c("Exametrika", "LDB")) ||
        all(class(data) %in% c("Exametrika", "BINET"))) {

    } else {
        stop(
            "Invalid input. The variable must be from Exametrika output or from either Biclustering, IRM, LDB or BINET."
        )
    }

    plots <- list()

    if (Original == TRUE) {

        itemn <- NULL

        for (i in 1:ncol(data$U)) {

            itemn <- c(itemn, rep(i,nrow(data$U)))

        }

        rown <- rep(1:nrow(data$U),ncol(data$U))

        bw <- c(!(data$U))


        plot_data <- cbind(itemn, rown, bw)

        plot_data <- as.data.frame(plot_data)

        if (title == TRUE) {
            title1 <- "Original Plot"
        } else{
            title1 <- ""

        }


        original_plot <- ggplot(plot_data, aes(x = itemn, y = rown, fill = bw)) +
            geom_tile() +
            scale_fill_gradient2(low = "black", high = "white", mid = "black",
                                 midpoint = 0, limit = c(-1, 1),
                                 name = "Rho", space = "Lab") +
            labs(title = title1) +
            theme(legend.position = "none",
                  plot.title = element_text(hjust = 0.5),
                  axis.ticks = element_blank(),
                  axis.text = element_blank(),
                  axis.title = element_blank(),
                  axis.line = element_blank(),
                  panel.background = element_blank(),
            )

        plots[[1]] <- original_plot
    }

    if (Clusterd == TRUE) {


        sorted <- data$U[, order(data$FieldEstimated, decreasing = FALSE)]
        sorted <- sorted[order(data$ClassEstimated, decreasing = TRUE), ]

        bw <- c(!(sorted))

        plot_data <- cbind(itemn, rown, bw)

        plot_data <- as.data.frame(plot_data)

        if (title == TRUE) {
            title2 <- "Clusterd Data"
        } else{
            title2 <- ""

        }


        clusterd_plot <- ggplot(plot_data, aes(x = itemn, y = rown, fill = bw)) +
            geom_tile() +
            scale_fill_gradient2(low = "black", high = "white", mid = "black",
                                 midpoint = 0, limit = c(-1, 1),
                                 name = "Rho", space = "Lab") +
            labs(title = title2) +
            theme(legend.position = "none",
                  plot.title = element_text(hjust = 0.5),
                  axis.ticks = element_blank(),
                  axis.text = element_blank(),
                  axis.title = element_blank(),
                  axis.line = element_blank(),
                  panel.background = element_blank(),
            )

        if (Clusterd_lines == TRUE) {
            vl <- cumsum(table(sort(data$FieldEstimated)))
            hl <- cumsum(table(sort(data$ClassEstimated)))

            h <- hl[1:data$Nclass - 1]
            v <- vl[1:data$Nfield - 1] + 0.5

            clusterd_plot <- clusterd_plot +
                geom_hline(yintercept = c(nrow(data$U) - h), color = "red") +
                geom_vline(xintercept = c(v), color = "red")
        }

        plots[[2]] <- clusterd_plot
    }

    if (Original == TRUE && Clusterd == TRUE) {
        plots <- grid.arrange(plots[[1]], plots[[2]], nrow = 1)
    }

    return(plots)
}

plotArray_gg(result.Ranklusteing, Clusterd_lines = FALSE)
plotArray_gg(result.IRM)
plotArray_gg(result.LDB)
plotArray_gg(result.BINET)

plotLCD_gg(result.BINET)
k <- plotTRP_gg(result.Ranklusteing)
plotLCD_gg(result.BINET)

k

combinePlots_gg(k)
plot(result.Ranklusteing, type = "TRP")


plot(result.LCA, type = "CMP", items = 1:9, nc = 3, nr = 3)
plot(result.LCA, type = "LCD")

plot(result.BINET, type = "LRD")


# Graph

install.packages("ggraph")

library(ggraph)
library(igraph)

result.BNM$adj

StrLearningPBIL_BNM(J5S10,
                    population = 20, Rs = 0.5, Rm = 0.005, maxParents = 2,
                    alpha = 0.05, estimate = 4
)

g <- result.BNM$adj

g %>%
    ggraph(layout = "kk") +
    geom_edge_link(aes())


# 行列データ
matrix_data <- matrix(c(0, 1, 0, 0, 0,
                        0, 0, 1, 1, 0,
                        0, 0, 0, 0, 1,
                        0, 0, 0, 0, 1,
                        0, 0, 0, 0, 0),
                      nrow = 5,
                      byrow = TRUE,
                      dimnames = list(c("Item01", "Item02", "Item03", "Item04", "Item05"),
                                      c("Item01", "Item02", "Item03", "Item04", "Item05")))

# エッジリストに変換
edges <- which(matrix_data == 1, arr.ind = TRUE)
edges <- cbind(rownames(matrix_data)[edges[, 1]], colnames(matrix_data)[edges[, 2]])
colnames(edges) <- c("from", "to")
edges

graph <- graph_from_data_frame(edges, directed = TRUE)

ggraph(graph, layout = "grid") +
    geom_edge_link(aes(edge_alpha = 0.5)) +
    geom_node_point() +
    geom_node_text(aes(label = name), repel = TRUE)

ggraph(graph, layout = "dh") +
    geom_edge_link(aes(edge_alpha = 0.5)) +
    geom_node_point() +
    geom_node_text(aes(label = name), repel = TRUE)

ggraph(graph) +
    geom_edge_link(aes(edge_alpha = 0.5), arrow = arrow(length = unit(0.2, "inches"))) +
    geom_node_point() +
    geom_node_text(aes(label = name), repel = TRUE)

ggraph(graph) +
    geom_edge_link(aes(edge_alpha = 0.5), arrow = arrow(length = unit(0.2, "inches"))) +
    geom_node_point(size = 10) + # ポイントサイズを10に設定
    geom_node_text(aes(label = name), repel = TRUE)

ggraph(graph) +
    geom_edge_link(aes(edge_alpha = 0.5), arrow = arrow(length = unit(0.2, "inches"))) +
    geom_node_point(size = 10) +
    geom_node_text(aes(label = name), repel = TRUE) +
    theme(legend.position = "none")

ggraph(graph) +
    geom_edge_link(aes(edge_alpha = 0.5), arrow = arrow(length = unit(0.2, "inches"))) +
    geom_node_point(size = 10, color = "lightgreen") +  # colorパラメータを使用する
    geom_node_text(aes(label = name), repel = TRUE) +
    theme(legend.position = "none")

ggraph(graph) +
    geom_edge_link(aes(edge_alpha = 0.5),
                   arrow = arrow(length = unit(0.3, "inches")),  # 矢印の長さを増やす
                   size = 1) +  # 線の太さを調整する
    geom_node_point(size = 10, color = "lightgreen") +
    geom_node_text(aes(label = name), repel = TRUE) +
    theme(legend.position = "none")

ggraph(graph) +
    geom_edge_link(aes(edge_alpha = 0.5),
                   arrow = arrow(length = unit(0.3, "inches")),
                   size = 1) +
    geom_node_point(size = 10, color = "lightgreen") +
    geom_node_text(aes(label = name), repel = TRUE) +
    theme_void()

ggraph(graph) +
    geom_edge_link(aes(edge_alpha = 0.5),
                   arrow = arrow(length = unit(0.3, "inches")),
                   size = 1) +
    geom_node_point(size = 10, color = "lightgreen") +
    geom_node_text(aes(label = name), repel = TRUE) +
    theme(legend.position = "none")

ggraph(graph) +
    geom_edge_link(aes(edge_alpha = 0.7),
                   arrow = arrow(length = unit(0.4, "inches"), type = "closed", ends = "last"),  # 矢印のサイズを増やす
                   size = 2,  # 矢印の太さを増やす
                   color = "darkblue") +  # 矢印の色を変更
    geom_node_point(size = 10, color = "lightgreen") +
    geom_node_text(aes(label = name), repel = TRUE) +
    theme_void()

# グラフ諦め

# FieldPIRP

plot(result.LDB, type = "FieldPIRP")

plot(result.LDB, type = "LCD")

result.LDB$CCRR_table

result.LDB$Nfield

result.LDB$Nclass

class(result.LDB)

result.LDB$TestFitIndices

plotFieldPIRP_gg <- function(data) {
    if (all(class(data) %in% c("Exametrika", "LDB"))) {
    } else {
        stop("Invalid input. The variable must be from Exametrika output or from LDB.")
    }


    n_cls <- data$Nclass

    n_field <- data$Nfield

    plots <- list()

    for (i in 1:n_cls) {

        field_data <- NULL

        plot_data <- NULL

        for (j in 1:n_field) {


            x <- data.frame(
                k = c(data$CCRR_table[j + (i - 1) * n_field, 3:ncol(data$CCRR_table)])
            )

            field_data <- data.frame(
                k = t(x),
                l = c(0:(ncol(data$CCRR_table)-3)),
                field = data$CCRR_table$Field[j +(i - 1) * n_field]
            )

            plot_data <- rbind(plot_data, field_data)

        }

        plots[[i]] <- ggplot(plot_data ,aes(x = l, y = k, group = field)) +
            ylim(0, 1) +
            scale_x_continuous(breaks = seq(0, max(plot_data$l), 1)) +
            geom_line() +
            geom_text(aes(x = l, y = k-0.02), label = substr(plot_data$field,7,8)) +
            labs(
                title = paste0("Rank ", i),
                x = "PIRP(Number-Right Score) in Parent Field(s) ",
                y = "Correct Response Rate"
            )

    }

    return(plots)
}

a <- plotFieldPIRP_gg(result.LDB)

combinePlots_gg(a)

a[[1]]

a[[2]]

n_cls

n_cls <- data$Nclass

n_field <- data$Nfield

n_field

data <- result.LDB

data$CCRR_table

result.LDB$CCRR_table[1,3]

ncol(data$CCRR_table)

a <- as.data.frame(data$CCRR_table)

x <- data.frame(
    k = c(data$CCRR_table[1, 3:ncol(data$CCRR_table)])
    )

t(x)

xx <- data.frame(
    k = t(x),
    l = c(0:12)
)

is.numeric(x[1,3])

ggplot(x, aes(x = rank, y = Membership)) +
            ylim(0, 1) +
            geom_point() +
            geom_line(linetype = "dashed" ) +
            scale_x_continuous(breaks = seq(1, n_cls, 1)) +
            labs(
                title = paste0(xlabel, " Membership Profile, ", rownames(data$Students)[i]),
                x = paste0("Latent ", xlabel),
                y = "Membership"
            )

x
c(data$CCRR_table[1,3:ncol(data$CCRR_table)])


ggplot(xx,aes(x = l, y = k)) +
    geom_line() +
    geom_text(aes(x = l, y = k-0.02), label = "10")

ggplot(xx,aes(x = l, y = k)) +
    geom_line() +
    geom_text(aes(x = l, y = k-0.02), label = "1")

ggplot(x, aes(x = rank, y = Membership)) +
    ylim(0, 1) +
    geom_point() +
    geom_line(linetype = "dashed" ) +
    scale_x_continuous(breaks = seq(1, n_cls, 1)) +
    labs(
        title = paste0(xlabel, " Membership Profile, ", rownames(data$Students)[i]),
        x = paste0("Latent ", xlabel),
        y = "Membership"
    )

plot_data <- NULL


for (j in 1:n_field) {


    x <- data.frame(
          k = c(data$CCRR_table[j, 3:ncol(data$CCRR_table)])
        )

    field_data <- data.frame(
        k = t(x),
        l = c(0:(ncol(data$CCRR_table)-3)),
        field = data$CCRR_table$Field[j]
    )

    plot_data <- rbind(plot_data, field_data)

}

a <- subset(plot_data, !(is.na(plot_data$k)))

a

ggplot(plot_data ,aes(x = l, y = k, group = field)) +
    ylim(0, 1) +
    scale_x_continuous(breaks = seq(0, max(plot_data$l), 1)) +
    geom_line() +
    geom_text(aes(x = l, y = k-0.02), label = substr(plot_data$field,7,8)) +
    labs(
        title = paste0("Rank ", i),
        x = "PIRP(Number-Right Score) in Parent Field(s) ",
        y = "Correct Response Rate"
    )

as.character(substr(plot_data$field,7,8))

x <- data.frame(
    k = c(data$CCRR_table[1, 3:ncol(data$CCRR_table)])
)

field_data <- data.frame(
    k = t(x),
    l = c(0:(ncol(data$CCRR_table)-3)),
    rank = data$CCRR_table$Field[1]
)

field_data

plot_data

plot_data[[1]]

plot_data[[1]]

# ggplot(plot_data[[1]], aes(x = l, y = k)) +
#     geom_line() +
#     geom_text(aes(x = l, y = k-0.02), label = "1") +
#     ggplot(plot_data[[2]], aes(x = l, y = k))
#     geom_line() +
#     geom_text(aes(x = l, y = k-0.02), label = "2")



plot_data[[10]]

ncol(data$CCRR_table)-3

x <- data.frame(
    k = c(data$CCRR_table[1, 3:ncol(data$CCRR_table)])
)

plot_data[[1]] <- data.frame(
    k = t(x),
    l = c(0:12)
)

length(t(x))

t(x)[1,]

plot_data[[1]]

# データの読み込み


# データを変換してプロット

ggplot(xx, aes(x = l, y = k)) +
    geom_point()

data$CCRR_table
n_field
