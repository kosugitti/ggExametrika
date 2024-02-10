#' @title Plot Item Reference Profile (IRP) from Exametrika
#' @description
#' This function takes Exametrika output as input
#' and generates Item Reference Profile (IRP) using ggplot2.
#' The applicable analytical methods are Latent Class Analysis (LCA), Latent Rank Analysis (LRA), and Local Dependent Latent Rank Analysis (LDLRA).
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
#' @param Num_Students Display the number of students on the bar graph
#'
#' @importFrom ggplot2 ggplot
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
                       title = TRUE) {
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



#' @title Plot Latnt Class Distribution (LCD) from Exametrika
#' @description
#' This function takes Exametrika output as input
#' and generates Latnt Class Distribution (LCD) using ggplot2.
#' The applicable analytical methods are Latent Class Analysis (LCA) and Bicluster Network Model (BINET).
#'
#'
#' @param data Exametrika output results
#' @param title Toggle the presence of the title using TRUE/FALSE
#' @param Num_Students Display the number of students on the bar graph
#'
#' @importFrom ggplot2 ggplot
#' @importFrom ggplot2 geom_bar
#' @importFrom ggplot2 geom_point
#' @importFrom ggplot2 geom_line
#' @importFrom ggplot2 scale_x_continuous
#' @importFrom ggplot2 scale_y_continuous
#' @importFrom ggplot2 annotate
#' @importFrom ggplot2 theme
#' @importFrom ggplot2 labs
#' @export

plotLCD_gg <- function(data,
                       Num_Students = TRUE,
                       title = TRUE) {
    if (all(class(data) %in% c("Exametrika", "LCA")) ||
        all(class(data) %in% c("Exametrika", "BINET"))) {
        xlabel <- "Latent Class"
        mode <- TRUE
        LRD <- FALSE
    } else if (all(class(data) %in% c("Exametrika", "LRA")) ||
               all(class(data) %in% c("Exametrika", "Biclustering"))) {
        xlabel <- "Latent Rank"
        mode <- FALSE
        LRD <- FALSE
        warning(
            "The input data was supposed to be visualized with The Latent Rank Distribution, so I will plot the LRD."
        )
    } else if (all(class(data) %in% c("Exametrika", "LDLRA")) ||
               all(class(data) %in% c("Exametrika", "LDB"))) {
        xlabel <- "Latent Rank"
        mode <- FALSE
        LRD <- TRUE
        warning(
            "The input data was supposed to be visualized with The Latent Rank Distribution, so I will plot the LRD."
        )
    } else {
        stop(
            "Invalid input. The variable must be from Exametrika output or from either LCA or BINET."
        )
    }


    if (LRD == TRUE) {
        x1 <- data.frame(LC = c(1:length(data$LRD)),
                         Num = c(data$LRD))
    } else{
        x1 <- data.frame(LC = c(1:length(data$LCD)),
                         Num = c(data$LCD))
    }

    if (LRD == TRUE) {
        x2 <- data.frame(LC = c(1:length(data$RMD)),
                         Fre = c(data$RMD))
    } else{
        x2 <- data.frame(LC = c(1:length(data$CMD)),
                         Fre = c(data$CMD))
    }

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
    yaxis2 <- c(0, max(x2$Fre))

    if (Num_Students == T) {
        Num_label <- c(x1$Num)
    } else {
        Num_label <- ""
    }

    if (title == T) {
        if (mode == TRUE) {
            title <- "Latent Class Distribution"
        } else if (mode == FALSE) {
            title <- "Latent Rank Distribution"
        }
    } else {
        title <- ""
    }


    plot <- ggplot(x1, aes(x = LC, y = Num)) +
        geom_bar(stat = "identity",
                 fill = "gray",
                 colour = "black") +
        geom_point(aes(y = variable_scaler(x2$Fre, yaxis1, yaxis2)), size = 2.1) +
        geom_line(aes(y = variable_scaler(x2$Fre, yaxis1, yaxis2)) , linetype = "dashed") +
        scale_x_continuous(breaks = c(1:length(data$TRP))) +
        scale_y_continuous(name = "Number of Students",
                           sec.axis = sec_axis(trans = ~ (axis_scaler(
                               ., yaxis1, yaxis2
                           )), name = "Frequency")) +
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

#' @title Plot Latnt Rank Distribution (LRD) from Exametrika
#' @description
#' This function takes Exametrika output as input
#' and generates Latnt Rank Distribution (LRD) using ggplot2.
#' The applicable analytical methods are Latent Rank Analysis (LRA), Biclustering,
#' Local Dependent Latent Rank Analysis (LDLRA), and Local Dependence Biclustering (LDB).
#'
#'
#' @param data Exametrika output results
#' @param title Toggle the presence of the title using TRUE/FALSE
#' @param Num_Students Display the number of students on the bar graph
#'
#' @importFrom ggplot2 ggplot
#' @importFrom ggplot2 geom_bar
#' @importFrom ggplot2 geom_point
#' @importFrom ggplot2 geom_line
#' @importFrom ggplot2 scale_x_continuous
#' @importFrom ggplot2 scale_y_continuous
#' @importFrom ggplot2 annotate
#' @importFrom ggplot2 theme
#' @importFrom ggplot2 labs
#' @export

plotLRD_gg <- function(data,
                       Num_Students = TRUE,
                       title = TRUE) {
    if (all(class(data) %in% c("Exametrika", "LCA")) ||
        all(class(data) %in% c("Exametrika", "BINET"))) {
        xlabel <- "Latent Class"
        mode <- TRUE
        LRD <- FALSE
        warning(
            "The input data was supposed to be visualized with The Latent Class Distribution, so I will plot the LCD."
        )
    } else if (all(class(data) %in% c("Exametrika", "LRA")) ||
               all(class(data) %in% c("Exametrika", "Biclustering"))) {
        xlabel <- "Latent Rank"
        mode <- FALSE
        LRD <- FALSE
    } else if (all(class(data) %in% c("Exametrika", "LDLRA")) ||
               all(class(data) %in% c("Exametrika", "LDB"))) {
        xlabel <- "Latent Rank"
        mode <- FALSE
        LRD <- TRUE
    } else {
        stop(
            "Invalid input. The variable must be from Exametrika output or from either LRA, Biclustering, LDLRA or LDB."
        )
    }


    if (LRD == TRUE) {
        x1 <- data.frame(LC = c(1:length(data$LRD)),
                         Num = c(data$LRD))
    } else{
        x1 <- data.frame(LC = c(1:length(data$LCD)),
                         Num = c(data$LCD))
    }

    if (LRD == TRUE) {
        x2 <- data.frame(LC = c(1:length(data$RMD)),
                         Fre = c(data$RMD))
    } else{
        x2 <- data.frame(LC = c(1:length(data$CMD)),
                         Fre = c(data$CMD))
    }

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
    yaxis2 <- c(0, max(x2$Fre))

    if (Num_Students == T) {
        Num_label <- c(x1$Num)
    } else {
        Num_label <- ""
    }

    if (title == T) {
        if (mode == TRUE) {
            title <- "Latent Class Distribution"
        } else if (mode == FALSE) {
            title <- "Latent Rank Distribution"
        }
    } else {
        title <- ""
    }


    plot <- ggplot(x1, aes(x = LC, y = Num)) +
        geom_bar(stat = "identity",
                 fill = "gray",
                 colour = "black") +
        geom_point(aes(y = variable_scaler(x2$Fre, yaxis1, yaxis2)), size = 2.1) +
        geom_line(aes(y = variable_scaler(x2$Fre, yaxis1, yaxis2)) , linetype = "dashed") +
        scale_x_continuous(breaks = c(1:length(data$TRP))) +
        scale_y_continuous(name = "Number of Students",
                           sec.axis = sec_axis(trans = ~ (axis_scaler(
                               ., yaxis1, yaxis2
                           )), name = "Frequency")) +
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


#' @title Plot Class Membership Profile (CMP) from Exametrika
#' @description
#' This function takes Exametrika output as input
#' and generates Class Membership Profile (CMP) using ggplot2.
#' The applicable analytical methods are Latent Class Analysis (LCA) and Bicluster Network Model (BINET).
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


plotCMP_gg <- function(data) {
    if (all(class(data) %in% c("Exametrika", "LCA"))) {
        xlabel <- "Class"
        change_rowname <- NULL
        dig <- nchar(nrow(data$Students))
        for (i in 1:nrow(data$Students)) {
            change_rowname <-
                c(change_rowname, paste0("Student ", formatC(
                    i, width = dig, flag = "0"
                )))
        }
        rownames(data$Students) <- change_rowname
    } else if (all(class(data) %in% c("Exametrika", "BINET"))) {
        xlabel <- "Class"
    }
    else if (all(class(data) %in% c("Exametrika", "LRA")) ||
             all(class(data) %in% c("Exametrika", "Biclustering")) ||
             all(class(data) %in% c("Exametrika", "LDB")) ||
             all(class(data) %in% c("Exametrika", "LDLRA"))) {
        xlabel <- "Rank"
        warning(
            "The input data was supposed to be visualized with The Rank Membership Profile, so I will plot the RMP."
        )
    } else {
        stop(
            "Invalid input. The variable must be from Exametrika output or from either LCA or BINET."
        )
    }


    n_cls <- data$Nclass

    if (n_cls < 2 || n_cls > 20) {
        stop("Invalid number of Class or Rank")
    }

    plots <- list()

    for (i in 1:nrow(data$Students)) {
        x <- data.frame(Membership = c(data$Students[i, 1:n_cls]),
                        rank = c(1:n_cls))

        plots[[i]] <- ggplot(x, aes(x = rank, y = Membership)) +
            ylim(0, 1) +
            geom_point() +
            geom_line(linetype = "dashed") +
            scale_x_continuous(breaks = seq(1, n_cls, 1)) +
            labs(
                title = paste0(
                    xlabel,
                    " Membership Profile, ",
                    rownames(data$Students)[i]
                ),
                x = paste0("Latent ", xlabel),
                y = "Membership"
            )
    }

    return(plots)
}

#' @title Plot Rank Membership Profile (RMP) from Exametrika
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

plotRMP_gg <- function(data) {
    if (all(class(data) %in% c("Exametrika", "LCA"))) {
        xlabel <- "Class"
        change_rowname <- NULL
        dig <- nchar(nrow(data$Students))
        warning(
            "The input data was supposed to be visualized with The Class Membership Profile, so I will plot the CMP."
        )
        for (i in 1:nrow(data$Students)) {
            change_rowname <-
                c(change_rowname, paste0("Student ", formatC(
                    i, width = dig, flag = "0"
                )))
        }
        rownames(data$Students) <- change_rowname
    } else if (all(class(data) %in% c("Exametrika", "BINET"))) {
        xlabel <- "Class"
        warning(
            "The input data was supposed to be visualized with The Class Membership Profile, so I will plot the CMP."
        )
    }
    else if (all(class(data) %in% c("Exametrika", "LRA")) ||
             all(class(data) %in% c("Exametrika", "Biclustering")) ||
             all(class(data) %in% c("Exametrika", "LDB")) ||
             all(class(data) %in% c("Exametrika", "LDLRA"))) {
        xlabel <- "Rank"
    } else {
        stop(
            "Invalid input. The variable must be from Exametrika output or from either LRA, Biclustering, LDLRA or LDB."
        )
    }


    n_cls <- data$Nclass

    if (n_cls < 2 || n_cls > 20) {
        stop("Invalid number of Class or Rank")
    }

    plots <- list()

    for (i in 1:nrow(data$Students)) {
        x <- data.frame(Membership = c(data$Students[i, 1:n_cls]),
                        rank = c(1:n_cls))

        plots[[i]] <- ggplot(x, aes(x = rank, y = Membership)) +
            ylim(0, 1) +
            geom_point() +
            geom_line(linetype = "dashed") +
            scale_x_continuous(breaks = seq(1, n_cls, 1)) +
            labs(
                title = paste0(
                    xlabel,
                    " Membership Profile, ",
                    rownames(data$Students)[i]
                ),
                x = paste0("Latent ", xlabel),
                y = "Membership"
            )
    }

    return(plots)
}
