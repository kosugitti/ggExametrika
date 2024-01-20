library(ggplot2)
library(Exametrika)
library(gridExtra)



LCA(J15S500, ncls = 4)

result.LCA <- LCA(J15S500, ncls =5)

head(result.LCA$Students)

plot(result.LDB, type = "IRP", items = 1:6, nc = 2, nr = 3)

plot(result.LCA, type = "FRP", items = 1:6, nc = 2, nr = 3)

plot(result.LCA, type = "CMP", students = 1:9, nc = 3, nr = 3)

plot(result.LCA, type = "TRP")

plot(result.LCA, type = "LCD")

plot(result.LDB, type = "IRP")


plotIRP_gg <- function(data) {
    if (all(class(data) %in% c("Exametrika", "LCA"))) {
        xlabel <- "Latent Class"
    } else if (all(class(data) %in% c("Exametrika", "LRA"))||all(class(data) %in% c("Exametrika", "LDLRA"))){
        xlabel <- "Latent Rank"
    } else {
        stop("Invalid input. The variable must be from Exametrika output or from either LCA, LRA, or LDLRA.")
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

plot(result.Ranklusteing, type = "FRP", items = 1:6, nc = 2, nr = 3)

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

??Exametrika

getwd()

plots <- plotIRP_gg(result.LDLRA)

combinePlots_gg(plots, selectPlots = c(1:12))

# FRPをやる

plotFRP_gg <- function(data) {
    if (!(all(class(data) %in% c("Exametrika", "Biclustering")) || all(class(data) %in% c("Exametrika", "IRM")) || all(class(data) %in% c("Exametrika", "LDB")) || all(class(data) %in% c("Exametrika", "BINET")))) {
        stop("Invalid input. The variable must be from Exametrika output or an output from Biclustering, IRM, LDB, or BINET.")
    }


    n_cls <- ncol(data$FRP)

    plots <- list()

    for (i in 1:nrow(data$FRP)) {

        x <- data.frame(
            CRR = c(data$FRP[i,]),
            rank = c(1:n_cls))

        plots[[i]] <- ggplot(x, aes(x = rank, y = CRR)) +
            ylim(0, 1) +
            geom_point() +
            geom_line(linetype = "dashed" ) +
            scale_x_continuous(breaks = seq(1, n_cls, 1)) +
            labs(
                title = paste0("Field Reference Profile, ", rownames(data$FRP)[i]),
                x = "Latent Rank",
                y = "Correct Response Rate"
            )
    }

    return(plots)
}

plotIRP_gg(result.Ranklusteing)

plotFRP_gg(result.LRA)

result.LCA$TRP



plots <- plotFRP_gg(result.BNM)

combinePlots_gg(plots)

data <- result.Ranklusteing

!all(class(data) %in% c("Exametrika", "Biclustering"))

Biclustering(J35S515, nfld = 5, ncls = 6, method = "B")

result.Ranklusteing <- Biclustering(J35S515, nfld = 5, ncls = 6, method = "R")

result.Ranklusteing$FRP

class(result.Ranklusteing)

plot(result.Ranklusteing, type = "IRP", items = 1:6, nc = 2, nr = 3)

nrow()

library(igraph)
DAG <-
    matrix(
        c(
            "Item01", "Item02",
            "Item02", "Item03",
            "Item02", "Item04",
            "Item03", "Item05",
            "Item04", "Item05"
        ),
        ncol = 2, byrow = T
    )
## graph object
g <- igraph::graph_from_data_frame(DAG)
g

adj_mat <- as.matrix(igraph::get.adjacency(g))
adj_mat

result.BNM <- BNM(J5S10, adj_matrix = adj_mat)
result.BNM

StrLearningGA_BNM(J5S10,
                  population = 20, Rs = 0.5, Rm = 0.002, maxParents = 2,
                  maxGeneration = 100, crossover = 2, elitism = 2
)

StrLearningPBIL_BNM(J5S10,
                    population = 20, Rs = 0.5, Rm = 0.005, maxParents = 2,
                    alpha = 0.05, estimate = 4
)

plot(result.BNM, type = "FRP", items = 1:6, nc = 2, nr = 3)

result.IRM <- IRM(J35S515, gamma_c = 1, gamma_f = 1, verbose = TRUE)

plot(result.IRM, type = "FRP", items = 1:6, nc = 2, nr = 3)

ncol(result.IRM$FRP)

!all(class(result.Ranklusteing) %in% c("Exametrika", "Biclustering")) || !all(class(result.Ranklusteing) %in% c("Exametrika", "IRM"))

!(all(class(3) %in% c("Exametrika", "Biclustering")) || all(class(3) %in% c("Exametrika", "IRM")))

if (!(all(class(result.IRM) %in% c("Exametrika", "Biclustering")) || all(class(result.IRM) %in% c("Exametrika", "IRM")) || all(class(result.IRM) %in% c("Exametrika", "LDB")) || all(class(result.IRM) %in% c("Exametrika", "BINET")))) {
    stop("Invalid input. The variable must be from Exametrika output or an output from Biclustering, .")
}


plots <- plotFRP_gg(result.IRM)

combinePlots_gg(plots, selectPlots = c(7:12))

result.LDLRA.PBIL <- StrLearningPBIL_LDLRA(J35S515,
                                           seed = 123,
                                           ncls = 5,
                                           method = "R",
                                           elitism = 1,
                                           successiveLimit = 15
)

result.LDLRA.PBIL

plot(result.LDLRA.PBIL, type = "IRP", items = 1:6, nc = 2, nr = 3)

class(result.LDLRA.PBIL)

plots <- plotIRP_gg(result.LDLRA.PBIL)

combinePlots_gg(plots)

#LDB


lines <- matrix(c(
    "Item", "Field",
    "Item01","1",
    "Item02","6",
    "Item03","6",
    "Item04","8",
    "Item05","9",
    "Item06","9",
    "Item07","4",
    "Item08","7",
    "Item09","7",
    "Item10","7",
    "Item11","5",
    "Item12","8",
    "Item13","9",
    "Item14","10",
    "Item15","10",
    "Item16","9",
    "Item17","9",
    "Item18","10",
    "Item19","10",
    "Item20","10",
    "Item21","2",
    "Item22","2",
    "Item23","3",
    "Item24","3",
    "Item25","5",
    "Item26","5",
    "Item27","6",
    "Item28","9",
    "Item29","9",
    "Item30","10",
    "Item31","1",
    "Item32","1",
    "Item33","7",
    "Item34","9",
    "Item35","10"
), ncol = 2, byrow = TRUE)

data <- "Item,Field
Item01,1
Item02,6
Item03,6
Item04,8
Item05,9
Item06,9
Item07,4
Item08,7
Item09,7
Item10,7
Item11,5
Item12,8
Item13,9
Item14,10
Item15,10
Item16,9
Item17,9
Item18,10
Item19,10
Item20,10
Item21,2
Item22,2
Item23,3
Item24,3
Item25,5
Item26,5
Item27,6
Item28,9
Item29,9
Item30,10
Item31,1
Item32,1
Item33,7
Item34,9
Item35,10"

getwd()

# ファイルにデータを書き込む
fieldFile <- "C:/Users/jonso/Documents/hobby/ggExametrika/develop/fieldFile.csv"
writeLines(data, fieldFile)

# 読み込んで表示する
lines <- readLines(fieldFile)
for (line in lines) {
    cat(line)
    cat("\n")
}



# CSVファイルとして読み込む
FieldData <- read.csv(fieldFile)
conf <- FieldData[, 2]
conf



edgeData <- "From Field (Parent) >>>,>>> To Field (Child),At Class/Rank (Locus)
6,8,2
4,7,2
5,8,2
1,7,2
1,2,2
4,5,2
3,5,3
4,8,3
6,8,3
2,4,3
4,6,3
4,7,3
3,5,4
6,8,4
4,5,4
1,8,4
7,10,5
9,10,5
6,8,5
7,9,5"

# ファイルにデータを書き込む
edgeFile <- "C:/Users/jonso/Documents/hobby/ggExametrika/develop/edgeFile.csv"
writeLines(edgeData, edgeFile)

# 読み込んで表示する
lines <- readLines(edgeFile)
for (line in lines) {
    cat(line)
    cat("\n")
}

result.LDB <- LDB(U = J35S515, ncls = 5, conf = conf, adj_file = edgeFile)
result.LDB

plot(result.LDB, type = "FRP", items = 1:6, nc = 2, nr = 3)

class(result.LDB)

plots <- plotFRP_gg(result.LDB)

combinePlots_gg(plots, selectPlots = c(7:10))

#BInet

fieldData <- "Item,Field
Item01,1
Item02,5
Item03,5
Item04,5
Item05,9
Item06,9
Item07,6
Item08,6
Item09,6
Item10,6
Item11,2
Item12,7
Item13,7
Item14,11
Item15,11
Item16,7
Item17,7
Item18,12
Item19,12
Item20,12
Item21,2
Item22,2
Item23,3
Item24,3
Item25,4
Item26,4
Item27,4
Item28,8
Item29,8
Item30,12
Item31,1
Item32,1
Item33,6
Item34,10
Item35,10"

# ファイルにデータを書き込む
fieldFile <- "C:/Users/jonso/Documents/hobby/ggExametrika/develop/FixFieldBINET.csv"
writeLines(fieldData, fieldFile)

edgeData <- "From Class (Parent) >>>,>>> To Class (Child),At Field (Locus)
1,2,1
2,4,2
3,5,2
4,5,3
5,6,4
7,11,4
2,3,5
4,7,5
6,9,5
8,12,5
10,12,5
6,10,7
6,8,8
11,12,8
8,12,9
9,11,9
12,13,12"

# ファイルにデータを書き込む
edgeFile <- "C:/Users/jonso/Documents/hobby/ggExametrika/develop/EdgesBINET.csv"
writeLines(edgeData, edgeFile)

fieldFile <- "C:/Users/jonso/Documents/hobby/ggExametrika/develop/FixFieldBINET.csv"
edgeFile <- "C:/Users/jonso/Documents/hobby/ggExametrika/develop/EdgesBINET.csv"
FieldData <- read.csv(fieldFile)


conf <- FieldData[, 2]
conf

lines <- readLines(edgeFile)
for (line in lines) {
    cat(line)
    cat("\n")
}


result.BINET <- BINET(
    U = J35S515,
    ncls = 13, nfld = 12,
    conf = conf, adj_file = edgeFile
)

result.BINET

plot(result.BINET, type = "FRP", nc = 3, nr = 2)

class(result.BINET)


plots <- plotFRP_gg(result.BINET)

combinePlots_gg(plots, selectPlots = c(7:12))



plotFRP_gg(result.LCA)


# make TRP

result.LCA$Test

# Expected Scoreはこれ
result.LCA$TRP

# Number of Studentsはこれ
result.LCA$LCD

# Frequency
result.LCA$CMD

# 図を別々に作って重ねる方法がいいかな

x1 <- data.frame(
    LC = c(1:5),
    Num = c(result.LCA$LCD)
)

x1

x2 <- data.frame(
    LC = c(1:5),
    ES = c(result.LCA$TRP)
)

plot(result.LCA, type = "TRP")

base1 <- ggplot(x1, aes(x = LC, y = Num)) +
    geom_bar(stat = "identity", fill = "gray", colour = "black")

base2 <- ggplot(x2, aes(x = LC, y = ES)) +
                    geom_point()

com <- base1 + base2

(max(result.LCA$LCD)/2)/median(result.LCA$TRP)

yaxis1 <- c(0, 4)
yaxis2 <- c(100, 300)

variable_scaler <- function(y2, yaxis1, yaxis2){
    a <- (yaxis1[2] - yaxis1[1]) / (yaxis2[2] - yaxis2[1])
    b <- (yaxis1[1] * yaxis2[2] - yaxis1[2] * yaxis2[1]) / (yaxis2[2] - yaxis2[1])
    ret <- a * y2 + b
    ret
}

axis_scaler <- function(y1, yaxis1, yaxis2){
    c <- (yaxis2[2] - yaxis2[1]) / (yaxis1[2] - yaxis1[1])
    d <- (yaxis2[1] * yaxis1[2] - yaxis2[2] * yaxis1[1]) / (yaxis1[2] - yaxis1[1])
    ret <- c * y1 + d
    ret
}

variable_scaler()

# 2軸を作る実験
x <- c(0:10)
df <- data.frame(x = x,
                 y1 = 0.1*x + 1,
                 y2 = 20*x + 100)
df

ggplot(df, aes(x = x)) +
    geom_point(aes(y = y1, colour = "y1"))+
    geom_point(aes(y = y2, colour = "y2"))

ggplot(df, aes(x = x)) +
    geom_point(aes(y = y1, colour = "y1")) +
    geom_point(aes(y = y2, colour = "y2")) +
    scale_y_continuous(
        sec.axis = sec_axis(  ~ . /100, name = "y2")
    )

variable_scaler <- function(y2, yaxis1, yaxis2) {
    a <- diff(yaxis1) / diff(yaxis2)
    b <- (yaxis1[1] * yaxis2[2] - yaxis1[2] * yaxis2[1]) / diff(yaxis2)
    a * y2 + b
}

axis_scaler <- function(y1, yaxis1, yaxis2) {
    c <- diff(yaxis2) / diff(yaxis1)
    d <- (yaxis2[1] * yaxis1[2] - yaxis2[2] * yaxis1[1]) / diff(yaxis1)
    c * y1 + d
}

ggplot(df, aes(x = x)) +
    geom_point(aes(y = y1, colour = "y1")) +
    geom_point(aes(y = variable_scaler(y2, yaxis1, yaxis2), colour = "y2")) +
    scale_y_continuous(
        sec.axis = sec_axis(  ~(axis_scaler(., yaxis1, yaxis2)),
                              name = "y2")
    )


# サンプルデータ
df1 <- data.frame(category = c("A", "B", "C", "D"), value = c(10, 20, 15, 25))
df2 <- data.frame(category = c("A", "B", "C", "D"), line_value = c(5, 15, 10, 20))

# ggplot2でプロット
library(ggplot2)

ggplot() +
    geom_col(data = df1, aes(x = category, y = value), fill = "blue", stat = "identity") +
    geom_line(data = df2, aes(x = category, y = line_value, group = 1), color = "red") +
    labs(title = "Bar and Line Plot", x = "Category", y = "Value")
