library(ggplot2)
library(Exametrika)
library(gridExtra)

plot(result.LCA, type = "LCD")

plot(result.LCA, type = "LCD")
plot(result.IRM, type = "LRD")
plot(result.BNM, type = "LCD")

result.LCA$LCD

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

result.LCA$CMD


plotLCD_gg(result.IRT)
plotLCD_gg(result.LCA)
plotLCD_gg(result.BINET)
plotLCD_gg(result.LRA)
plotLCD_gg(result.LDLRA)
plotLCD_gg(result.Ranklusteing)
plotLCD_gg(result.IRM)
plotLCD_gg(result.LDB)

result.LDB$RMD

result.LDLRA$RMD
result.IRM$LCD
result.IRM$TestFitIndices

result.LCA$CMD

# ------CMP/RMP----------

nchar(nrow(result.LCA$Students))

plotRMP_gg <- function(data) {
    if (all(class(data) %in% c("Exametrika", "LCA"))) {
        xlabel <- "Class"
        change_rowname <- NULL
        dig <- nchar(nrow(data$Students))
        warning("The input data was supposed to be visualized with The Class Membership Profile, so I will plot the CMP.")
        for (i in 1:nrow(data$Students)) {
                change_rowname <- c(change_rowname,paste0("Student ",formatC(i, width = dig, flag = "0")))
            }
            rownames(data$Students) <- change_rowname
    } else if (all(class(data) %in% c("Exametrika", "BINET"))){
        xlabel <- "Class"
        warning("The input data was supposed to be visualized with The Class Membership Profile, so I will plot the CMP.")
    }
    else if (all(class(data) %in% c("Exametrika", "LRA"))||all(class(data) %in% c("Exametrika", "Biclustering"))||all(class(data) %in% c("Exametrika", "LDB"))||all(class(data) %in% c("Exametrika", "LDLRA"))){
        xlabel <- "Rank"
    } else {
        stop("Invalid input. The variable must be from Exametrika output or from either LRA, Biclustering, LDLRA or LDB.")
    }


    n_cls <- data$Nclass

    if (n_cls < 2 || n_cls > 20) {
        stop("Invalid number of Class or Rank")
    }

    plots <- list()

    for (i in 1:nrow(data$Students)) {

        x <- data.frame(
            Membership = c(data$Students[i, 1:n_cls]),
            rank = c(1:n_cls))

        plots[[i]] <- ggplot(x, aes(x = rank, y = Membership)) +
            ylim(0, 1) +
            geom_point() +
            geom_line(linetype = "dashed" ) +
            scale_x_continuous(breaks = seq(1, n_cls, 1)) +
            labs(
                title = paste0(xlabel, " Membership Profile, ", rownames(data$Students)[i]),
                x = paste0("Latent ", xlabel),
                y = "Membership"
            )
    }

    return(plots)
}

result.LCA$CMD
result.LRA$CMD
result.Ranklusteing$RMD
result.LDB$RMD
result.BINET$CMD
result.LDLRA$RMD
class(result.BNM)

result.LDLRA.PBIL$Students

data$Students[1,1:5]

data$Students[1]

tests <- plotRMP_gg(result.LCA)
tests <- plotRMP_gg(result.LRA)
tests <- plotRMP_gg(result.Ranklusteing)
tests <- plotRMP_gg(result.LDLRA)
tests <- plotRMP_gg(result.LDLRA.PBIL)
tests <- plotRMP_gg(result.LDB)
tests <- plotRMP_gg(result.BINET)

combinePlots_gg(tests)



c(data$Students[3, 1:5])

rownames(data$Students)[6]

tests[4]

result.Ranklusteing$Nclass
result.LCA$Nclass

result.LCA$Students
result.BINET$Students

change_rowname <- NULL

for (i in 1:nrow(data0$Students)) {
    change_rowname <- c(change_rowname,paste0("Student",i))
}



change_rowname

nrow(result.LCA$Students)

nrow(change_rowname)

rownames()

data0 <- result.LCA


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

plotLRD_gg(result.IRT)
plotLRD_gg(result.LCA)
plotLRD_gg(result.BINET)
plotLRD_gg(result.LRA)
plotLRD_gg(result.LDLRA)
plotLRD_gg(result.Ranklusteing)
plotLRD_gg(result.IRM)
plotLRD_gg(result.LDB)
plotLRD_gg(result.LDLRA.PBIL)

plotIIC_gg(result.IRT)
