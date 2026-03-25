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
#' @param linetype Character or numeric vector specifying the line types.
#'   If a single value, all lines use that type. If a vector, each class
#'   uses the corresponding type. Default is \code{"solid"}.
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
#' @importFrom ggplot2 ggplot aes geom_line geom_point labs theme
#'   scale_color_manual scale_x_continuous scale_y_continuous
#' @importFrom ggrepel geom_text_repel
#' @export

plotCRV_gg <- function(data,
                       title = TRUE,
                       colors = NULL,
                       linetype = "solid",
                       show_legend = TRUE,
                       legend_position = "right",
                       stat = "mean",
                       show_labels = NULL) {
  # Check if this is an exametrika Biclustering model
  if (!inherits(data, "exametrika")) {
    stop("Invalid input. The variable must be from exametrika output.")
  }

  # Check if it's a Biclustering-related model
  valid_classes <- c("Biclustering", "ordinalBiclustering", "nominalBiclustering", "ratedBiclustering", "Biclustering_IRM")
  if (!any(class(data) %in% valid_classes)) {
    stop("Invalid input. The variable must be from Biclustering, ordinalBiclustering, nominalBiclustering, or ratedBiclustering.")
  }

  # Validate stat parameter
  if (!stat %in% c("mean", "median", "mode")) {
    stop("stat must be one of: 'mean', 'median', 'mode'")
  }

  # Check FRP dimensionality
  frp_dims <- length(dim(data$FRP))
  is_polytomous <- (frp_dims == 3)

  if (is_polytomous) {
    # Polytomous (3D): Field x Class/Rank x Category
    BCRM <- data$FRP
    maxQ <- dim(BCRM)[3]

    # Calculate expected scores
    FRP_mat <- .calc_expected_scores(BCRM, stat)
    CRV <- t(FRP_mat) # Transpose to Class x Field

    n_cls <- nrow(CRV)
    n_fld <- ncol(CRV)
    y_label <- paste0("Expected Score (", stat, ")")
    y_limits <- c(1, maxQ)
    y_breaks <- 1:maxQ
  } else {
    # Binary (2D): Field x Class/Rank
    CRV <- t(data$FRP)
    n_cls <- nrow(CRV)
    n_fld <- ncol(CRV)
    y_label <- "Correct Response Rate"
    y_limits <- c(0, 1)
    y_breaks <- seq(0, 1, 0.25)
  }

  # Convert to long format
  plot_data <- data.frame(
    field = rep(1:n_fld, each = n_cls),
    field_label = rep(paste0("F", 1:n_fld), each = n_cls),
    value = as.vector(t(CRV)),
    class = factor(rep(paste0("C", 1:n_cls), times = n_fld), levels = paste0("C", 1:n_cls)),
    class_num = rep(1:n_cls, times = n_fld)
  )

  # Set default for show_labels
  if (is.null(show_labels)) {
    show_labels <- FALSE
  }

  # Color setup
  if (is.null(colors)) {
    use_colors <- .gg_exametrika_palette(n_cls)
  } else {
    use_colors <- colors[1:n_cls]
  }

  # Title setup
  if (is.logical(title) && title) {
    if (is_polytomous) {
      plot_title <- paste0("Class Reference Vector (", stat, ")")
    } else {
      plot_title <- "Class Reference Vector"
    }
  } else if (is.logical(title) && !title) {
    plot_title <- NULL
  } else {
    plot_title <- title
  }

  p <- ggplot(plot_data, aes(x = field, y = value, color = class)) +
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
      mapping = aes(x = field, y = value, label = class_num, color = class),
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
  if (show_legend) {
    p <- p + theme(legend.position = legend_position)
  } else {
    p <- p + theme(legend.position = "none")
  }

  return(p)
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
#' @param linetype Character or numeric vector specifying the line types.
#'   If a single value, all lines use that type. If a vector, each rank
#'   uses the corresponding type. Default is \code{"solid"}.
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
#' @importFrom ggplot2 ggplot aes geom_line geom_point labs theme
#'   scale_color_manual scale_x_continuous scale_y_continuous
#' @importFrom ggrepel geom_text_repel
#' @export

plotRRV_gg <- function(data,
                       title = TRUE,
                       colors = NULL,
                       linetype = "solid",
                       show_legend = TRUE,
                       legend_position = "right",
                       stat = "mean",
                       show_labels = NULL) {
  # Check if this is an exametrika Biclustering model
  if (!inherits(data, "exametrika")) {
    stop("Invalid input. The variable must be from exametrika output.")
  }

  # Check if it's a Biclustering-related model
  valid_classes <- c("Biclustering", "ordinalBiclustering", "nominalBiclustering", "ratedBiclustering", "Biclustering_IRM")
  if (!any(class(data) %in% valid_classes)) {
    stop("Invalid input. The variable must be from Biclustering, ordinalBiclustering, nominalBiclustering, or ratedBiclustering.")
  }

  # Validate stat parameter
  if (!stat %in% c("mean", "median", "mode")) {
    stop("stat must be one of: 'mean', 'median', 'mode'")
  }

  # Check FRP dimensionality
  frp_dims <- length(dim(data$FRP))
  is_polytomous <- (frp_dims == 3)

  if (is_polytomous) {
    # Polytomous (3D): Field x Class/Rank x Category
    BCRM <- data$FRP
    maxQ <- dim(BCRM)[3]

    # Calculate expected scores
    FRP_mat <- .calc_expected_scores(BCRM, stat)
    RRV <- t(FRP_mat) # Transpose to Rank x Field

    n_rank <- nrow(RRV)
    n_fld <- ncol(RRV)
    y_label <- paste0("Expected Score (", stat, ")")
    y_limits <- c(1, maxQ)
    y_breaks <- 1:maxQ
  } else {
    # Binary (2D): Field x Class/Rank
    RRV <- t(data$FRP)
    n_rank <- nrow(RRV)
    n_fld <- ncol(RRV)
    y_label <- "Correct Response Rate"
    y_limits <- c(0, 1)
    y_breaks <- seq(0, 1, 0.25)
  }

  # Convert to long format
  plot_data <- data.frame(
    field = rep(1:n_fld, each = n_rank),
    field_label = rep(paste0("F", 1:n_fld), each = n_rank),
    value = as.vector(t(RRV)),
    rank = factor(rep(paste0("R", 1:n_rank), times = n_fld), levels = paste0("R", 1:n_rank)),
    rank_num = rep(1:n_rank, times = n_fld) # For label display
  )

  # Set default for show_labels
  if (is.null(show_labels)) {
    show_labels <- FALSE # Default to FALSE since legend provides rank information
  }

  # Color setup
  if (is.null(colors)) {
    use_colors <- .gg_exametrika_palette(n_rank)
  } else {
    use_colors <- colors[1:n_rank]
  }

  # Title setup
  if (is.logical(title) && title) {
    if (is_polytomous) {
      plot_title <- paste0("Rank Reference Vector (", stat, ")")
    } else {
      plot_title <- "Rank Reference Vector"
    }
  } else if (is.logical(title) && !title) {
    plot_title <- NULL
  } else {
    plot_title <- title
  }

  p <- ggplot(plot_data, aes(x = field, y = value, color = rank)) +
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
    p <- p + geom_text_repel(
      data = plot_data,
      mapping = aes(x = field, y = value, label = rank_num, color = rank),
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
  if (show_legend) {
    p <- p + theme(legend.position = legend_position)
  } else {
    p <- p + theme(legend.position = "none")
  }

  return(p)
}
