#' @title Plot Array from Exametrika
#' @description
#' This function takes Exametrika output as input
#' and generates Rank Membership Profile (RMP) using ggplot2.
#' The applicable analytical methods are Latent Rank Analysis (LRA), Biclustering,
#' Local Dependent Latent Rank Analysis (LDLRA), and Local Dependence Biclustering (LDB).
#'
#'
#' @param data Exametrika output results
#'
#' @importFrom ggplot2 ggplot
#' @importFrom ggplot2 ylim
#' @importFrom ggplot2 geom_point
#' @importFrom ggplot2 geom_line
#' @importFrom ggplot2 scale_x_continuous
#' @importFrom ggplot2 labs
#' @export

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
