#' Calculate expected scores from BCRM (Helper for FRP/RRV with polytomous data)
#' @noRd
.calc_expected_scores <- function(BCRM, stat) {
  nfld <- dim(BCRM)[1]
  ncls <- dim(BCRM)[2]
  maxQ <- dim(BCRM)[3]

  FRP_mat <- matrix(0, nrow = nfld, ncol = ncls)
  for (f in 1:nfld) {
    for (cc in 1:ncls) {
      probs <- BCRM[f, cc, ]
      if (stat == "mean") {
        FRP_mat[f, cc] <- sum((1:maxQ) * probs)
      } else if (stat == "median") {
        cum_probs <- cumsum(probs)
        FRP_mat[f, cc] <- min(which(cum_probs >= 0.5))
      } else if (stat == "mode") {
        FRP_mat[f, cc] <- which.max(probs)
      }
    }
  }
  FRP_mat
}


#' Shared worker for plotCRV_gg / plotRRV_gg
#'
#' The two exported functions differ only in the series prefix ("C"/"R")
#' and the display name ("Class"/"Rank").
#'
#' @param prefix Single letter prepended to the series labels.
#' @param unit_name Display name used in the auto title.
#' @inheritParams plotCRV_gg
#' @return A ggplot object.
#' @keywords internal

.plot_reference_vector <- function(data, title, colors, linetype, show_legend,
                                   legend_position, stat, show_labels,
                                   prefix, unit_name) {
  # Check if this is an exametrika Biclustering-related model
  valid_classes <- c("Biclustering", "ordinalBiclustering", "nominalBiclustering", "ratedBiclustering", "Biclustering_IRM")
  .validate_exametrika(data, valid_classes)

  # Validate stat parameter
  if (!stat %in% c("mean", "median", "mode")) {
    stop("stat must be one of: 'mean', 'median', 'mode'")
  }

  # Check FRP dimensionality
  is_polytomous <- (length(dim(data$FRP)) == 3)

  if (is_polytomous) {
    # Polytomous (3D): Field x Class/Rank x Category -> expected scores
    BCRM <- data$FRP
    maxQ <- dim(BCRM)[3]
    RV <- t(.calc_expected_scores(BCRM, stat)) # Class/Rank x Field
    y_label <- paste0("Expected Score (", stat, ")")
    y_limits <- c(1, maxQ)
    y_breaks <- 1:maxQ
  } else {
    # Binary (2D): Field x Class/Rank
    RV <- t(data$FRP)
    y_label <- "Correct Response Rate"
    y_limits <- c(0, 1)
    y_breaks <- seq(0, 1, 0.25)
  }
  n_series <- nrow(RV)
  n_fld <- ncol(RV)

  # Convert to long format
  series_levels <- paste0(prefix, 1:n_series)
  plot_data <- data.frame(
    field = rep(1:n_fld, each = n_series),
    field_label = rep(paste0("F", 1:n_fld), each = n_series),
    value = as.vector(RV),
    series = factor(rep(series_levels, times = n_fld), levels = series_levels),
    series_num = rep(1:n_series, times = n_fld) # For label display
  )

  # Keep the historical column names ("class"/"rank") in the plot data
  # so that downstream code inspecting p$data continues to work
  legacy_col <- tolower(unit_name)
  plot_data[[legacy_col]] <- plot_data$series
  plot_data[[paste0(legacy_col, "_num")]] <- plot_data$series_num

  # Color setup
  use_colors <- .resolve_colors(colors, n_series)

  # Title setup
  auto_title <- if (is_polytomous) {
    paste0(unit_name, " Reference Vector (", stat, ")")
  } else {
    paste0(unit_name, " Reference Vector")
  }
  plot_title <- .resolve_title(title, auto_title)

  p <- ggplot(plot_data, aes(x = field, y = value, color = series)) +
    geom_line(linetype = linetype) +
    geom_point() +
    scale_x_continuous(breaks = 1:n_fld, labels = paste0("F", 1:n_fld)) +
    scale_y_continuous(limits = y_limits, breaks = y_breaks) +
    scale_color_manual(values = use_colors) +
    labs(
      title = plot_title,
      x = "Field",
      y = y_label,
      color = NULL
    )

  # Label display (using ggrepel to avoid overlaps)
  if (show_labels) {
    p <- p + ggrepel::geom_text_repel(
      data = plot_data,
      mapping = aes(x = field, y = value, label = series_num, color = series),
      size = 3,
      box.padding = 0.5,
      point.padding = 0.3,
      segment.color = "grey50",
      segment.size = 0.3,
      max.overlaps = Inf,
      show.legend = FALSE
    )
  }

  # Legend control
  .apply_legend(p, show_legend, legend_position)
}


#' @title Plot Class Reference Vector (CRV) from exametrika
#'
#' @description
#' This function takes exametrika Biclustering output as input and generates
#' a Class Reference Vector (CRV) plot using ggplot2. CRV shows how each
#' latent class performs across fields, with one line per class.
#'
#' Supports both binary (2-valued) and polytomous (multi-valued) biclustering models.
#' For polytomous data, the \code{stat} parameter controls how expected scores
#' are calculated from category probabilities.
#'
#' @param data An object of class \code{c("exametrika", "Biclustering")} from
#'   \code{exametrika::Biclustering()}.
#' @param title Logical or character. If \code{TRUE} (default), display an
#'   auto-generated title. If \code{FALSE}, no title. If a character string,
#'   use it as a custom title.
#' @param colors Character vector of colors for each class.
#'   If \code{NULL} (default), a colorblind-friendly palette is used.
#' @param linetype Character or numeric scalar specifying the line type
#'   applied to all lines. Default is \code{"solid"}.
#' @param show_legend Logical. If \code{TRUE} (default), display the legend.
#' @param legend_position Character. Position of the legend.
#'   One of \code{"right"} (default), \code{"top"}, \code{"bottom"},
#'   \code{"left"}, \code{"none"}.
#' @param stat Character. Statistic for polytomous data: \code{"mean"} (default),
#'   \code{"median"}, or \code{"mode"}. For binary data, this parameter is ignored.
#'   \itemize{
#'     \item \code{"mean"}: Expected score (sum of category x probability)
#'     \item \code{"median"}: Median category (cumulative probability >= 0.5)
#'     \item \code{"mode"}: Most probable category
#'   }
#' @param show_labels Logical. If \code{TRUE}, displays class labels on each
#'   point using \code{ggrepel} to avoid overlaps. Defaults to \code{FALSE}
#'   since the legend already provides class information.
#'
#' @return A single ggplot object showing the Class Reference Vector.
#'
#' @details
#' The Class Reference Vector is the transpose of the Field Reference Profile
#' (FRP). While FRP shows one plot per field, CRV displays all classes in a
#' single plot with fields on the x-axis. Each line represents a latent class,
#' showing its correct response rate pattern across fields.
#'
#' **Binary Data (2 categories):**
#' - Y-axis shows "Correct Response Rate" (0.0 to 1.0)
#' - Values represent the probability of correct response
#'
#' **Polytomous Data (3+ categories):**
#' - Y-axis shows "Expected Score" (1 to max category)
#' - Values are calculated using the \code{stat} parameter
#' - Higher scores indicate better performance
#'
#' CRV is used when latent classes are nominal (unordered). For ordered
#' latent ranks, use \code{\link{plotRRV_gg}} instead.
#'
#' @examplesIf requireNamespace("exametrika", quietly = TRUE)
#' # Binary biclustering
#' library(exametrika)
#' result <- Biclustering(J35S515, nfld = 5, ncls = 6)
#' plotCRV_gg(result)
#'
#' \donttest{
#' # Ordinal biclustering (polytomous)
#' data(J35S500)
#' result_ord <- Biclustering(J35S500, ncls = 5, nfld = 5, method = "R")
#' plotCRV_gg(result_ord) # Default: mean
#' plotCRV_gg(result_ord, stat = "median")
#' plotCRV_gg(result_ord, stat = "mode")
#' }
#'
#' @seealso \code{\link{plotRRV_gg}}, \code{\link{plotFRP_gg}}, \code{\link{plotScoreField_gg}}
#'
#' @importFrom ggplot2 ggplot aes geom_line geom_point labs theme scale_color_manual scale_x_continuous scale_y_continuous
#' @importFrom ggrepel geom_text_repel
#' @export

plotCRV_gg <- function(data,
                       title = TRUE,
                       colors = NULL,
                       linetype = "solid",
                       show_legend = TRUE,
                       legend_position = "right",
                       stat = "mean",
                       show_labels = FALSE) {
  .plot_reference_vector(
    data, title, colors, linetype, show_legend, legend_position,
    stat, show_labels,
    prefix = "C", unit_name = "Class"
  )
}


#' @title Plot Rank Reference Vector (RRV) from exametrika
#'
#' @description
#' This function takes exametrika Biclustering output as input and generates
#' a Rank Reference Vector (RRV) plot using ggplot2. RRV shows how each
#' latent rank performs across fields, with one line per rank.
#'
#' Supports both binary (2-valued) and polytomous (multi-valued) biclustering models.
#' For polytomous data, the \code{stat} parameter controls how expected scores
#' are calculated from category probabilities.
#'
#' @param data An object of class \code{c("exametrika", "Biclustering")} from
#'   \code{exametrika::Biclustering()}.
#' @param title Logical or character. If \code{TRUE} (default), display an
#'   auto-generated title. If \code{FALSE}, no title. If a character string,
#'   use it as a custom title.
#' @param colors Character vector of colors for each rank.
#'   If \code{NULL} (default), a colorblind-friendly palette is used.
#' @param linetype Character or numeric scalar specifying the line type
#'   applied to all lines. Default is \code{"solid"}.
#' @param show_legend Logical. If \code{TRUE} (default), display the legend.
#' @param legend_position Character. Position of the legend.
#'   One of \code{"right"} (default), \code{"top"}, \code{"bottom"},
#'   \code{"left"}, \code{"none"}.
#' @param stat Character. Statistic for polytomous data: \code{"mean"} (default),
#'   \code{"median"}, or \code{"mode"}. For binary data, this parameter is ignored.
#'   \itemize{
#'     \item \code{"mean"}: Expected score (sum of category x probability)
#'     \item \code{"median"}: Median category (cumulative probability >= 0.5)
#'     \item \code{"mode"}: Most probable category
#'   }
#' @param show_labels Logical. If \code{TRUE}, displays rank labels on each
#'   point using \code{ggrepel} to avoid overlaps. Defaults to \code{FALSE}
#'   since the legend already provides rank information.
#'
#' @return A single ggplot object showing the Rank Reference Vector.
#'
#' @details
#' The Rank Reference Vector is the transpose of the Field Reference Profile
#' (FRP). While FRP shows one plot per field, RRV displays all ranks in a
#' single plot with fields on the x-axis. Each line represents a latent rank,
#' showing its performance pattern across fields.
#'
#' **Binary Data (2 categories):**
#' - Y-axis shows "Correct Response Rate" (0.0 to 1.0)
#' - Values represent the probability of correct response
#'
#' **Polytomous Data (3+ categories):**
#' - Y-axis shows "Expected Score" (1 to max category)
#' - Values are calculated using the \code{stat} parameter
#' - Higher scores indicate better performance
#'
#' RRV is used when latent ranks are ordinal (ordered). For unordered
#' latent classes, use \code{\link{plotCRV_gg}} instead.
#'
#' @examplesIf requireNamespace("exametrika", quietly = TRUE)
#' # Binary biclustering
#' library(exametrika)
#' result <- Biclustering(J15S500, nfld = 3, ncls = 5)
#' plotRRV_gg(result)
#'
#' \donttest{
#' # Ordinal biclustering (polytomous)
#' data(J35S500)
#' result_ord <- Biclustering(J35S500, ncls = 5, nfld = 5, method = "R")
#' plotRRV_gg(result_ord) # Default: mean
#' plotRRV_gg(result_ord, stat = "median")
#' plotRRV_gg(result_ord, stat = "mode")
#'
#' # Custom styling
#' plotRRV_gg(result_ord,
#'   title = "Rank Performance Across Fields",
#'   colors = c("#1b9e77", "#d95f02", "#7570b3", "#e7298a", "#66a61e"),
#'   legend_position = "bottom"
#' )
#' }
#'
#' @seealso \code{\link{plotCRV_gg}}, \code{\link{plotFRP_gg}}, \code{\link{plotScoreField_gg}}
#'
#' @importFrom ggplot2 ggplot aes geom_line geom_point labs theme scale_color_manual scale_x_continuous scale_y_continuous
#' @importFrom ggrepel geom_text_repel
#' @export

plotRRV_gg <- function(data,
                       title = TRUE,
                       colors = NULL,
                       linetype = "solid",
                       show_legend = TRUE,
                       legend_position = "right",
                       stat = "mean",
                       show_labels = FALSE) {
  .plot_reference_vector(
    data, title, colors, linetype, show_legend, legend_position,
    stat, show_labels,
    prefix = "R", unit_name = "Rank"
  )
}
