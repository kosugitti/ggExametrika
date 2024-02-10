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
