#' @title Plot Item Reference Profile (IRP) from exametrika
#'
#' @description
#' This function takes exametrika output as input and generates
#' Item Reference Profile (IRP) plots using ggplot2. IRP shows the
#' probability of a correct response for each item at each latent
#' class or rank level.
#'
#' @param data An object of class \code{c("exametrika", "LCA")},
#'   \code{c("exametrika", "LRA")}, or \code{c("exametrika", "LDLRA")}.
#'
#' @return A list of ggplot objects, one for each item. Each plot shows the
#'   correct response rate across latent classes or ranks.
#'
#' @details
#' The Item Reference Profile visualizes how item difficulty varies across
#' latent classes (LCA) or ranks (LRA, LDLRA). Items with monotonically
#' increasing profiles indicate good discrimination between classes/ranks.
#'
#' @examples
#' \dontrun{
#' library(exametrika)
#' result <- LRA(J15S500, nrank = 5)
#' plots <- plotIRP_gg(result)
#' plots[[1]] # Show IRP for the first item
#' }
#'
#' @seealso \code{\link{plotFRP_gg}}, \code{\link{plotTRP_gg}}
#'
#' @importFrom ggplot2 ggplot
#' @importFrom ggplot2 ylim
#' @importFrom ggplot2 geom_point
#' @importFrom ggplot2 geom_line
#' @importFrom ggplot2 scale_x_continuous
#' @importFrom ggplot2 labs
#' @export

plotIRP_gg <- function(data) {
  if (all(class(data) %in% c("exametrika", "LCA"))) {
    xlabel <- "Latent Class"
  } else if (all(class(data) %in% c("exametrika", "LRA")) || all(class(data) %in% c("exametrika", "LDLRA"))) {
    xlabel <- "Latent Rank"
  } else {
    stop("Invalid input. The variable must be from exametrika output or from either LCA, LRA, or LDLRA.")
  }


  n_cls <- ncol(data$IRP)

  if (n_cls < 2 || n_cls > 20) {
    stop("Invalid number of classes or Ranks")
  }

  plots <- list()

  for (i in 1:nrow(data$IRP)) {
    x <- data.frame(
      CRR = c(data$IRP[i, ]),
      rank = c(1:n_cls)
    )

    plots[[i]] <- ggplot(x, aes(x = rank, y = CRR)) +
      scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.25)) +
      geom_point() +
      geom_line(linetype = "dashed") +
      scale_x_continuous(breaks = seq(1, n_cls, 1)) +
      labs(
        title = paste0("Item Reference Profile, ", rownames(data$IRP)[i]),
        x = xlabel,
        y = "Correct Response Rate"
      )
  }

  return(plots)
}


#' @title Plot Field Reference Profile (FRP) from exametrika
#'
#' @description
#' This function takes exametrika output as input and generates
#' Field Reference Profile (FRP) plots using ggplot2. FRP shows the
#' correct response rate for each field (item cluster) at each latent
#' class or rank level.
#'
#' @param data An object of class \code{c("exametrika", "Biclustering")},
#'   \code{c("exametrika", "IRM")}, \code{c("exametrika", "LDB")}, or
#'   \code{c("exametrika", "BINET")}.
#'
#' @return A list of ggplot objects, one for each field. Each plot shows the
#'   correct response rate across latent classes or ranks.
#'
#' @details
#' In biclustering models, items are grouped into fields. The Field Reference
#' Profile shows how each field's correct response rate varies across
#' latent classes or ranks. Fields with monotonically increasing profiles
#' indicate good alignment with the latent structure.
#'
#' @examples
#' \dontrun{
#' library(exametrika)
#' result <- Biclustering(J35S515, nfld = 5, ncls = 6)
#' plots <- plotFRP_gg(result)
#' plots[[1]] # Show FRP for the first field
#' }
#'
#' @seealso \code{\link{plotIRP_gg}}, \code{\link{plotTRP_gg}}
#'
#' @importFrom ggplot2 ggplot
#' @importFrom ggplot2 ylim
#' @importFrom ggplot2 geom_point
#' @importFrom ggplot2 geom_line
#' @importFrom ggplot2 scale_x_continuous
#' @importFrom ggplot2 labs
#' @export

plotFRP_gg <- function(data) {
  if (!(all(class(data) %in% c("exametrika", "Biclustering")) || all(class(data) %in% c("exametrika", "IRM")) || all(class(data) %in% c("exametrika", "LDB")) || all(class(data) %in% c("exametrika", "BINET")))) {
    stop("Invalid input. The variable must be from exametrika output or an output from Biclustering, IRM, LDB, or BINET.")
  }


  n_cls <- ncol(data$FRP)

  plots <- list()

  for (i in 1:nrow(data$FRP)) {
    x <- data.frame(
      CRR = c(data$FRP[i, ]),
      rank = c(1:n_cls)
    )

    plots[[i]] <- ggplot(x, aes(x = rank, y = CRR)) +
      scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.25)) +
      geom_point() +
      geom_line(linetype = "dashed") +
      scale_x_continuous(breaks = seq(1, n_cls, 1)) +
      labs(
        title = paste0("Field Reference Profile, ", rownames(data$FRP)[i]),
        x = "Latent Rank",
        y = "Correct Response Rate"
      )
  }

  return(plots)
}

#' @title Plot Test Reference Profile (TRP) from exametrika
#'
#' @description
#' This function takes exametrika output as input and generates a
#' Test Reference Profile (TRP) plot using ggplot2. TRP shows the
#' number of students in each latent class/rank (bar graph) and the
#' expected test score for each class/rank (line graph).
#'
#' @param data An object from exametrika: LCA, LRA, Biclustering, IRM,
#'   LDB, or BINET output.
#' @param Num_Students Logical. If \code{TRUE} (default), display the
#'   number of students on each bar.
#' @param title Logical. If \code{TRUE} (default), display the plot title.
#'
#' @return A single ggplot object with dual y-axes showing both the
#'   student distribution and expected scores.
#'
#' @details
#' The Test Reference Profile provides an overview of the latent structure.
#' The bar graph shows how students are distributed across classes/ranks,
#' while the line graph shows the expected test score for each class/rank.
#' In well-fitted models, expected scores should increase monotonically
#' with class/rank number.
#'
#' @examples
#' \dontrun{
#' library(exametrika)
#' result <- LRA(J15S500, nrank = 5)
#' plot <- plotTRP_gg(result)
#' plot
#' }
#'
#' @seealso \code{\link{plotIRP_gg}}, \code{\link{plotLCD_gg}},
#'   \code{\link{plotLRD_gg}}
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
  if (all(class(data) %in% c("exametrika", "LCA")) ||
    all(class(data) %in% c("exametrika", "BINET"))) {
    xlabel <- "Latent Class"
    con_bran <- FALSE
  } else if (all(class(data) %in% c("exametrika", "LRA")) ||
    all(class(data) %in% c("exametrika", "Biclustering")) ||
    all(class(data) %in% c("exametrika", "IRM"))) {
    xlabel <- "Latent Rank"
    con_bran <- FALSE
  } else if (all(class(data) %in% c("exametrika", "LDB"))) {
    xlabel <- "Latent Rank"
    con_bran <- TRUE
  } else {
    stop(
      "Invalid input. The variable must be from exametrika output or from either LCA, LRA, Biclustering, LDB, or BINET."
    )
  }

  if (con_bran == TRUE) {
    x1 <- data.frame(
      LC = c(1:length(data$LRD)),
      Num = c(data$LRD)
    )
  } else {
    x1 <- data.frame(
      LC = c(1:length(data$LCD)),
      Num = c(data$LCD)
    )
  }

  x2 <- data.frame(
    LC = c(1:length(data$TRP)),
    ES = c(data$TRP)
  )

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
    geom_bar(
      stat = "identity",
      fill = "gray",
      colour = "black"
    ) +
    geom_point(aes(y = variable_scaler(x2$ES, yaxis1, yaxis2)), size = 2.1) +
    geom_line(aes(y = variable_scaler(x2$ES, yaxis1, yaxis2)), linetype = "dashed") +
    scale_x_continuous(breaks = c(1:length(data$TRP))) +
    scale_y_continuous(
      name = "Number of Students",
      sec.axis = sec_axis(trans = ~ (axis_scaler(
        ., yaxis1, yaxis2
      )), name = "Expected Score")
    ) +
    annotate(
      "text",
      x = x1$LC,
      y = x1$Num - (median(x1$Num) * 0.05),
      label = Num_label
    ) +
    theme(axis.title.y.right = element_text(angle = 90, vjust = 0.5)) +
    labs(
      title = title,
      x = xlabel
    )


  return(plot)
}


#' @title Plot Latent Class Distribution (LCD) from exametrika
#'
#' @description
#' This function takes exametrika output as input and generates a
#' Latent Class Distribution (LCD) plot using ggplot2. LCD shows the
#' number of students in each latent class and the class membership
#' distribution.
#'
#' @param data An object of class \code{c("exametrika", "LCA")} or
#'   \code{c("exametrika", "BINET")}. If LRA or Biclustering output
#'   is provided, LRD will be plotted instead with a warning.
#' @param Num_Students Logical. If \code{TRUE} (default), display the
#'   number of students on each bar.
#' @param title Logical. If \code{TRUE} (default), display the plot title.
#'
#' @return A single ggplot object with dual y-axes showing both the
#'   student count and membership frequency.
#'
#' @details
#' The Latent Class Distribution shows how students are distributed
#' across latent classes. The bar graph shows the number of students
#' assigned to each class, and the line graph shows the cumulative
#' class membership distribution.
#'
#' @examples
#' \dontrun{
#' library(exametrika)
#' result <- LCA(J15S500, ncls = 5)
#' plot <- plotLCD_gg(result)
#' plot
#' }
#'
#' @seealso \code{\link{plotLRD_gg}}, \code{\link{plotTRP_gg}}
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
  if (all(class(data) %in% c("exametrika", "LCA")) ||
    all(class(data) %in% c("exametrika", "BINET"))) {
    xlabel <- "Latent Class"
    mode <- TRUE
    LRD <- FALSE
  } else if (all(class(data) %in% c("exametrika", "LRA")) ||
    all(class(data) %in% c("exametrika", "Biclustering"))) {
    xlabel <- "Latent Rank"
    mode <- FALSE
    LRD <- FALSE
    warning(
      "The input data was supposed to be visualized with The Latent Rank Distribution, so I will plot the LRD."
    )
  } else if (all(class(data) %in% c("exametrika", "LDLRA")) ||
    all(class(data) %in% c("exametrika", "LDB"))) {
    xlabel <- "Latent Rank"
    mode <- FALSE
    LRD <- TRUE
    warning(
      "The input data was supposed to be visualized with The Latent Rank Distribution, so I will plot the LRD."
    )
  } else {
    stop(
      "Invalid input. The variable must be from exametrika output or from either LCA or BINET."
    )
  }


  if (LRD == TRUE) {
    x1 <- data.frame(
      LC = c(1:length(data$LRD)),
      Num = c(data$LRD)
    )
  } else {
    x1 <- data.frame(
      LC = c(1:length(data$LCD)),
      Num = c(data$LCD)
    )
  }

  if (LRD == TRUE) {
    x2 <- data.frame(
      LC = c(1:length(data$RMD)),
      Fre = c(data$RMD)
    )
  } else {
    x2 <- data.frame(
      LC = c(1:length(data$CMD)),
      Fre = c(data$CMD)
    )
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
    geom_bar(
      stat = "identity",
      fill = "gray",
      colour = "black"
    ) +
    geom_point(aes(y = variable_scaler(x2$Fre, yaxis1, yaxis2)), size = 2.1) +
    geom_line(aes(y = variable_scaler(x2$Fre, yaxis1, yaxis2)), linetype = "dashed") +
    scale_x_continuous(breaks = c(1:length(data$TRP))) +
    scale_y_continuous(
      name = "Number of Students",
      sec.axis = sec_axis(trans = ~ (axis_scaler(
        ., yaxis1, yaxis2
      )), name = "Frequency")
    ) +
    annotate(
      "text",
      x = x1$LC,
      y = x1$Num - (median(x1$Num) * 0.05),
      label = Num_label
    ) +
    theme(axis.title.y.right = element_text(angle = 90, vjust = 0.5)) +
    labs(
      title = title,
      x = xlabel
    )


  return(plot)
}

#' @title Plot Latent Rank Distribution (LRD) from exametrika
#'
#' @description
#' This function takes exametrika output as input and generates a
#' Latent Rank Distribution (LRD) plot using ggplot2. LRD shows the
#' number of students in each latent rank and the rank membership
#' distribution.
#'
#' @param data An object of class \code{c("exametrika", "LRA")},
#'   \code{c("exametrika", "Biclustering")}, \code{c("exametrika", "LDLRA")},
#'   or \code{c("exametrika", "LDB")}. If LCA or BINET output is provided,
#'   LCD will be plotted instead with a warning.
#' @param Num_Students Logical. If \code{TRUE} (default), display the
#'   number of students on each bar.
#' @param title Logical. If \code{TRUE} (default), display the plot title.
#'
#' @return A single ggplot object with dual y-axes showing both the
#'   student count and membership frequency.
#'
#' @details
#' The Latent Rank Distribution shows how students are distributed
#' across latent ranks. Unlike latent classes, ranks have an ordinal
#' interpretation where higher ranks indicate higher ability levels.
#'
#' @examples
#' \dontrun{
#' library(exametrika)
#' result <- LRA(J15S500, nrank = 5)
#' plot <- plotLRD_gg(result)
#' plot
#' }
#'
#' @seealso \code{\link{plotLCD_gg}}, \code{\link{plotTRP_gg}}
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
  if (all(class(data) %in% c("exametrika", "LCA")) ||
    all(class(data) %in% c("exametrika", "BINET"))) {
    xlabel <- "Latent Class"
    mode <- TRUE
    LRD <- FALSE
    warning(
      "The input data was supposed to be visualized with The Latent Class Distribution, so I will plot the LCD."
    )
  } else if (all(class(data) %in% c("exametrika", "LRA")) ||
    all(class(data) %in% c("exametrika", "Biclustering"))) {
    xlabel <- "Latent Rank"
    mode <- FALSE
    LRD <- FALSE
  } else if (all(class(data) %in% c("exametrika", "LDLRA")) ||
    all(class(data) %in% c("exametrika", "LDB"))) {
    xlabel <- "Latent Rank"
    mode <- FALSE
    LRD <- TRUE
  } else {
    stop(
      "Invalid input. The variable must be from exametrika output or from either LRA, Biclustering, LDLRA or LDB."
    )
  }


  if (LRD == TRUE) {
    x1 <- data.frame(
      LC = c(1:length(data$LRD)),
      Num = c(data$LRD)
    )
  } else {
    x1 <- data.frame(
      LC = c(1:length(data$LCD)),
      Num = c(data$LCD)
    )
  }

  if (LRD == TRUE) {
    x2 <- data.frame(
      LC = c(1:length(data$RMD)),
      Fre = c(data$RMD)
    )
  } else {
    x2 <- data.frame(
      LC = c(1:length(data$CMD)),
      Fre = c(data$CMD)
    )
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
    geom_bar(
      stat = "identity",
      fill = "gray",
      colour = "black"
    ) +
    geom_point(aes(y = variable_scaler(x2$Fre, yaxis1, yaxis2)), size = 2.1) +
    geom_line(aes(y = variable_scaler(x2$Fre, yaxis1, yaxis2)), linetype = "dashed") +
    scale_x_continuous(breaks = c(1:length(data$TRP))) +
    scale_y_continuous(
      name = "Number of Students",
      sec.axis = sec_axis(trans = ~ (axis_scaler(
        ., yaxis1, yaxis2
      )), name = "Frequency")
    ) +
    annotate(
      "text",
      x = x1$LC,
      y = x1$Num - (median(x1$Num) * 0.05),
      label = Num_label
    ) +
    theme(axis.title.y.right = element_text(angle = 90, vjust = 0.5)) +
    labs(
      title = title,
      x = xlabel
    )


  return(plot)
}


#' @title Plot Class Membership Profile (CMP) from exametrika
#'
#' @description
#' This function takes exametrika output as input and generates
#' Class Membership Profile (CMP) plots using ggplot2. CMP shows
#' each student's membership probability across all latent classes.
#'
#' @param data An object of class \code{c("exametrika", "LCA")} or
#'   \code{c("exametrika", "BINET")}. If LRA, Biclustering, LDLRA, or LDB
#'   output is provided, RMP will be plotted instead with a warning.
#'
#' @return A list of ggplot objects, one for each student. Each plot shows
#'   the membership probability across all latent classes.
#'
#' @details
#' The Class Membership Profile visualizes how strongly each student
#' belongs to each latent class. Students with high membership probability
#' in a single class are well-classified, while students with similar
#' probabilities across classes may be ambiguous cases.
#'
#' @examples
#' \dontrun{
#' library(exametrika)
#' result <- LCA(J15S500, ncls = 5)
#' plots <- plotCMP_gg(result)
#' plots[[1]] # Show CMP for the first student
#' }
#'
#' @seealso \code{\link{plotRMP_gg}}, \code{\link{plotLCD_gg}}
#'
#' @importFrom ggplot2 ggplot
#' @importFrom ggplot2 ylim
#' @importFrom ggplot2 geom_point
#' @importFrom ggplot2 geom_line
#' @importFrom ggplot2 scale_x_continuous
#' @importFrom ggplot2 labs
#' @export


plotCMP_gg <- function(data) {
  if (all(class(data) %in% c("exametrika", "LCA"))) {
    xlabel <- "Class"
    change_rowname <- NULL
    dig <- nchar(nrow(data$Students))
    for (i in 1:nrow(data$Students)) {
      change_rowname <-
        c(change_rowname, paste0("Student ", formatC(
          i,
          width = dig, flag = "0"
        )))
    }
    rownames(data$Students) <- change_rowname
  } else if (all(class(data) %in% c("exametrika", "BINET"))) {
    xlabel <- "Class"
  } else if (all(class(data) %in% c("exametrika", "LRA")) ||
    all(class(data) %in% c("exametrika", "Biclustering")) ||
    all(class(data) %in% c("exametrika", "LDB")) ||
    all(class(data) %in% c("exametrika", "LDLRA"))) {
    xlabel <- "Rank"
    warning(
      "The input data was supposed to be visualized with The Rank Membership Profile, so I will plot the RMP."
    )
  } else {
    stop(
      "Invalid input. The variable must be from exametrika output or from either LCA or BINET."
    )
  }


  n_cls <- data$Nclass

  if (n_cls < 2 || n_cls > 20) {
    stop("Invalid number of Class or Rank")
  }

  plots <- list()

  for (i in 1:nrow(data$Students)) {
    x <- data.frame(
      Membership = c(data$Students[i, 1:n_cls]),
      rank = c(1:n_cls)
    )

    plots[[i]] <- ggplot(x, aes(x = rank, y = Membership)) +
      scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.25)) +
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

#' @title Plot Rank Membership Profile (RMP) from exametrika
#'
#' @description
#' This function takes exametrika output as input and generates
#' Rank Membership Profile (RMP) plots using ggplot2. RMP shows
#' each student's membership probability across all latent ranks.
#'
#' @param data An object of class \code{c("exametrika", "LRA")},
#'   \code{c("exametrika", "Biclustering")}, \code{c("exametrika", "LDLRA")},
#'   or \code{c("exametrika", "LDB")}. If LCA or BINET output is provided,
#'   CMP will be plotted instead with a warning.
#'
#' @return A list of ggplot objects, one for each student. Each plot shows
#'   the membership probability across all latent ranks.
#'
#' @details
#' The Rank Membership Profile visualizes how strongly each student
#' belongs to each latent rank. Unlike class membership, rank membership
#' has an ordinal interpretation. Students with unimodal profiles
#' centered on a single rank are well-classified.
#'
#' @examples
#' \dontrun{
#' library(exametrika)
#' result <- LRA(J15S500, nrank = 5)
#' plots <- plotRMP_gg(result)
#' plots[[1]] # Show RMP for the first student
#' }
#'
#' @seealso \code{\link{plotCMP_gg}}, \code{\link{plotLRD_gg}}
#'
#' @importFrom ggplot2 ggplot
#' @importFrom ggplot2 ylim
#' @importFrom ggplot2 geom_point
#' @importFrom ggplot2 geom_line
#' @importFrom ggplot2 scale_x_continuous
#' @importFrom ggplot2 labs
#' @export

plotRMP_gg <- function(data) {
  if (all(class(data) %in% c("exametrika", "LCA"))) {
    xlabel <- "Class"
    change_rowname <- NULL
    dig <- nchar(nrow(data$Students))
    warning(
      "The input data was supposed to be visualized with The Class Membership Profile, so I will plot the CMP."
    )
    for (i in 1:nrow(data$Students)) {
      change_rowname <-
        c(change_rowname, paste0("Student ", formatC(
          i,
          width = dig, flag = "0"
        )))
    }
    rownames(data$Students) <- change_rowname
  } else if (all(class(data) %in% c("exametrika", "BINET"))) {
    xlabel <- "Class"
    warning(
      "The input data was supposed to be visualized with The Class Membership Profile, so I will plot the CMP."
    )
  } else if (all(class(data) %in% c("exametrika", "LRA")) ||
    all(class(data) %in% c("exametrika", "Biclustering")) ||
    all(class(data) %in% c("exametrika", "LDB")) ||
    all(class(data) %in% c("exametrika", "LDLRA"))) {
    xlabel <- "Rank"
  } else {
    stop(
      "Invalid input. The variable must be from exametrika output or from either LRA, Biclustering, LDLRA or LDB."
    )
  }


  n_cls <- data$Nclass

  if (n_cls < 2 || n_cls > 20) {
    stop("Invalid number of Class or Rank")
  }

  plots <- list()

  for (i in 1:nrow(data$Students)) {
    x <- data.frame(
      Membership = c(data$Students[i, 1:n_cls]),
      rank = c(1:n_cls)
    )

    plots[[i]] <- ggplot(x, aes(x = rank, y = Membership)) +
      scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.25)) +
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
