#' @title Plot Array from exametrika
#'
#' @description
#' This function takes exametrika output as input and generates
#' array plots using ggplot2. Array plots visualize the response
#' patterns of students (rows) across items (columns), showing both
#' the original data and the clustered/reordered data.
#'
#' @param data An object of class \code{c("exametrika", "Biclustering")},
#'   \code{c("exametrika", "IRM")}, \code{c("exametrika", "LDB")}, or
#'   \code{c("exametrika", "BINET")}.
#' @param Original Logical. If \code{TRUE} (default), plot the original
#'   (unsorted) response data.
#' @param Clusterd Logical. If \code{TRUE} (default), plot the clustered
#'   (sorted by class and field) response data.
#' @param Clusterd_lines Logical. If \code{TRUE} (default), draw red lines
#'   on the clustered plot to indicate class and field boundaries.
#' @param title Logical. If \code{TRUE} (default), display plot titles.
#'
#' @return A ggplot object or a grid arrangement of two ggplot objects
#'   (original and clustered plots side by side).
#'
#' @details
#' The array plot provides a visual representation of the biclustering
#' result. Black cells indicate correct responses (1), white cells
#' indicate incorrect responses (0). In a well-fitted model, the
#' clustered plot should show a clear block diagonal pattern where
#' high-ability students (bottom rows) answer difficult items (right
#' columns) correctly.
#'
#' @examples
#' \dontrun{
#' library(exametrika)
#' result <- Biclustering(J35S515, nfld = 5, ncls = 6)
#' plotArray_gg(result)
#' }
#'
#' @seealso \code{\link{plotFRP_gg}}, \code{\link{plotTRP_gg}}
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
  if (all(class(data) %in% c("exametrika", "Biclustering")) ||
    all(class(data) %in% c("exametrika", "IRM")) ||
    all(class(data) %in% c("exametrika", "LDB")) ||
    all(class(data) %in% c("exametrika", "BINET"))) {} else {
    stop(
      "Invalid input. The variable must be from exametrika output or from either Biclustering, IRM, LDB or BINET."
    )
  }

  plots <- list()

  if (Original == TRUE) {
    itemn <- NULL

    for (i in 1:ncol(data$U)) {
      itemn <- c(itemn, rep(i, nrow(data$U)))
    }

    rown <- rep(1:nrow(data$U), ncol(data$U))

    bw <- c(!(data$U))


    plot_data <- cbind(itemn, rown, bw)

    plot_data <- as.data.frame(plot_data)

    if (title == TRUE) {
      title1 <- "Original Plot"
    } else {
      title1 <- ""
    }


    original_plot <- ggplot(plot_data, aes(x = itemn, y = rown, fill = bw)) +
      geom_tile() +
      scale_fill_gradient2(
        low = "black", high = "white", mid = "black",
        midpoint = 0, limit = c(-1, 1),
        name = "Rho", space = "Lab"
      ) +
      labs(title = title1) +
      theme(
        legend.position = "none",
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
    } else {
      title2 <- ""
    }


    clusterd_plot <- ggplot(plot_data, aes(x = itemn, y = rown, fill = bw)) +
      geom_tile() +
      scale_fill_gradient2(
        low = "black", high = "white", mid = "black",
        midpoint = 0, limit = c(-1, 1),
        name = "Rho", space = "Lab"
      ) +
      labs(title = title2) +
      theme(
        legend.position = "none",
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


#' @title Plot Field PIRP (Parent Item Reference Profile) from exametrika
#'
#' @description
#' This function takes exametrika LDB output as input and generates
#' Field PIRP (Parent Item Reference Profile) plots using ggplot2.
#' Field PIRP shows the correct response rate for each field as a
#' function of the number-right score in parent fields.
#'
#' @param data An object of class \code{c("exametrika", "LDB")}.
#'
#' @return A list of ggplot objects, one for each rank. Each plot shows
#'   the correct response rate curves for all fields at that rank level.
#'
#' @details
#' In Local Dependence Biclustering (LDB), items in a field may depend
#' on performance in parent fields. The Field PIRP visualizes this
#' dependency by showing how the correct response rate in each field
#' changes based on the number of correct responses in parent fields.
#'
#' Note: Warning messages about NA values may appear during plotting
#' but the behavior is normal.
#'
#' @examples
#' \dontrun{
#' library(exametrika)
#' result <- LDB(J35S515, nfld = 5, ncls = 6)
#' plots <- plotFieldPIRP_gg(result)
#' plots[[1]] # Show Field PIRP for rank 1
#' }
#'
#' @seealso \code{\link{plotFRP_gg}}, \code{\link{plotArray_gg}}
#'
#' @importFrom ggplot2 ggplot
#' @importFrom ggplot2 ylim
#' @importFrom ggplot2 geom_line
#' @importFrom ggplot2 geom_text
#' @importFrom ggplot2 scale_x_continuous
#' @importFrom ggplot2 labs
#' @export

plotFieldPIRP_gg <- function(data) {
  if (all(class(data) %in% c("exametrika", "LDB"))) {} else {
    stop("Invalid input. The variable must be from exametrika output or from LDB.")
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
      ggplot(plot_data, aes(
        x = l,
        y = k,
        group = field
      )) +
      scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.25)) +
      scale_x_continuous(breaks = seq(0, max(plot_data$l), 1)) +
      geom_line() +
      geom_text(aes(x = l, y = k - 0.02), label = substr(plot_data$field, 7, 8)) +
      labs(
        title = paste0("Rank ", i),
        x = "PIRP(Number-Right Score) in Parent Field(s) ",
        y = "Correct Response Rate"
      )
  }

  return(plots)
}
