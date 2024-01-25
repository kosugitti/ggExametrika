#' @title Plot Item Reference Profile (IRP) from Exametrika
#' @description
#' This function takes Exametrika output as input
#' and generates Item Reference Profile (IRP) using ggplot2.
#' The applicable analytical methods are Latent Class Analysis (LCA), Latent Rank Analysis (LRA), and Local Dependent Latent Rank Analysis (LDLRA).
#'
#' @param data Exametrika output results
#'
#' @importFrom ggplot2 ggplot
#' @importFrom ggplot2 xlim
#' @importFrom ggplot2 ylim
#' @importFrom ggplot2 geom_point
#' @importFrom ggplot2 geom_line
#' @importFrom ggplot2 scale_x_continuous
#' @importFrom ggplot2 labs
#' @export

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


#' @title Plot Field Reference Profile (FRP) from Exametrika
#' @description
#' This function takes Exametrika output as input
#' and generates Field Reference Profile (FRP) using ggplot2.
#' The applicable analytical methods are Biclustering, Infinite Relational Model (IRM),
#' Local Dependence Biclustering (LDB), and Bicluster Network Model (BINET).
#'
#'
#' @param data Exametrika output results
#'
#' @importFrom ggplot2 ggplot
#' @importFrom ggplot2 xlim
#' @importFrom ggplot2 ylim
#' @importFrom ggplot2 geom_point
#' @importFrom ggplot2 geom_line
#' @importFrom ggplot2 scale_x_continuous
#' @importFrom ggplot2 labs
#' @export

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

#' @title Plot Test Reference Profile (TRP) from Exametrika
#' @description
#' This function takes Exametrika output as input
#' and generates Test Reference Profile (TRP) using ggplot2.
#' The applicable analytical methods are Latent Class Analysis (LCA), Latent Rank Analysis (LRA), Biclustering,
#' Infinite Relational Model (IRM), Local Dependence Biclustering (LDB), and Bicluster Network Model (BINET).
#'
#'
#' @param data Exametrika output results
#' @param title Toggle the presence of the title using TRUE/FALSE
#'
#' @importFrom ggplot2 ggplot
#' @importFrom ggplot2 xlim
#' @importFrom ggplot2 ylim
#' @importFrom ggplot2 geom_bar
#' @importFrom ggplot2 geom_point
#' @importFrom ggplot2 geom_line
#' @importFrom ggplot2 scale_x_continuous
#' @importFrom ggplot2 scale_y_continuous
#' @importFrom ggplot2 annotate
#' @importFrom ggplot2 theme
#' @importFrom ggplot2 labs
#' @export

plotTRP_gg <- function(data,
                       Num_Students = TRUE,
                       title = T) {
    if (all(class(data) %in% c("Exametrika", "LCA")) ||
        all(class(data) %in% c("Exametrika", "BINET"))) {
        xlabel <- "Latent Class"
        con_bran <- FALSE
    } else if (all(class(data) %in% c("Exametrika", "LRA")) ||
               all(class(data) %in% c("Exametrika", "Biclustering")) ||
               all(class(data) %in% c("Exametrika", "IRM"))) {
        xlabel <- "Latent Rank"
        con_bran <- FALSE
    } else if (all(class(data) %in% c("Exametrika", "LDB"))) {
        xlabel <- "Latent Rank"
        con_bran <- TRUE
    } else {
        stop(
            "Invalid input. The variable must be from Exametrika output or from either LCA, LRA, Biclustering, LDB, or BINET."
        )
    }

    if (con_bran == TRUE) {
        x1 <- data.frame(LC = c(1:length(data$LRD)),
                         Num = c(data$LRD))
    } else {
        x1 <- data.frame(LC = c(1:length(data$LCD)),
                         Num = c(data$LCD))
    }

    x2 <- data.frame(LC = c(1:length(data$TRP)),
                     ES = c(data$TRP))

    variable_scaler <- function(y2, yaxis1, yaxis2) {
        a <- diff(yaxis1) / diff(yaxis2)
        b <-
            (yaxis1[1] * yaxis2[2] - yaxis1[2] * yaxis2[1]) / diff(yaxis2)
        a * y2 + b
    }

    axis_scaler <- function(y1, yaxis1, yaxis2) {
        c <- diff(yaxis2) / diff(yaxis1)
        d <-
            (yaxis2[1] * yaxis1[2] - yaxis2[2] * yaxis1[1]) / diff(yaxis1)
        c * y1 + d
    }


    yaxis1 <- c(0, max(x1$Num))
    yaxis2 <- c(0, max(x2$ES))

    if (Num_Students == T) {
        Num_label <- c(x1$Num)
    } else {
        Num_label <- ""
    }

    if (title == T) {
        title <- "Test Reference Profile"
    } else {
        title <- ""
    }


    plot <- ggplot(x1, aes(x = LC, y = Num)) +
        geom_bar(stat = "identity",
                 fill = "gray",
                 colour = "black") +
        geom_point(aes(y = variable_scaler(x2$ES, yaxis1, yaxis2)), size = 2.1) +
        geom_line(aes(y = variable_scaler(x2$ES, yaxis1, yaxis2)) , linetype = "dashed") +
        scale_x_continuous(breaks = c(1:length(data$TRP))) +
        scale_y_continuous(name = "Number of Students",
                           sec.axis = sec_axis(trans = ~ (axis_scaler(
                               ., yaxis1, yaxis2
                           )), name = "Expected Score")) +
        annotate(
            "text",
            x = x1$LC,
            y = x1$Num - (median(x1$Num) * 0.05),
            label = Num_label
        ) +
        theme(axis.title.y.right = element_text(angle = 90, vjust = 0.5)) +
        labs(title = title,
             x = xlabel)




    return(plot)
}

