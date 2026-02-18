#' Plot Field Category Response Profile (FCRP) for Polytomous Biclustering
#'
#' @description
#' Creates a Field Category Response Profile (FCRP) plot for polytomous
#' (ordinal or nominal) Biclustering results. FCRP displays the probability
#' of each response category for each latent class/rank within each field.
#'
#' @param data An object of class \code{c("exametrika", "ordinalBiclustering")}
#'   or \code{c("exametrika", "nominalBiclustering")} from
#'   \code{exametrika::Biclustering()}.
#' @param style Character string specifying the plot style. One of:
#'   \describe{
#'     \item{\code{"line"}}{Line plot with points (default)}
#'     \item{\code{"bar"}}{Stacked bar chart}
#'   }
#' @param title Logical or character. If \code{TRUE} (default), displays an
#'   auto-generated title. If \code{FALSE}, no title. If a character string,
#'   uses it as a custom title.
#' @param colors Character vector of colors for categories. If \code{NULL}
#'   (default), uses a colorblind-friendly palette.
#' @param linetype Character or numeric vector specifying line types for
#'   \code{style = "line"}. If \code{NULL} (default), uses solid lines.
#'   Only applies to line plots.
#' @param show_legend Logical. If \code{TRUE} (default), displays the legend.
#' @param legend_position Character. Position of the legend. One of
#'   \code{"right"} (default), \code{"top"}, \code{"bottom"}, \code{"left"},
#'   \code{"none"}.
#'
#' @return A ggplot object showing category response probabilities for each
#'   field and latent class/rank.
#'
#' @details
#' FCRP (Field Category Response Profile) visualizes how response category
#' probabilities change across latent classes or ranks within each field.
#' For each field, the plot shows \eqn{P(response = k | class/rank)} for
#' all categories k. Probabilities sum to 1.0 for each class/rank.
#'
#' This plot is only available for polytomous Biclustering models
#' (\code{ordinalBiclustering} or \code{nominalBiclustering}) that have
#' 3 or more response categories.
#'
#' The \code{style} parameter allows two visualizations:
#' \itemize{
#'   \item \code{"line"}: Shows category probability curves as lines with points
#'   \item \code{"bar"}: Shows stacked bar chart with category proportions
#' }
#'
#' @examples
#' \dontrun{
#' # Ordinal Biclustering with 5 categories
#' data(J35S500)
#' result <- Biclustering(J35S500, ncls = 5, nfld = 5, method = "R")
#'
#' # Line plot (default)
#' plotFCRP_gg(result, style = "line")
#'
#' # Stacked bar chart
#' plotFCRP_gg(result, style = "bar")
#'
#' # Custom styling
#' plotFCRP_gg(result,
#'   style = "line",
#'   title = "Category Response Patterns",
#'   colors = c("#E69F00", "#56B4E9", "#009E73", "#F0E442", "#CC79A7")
#' )
#' }
#'
#' @seealso \code{\link{plotFCBR_gg}}, \code{\link{plotScoreField_gg}}
#'
#' @importFrom ggplot2 ggplot aes geom_line geom_point geom_bar facet_wrap
#'   labs theme_minimal scale_color_manual scale_fill_manual scale_linetype_manual
#'   scale_y_continuous theme element_text guide_legend guides
#' @importFrom tidyr pivot_longer
#'
#' @export
plotFCRP_gg <- function(data,
                        style = c("line", "bar"),
                        title = TRUE,
                        colors = NULL,
                        linetype = NULL,
                        show_legend = TRUE,
                        legend_position = "right") {
  # Input validation
  if (!inherits(data, "exametrika")) {
    stop("Input must be an exametrika object")
  }

  model_class <- tail(class(data), 1)
  if (!model_class %in% c("ordinalBiclustering", "nominalBiclustering")) {
    stop("FCRP is only available for ordinalBiclustering or nominalBiclustering models")
  }

  if (is.null(data$FRP)) {
    stop("FRP data not found in the model output")
  }

  # Match style argument
  style <- match.arg(style)

  # Set default linetype if NULL
  if (is.null(linetype)) {
    linetype <- "solid"
  }

  # Extract FCRP data (3D array: field × class × category)
  BCRM <- data$FRP
  nfld <- dim(BCRM)[1]
  ncls <- dim(BCRM)[2]
  maxQ <- dim(BCRM)[3]

  if (maxQ < 3) {
    stop("FCRP requires 3 or more response categories. Use plotFRP_gg() for binary data.")
  }

  msg <- data$msg # "Class" or "Rank"

  # Convert 3D array to long format data frame
  fcrp_list <- list()
  for (f in 1:nfld) {
    for (c in 1:ncls) {
      for (q in 1:maxQ) {
        fcrp_list[[length(fcrp_list) + 1]] <- data.frame(
          Field = paste0("Field ", f),
          ClassRank = c,
          Category = paste0("Cat", q),
          Probability = BCRM[f, c, q]
        )
      }
    }
  }
  plot_data <- do.call(rbind, fcrp_list)

  # Convert Category to factor to control ordering
  plot_data$Category <- factor(plot_data$Category,
    levels = paste0("Cat", 1:maxQ)
  )

  # Set up colors
  if (is.null(colors)) {
    colors <- .gg_exametrika_palette(maxQ)
  } else if (length(colors) < maxQ) {
    warning(paste(
      "Insufficient colors provided. Need", maxQ,
      "but got", length(colors), ". Using default palette."
    ))
    colors <- .gg_exametrika_palette(maxQ)
  }

  # Create plot based on style
  if (style == "line") {
    # Line plot
    p <- ggplot(plot_data, aes(
      x = ClassRank,
      y = Probability,
      color = Category,
      group = Category,
      linetype = Category
    )) +
      geom_line(linewidth = 1) +
      geom_point(size = 2) +
      facet_wrap(~Field, ncol = 2) +
      scale_x_continuous(breaks = 1:ncls) +
      scale_y_continuous(breaks = seq(0, 1, 0.25)) +
      labs(
        x = paste("Latent", msg),
        y = "Category Probability",
        color = "Category",
        linetype = "Category"
      ) +
      theme(
        strip.text = element_text(size = 10, face = "bold"),
        legend.position = legend_position
      )

    # Apply custom colors if provided
    if (!is.null(colors)) {
      p <- p + scale_color_manual(values = colors)
    }

    # Apply custom linetype
    p <- p + scale_linetype_manual(values = rep(linetype, length.out = maxQ))
  } else {
    # Bar plot (stacked)
    # Keep numeric version for boundary line drawing
    plot_data$ClassRank_num <- plot_data$ClassRank

    # Calculate cumulative probability for category boundaries
    # Sort in reverse order of Category for bottom-up cumulative sum
    plot_data <- plot_data[order(plot_data$Field, plot_data$ClassRank_num, -xtfrm(plot_data$Category)), ]
    plot_data$CumProb <- ave(plot_data$Probability,
      plot_data$Field,
      plot_data$ClassRank_num,
      FUN = cumsum
    )

    # Convert ClassRank to factor for proper bar positioning
    plot_data$ClassRank <- as.factor(plot_data$ClassRank)

    # Exclude top boundary (CumProb = 1.0) for line drawing
    # After reverse sorting, Cat1 is at the top
    plot_data_boundary <- plot_data[plot_data$Category != "Cat1", ]

    # Create segments connecting adjacent bars (right edge to left edge)
    segments_list <- list()
    for (f in unique(plot_data_boundary$Field)) {
      for (cat in unique(plot_data_boundary$Category)) {
        cat_data <- plot_data_boundary[
          plot_data_boundary$Field == f & plot_data_boundary$Category == cat,
        ]
        cat_data <- cat_data[order(cat_data$ClassRank_num), ]

        if (nrow(cat_data) > 1) {
          for (i in 1:(nrow(cat_data) - 1)) {
            segments_list[[length(segments_list) + 1]] <- data.frame(
              Field = f,
              Category = cat,
              x = cat_data$ClassRank_num[i] + 0.35, # Right edge of bar i
              xend = cat_data$ClassRank_num[i + 1] - 0.35, # Left edge of bar i+1
              y = cat_data$CumProb[i],
              yend = cat_data$CumProb[i + 1]
            )
          }
        }
      }
    }
    boundary_segments <- do.call(rbind, segments_list)

    p <- ggplot(plot_data, aes(
      x = ClassRank,
      y = Probability,
      fill = Category
    )) +
      geom_bar(stat = "identity", position = "stack", width = 0.7) +
      geom_segment(
        data = boundary_segments,
        aes(x = x, xend = xend, y = y, yend = yend),
        linetype = "dashed", color = "gray30", linewidth = 0.5
      ) +
      facet_wrap(~Field, ncol = 2) +
      scale_y_continuous(breaks = seq(0, 1, 0.25)) +
      labs(
        x = paste("Latent", msg),
        y = "Category Probability",
        fill = "Category"
      ) +
      theme(
        strip.text = element_text(size = 10, face = "bold"),
        legend.position = legend_position
      )

    # Apply custom colors if provided
    if (!is.null(colors)) {
      p <- p + scale_fill_manual(values = colors)
    }
  }

  # Handle title
  if (is.logical(title)) {
    if (title) {
      p <- p + labs(title = "Field Category Response Profile")
    }
    # title = FALSE の場合は何もしない
  } else if (is.character(title)) {
    p <- p + labs(title = title)
  }

  # Handle legend visibility
  if (!show_legend) {
    p <- p + theme(legend.position = "none")
  }

  return(p)
}
