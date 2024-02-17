#' @title Plot Array from Exametrika
#' @description
#' This function takes Exametrika output as input
#' and generates Rank Membership Profile (RMP) using ggplot2.
#' The applicable analytical methods are Latent Rank Analysis (LRA), Biclustering,
#' Local Dependent Latent Rank Analysis (LDLRA), and Local Dependence Biclustering (LDB).
#'
#'
#' @param data Exametrika output results
#' @param Original plot original data
#' @param Clusterd plot Clusterd data
#' @param Clusterd_lines plot the red lines representing ranks and fields
#' @param title Presence or absence of a title.
#'
#' @importFrom ggplot2 ggplot
#' @importFrom ggplot2 geom_tile
#' @importFrom ggplot2 scale_fill_gradient2
#' @importFrom ggplot2 labs
#' @importFrom ggplot2 theme
#' @importFrom ggplot2 geom_hline
#' @importFrom ggplot2 geom_vline
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



#' @title Plot FieldPIRP from Exametrika
#' @description
#' This function takes Exametrika output as input
#' and generates FieldPIRP using ggplot2.
#' The applicable analytical methods is Local Dependence Biclustering (LDB).
#' The warning message regarding NA values is displayed, but the behavior is normal.
#'
#'
#' @param data Exametrika output results
#'
#' @importFrom ggplot2 ggplot
#' @importFrom ggplot2 ylim
#' @importFrom ggplot2 geom_line
#' @importFrom ggplot2 geom_text
#' @importFrom ggplot2 scale_x_continuous
#' @importFrom ggplot2 labs
#' @export

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
            x <- data.frame(k = c(data$CCRR_table[j + (i - 1) * n_field, 3:ncol(data$CCRR_table)]))

            field_data <- data.frame(
                k = t(x),
                l = c(0:(ncol(
                    data$CCRR_table
                ) - 3)),
                field = data$CCRR_table$Field[j + (i - 1) * n_field]
            )

            plot_data <- rbind(plot_data, field_data)

        }

        plots[[i]] <-
            ggplot(plot_data , aes(
                x = l,
                y = k,
                group = field
            )) +
            ylim(0, 1) +
            scale_x_continuous(breaks = seq(0, max(plot_data$l), 1)) +
            geom_line() +
            geom_text(aes(x = l, y = k - 0.02), label = substr(plot_data$field, 7, 8)) +
            labs(title = paste0("Rank ", i),
                 x = "PIRP(Number-Right Score) in Parent Field(s) ",
                 y = "Correct Response Rate")

    }

    return(plots)
}
