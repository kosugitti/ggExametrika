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


#' @title Plot Item Reference Profile (FRP) from Exametrika
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

