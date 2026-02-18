#' Plot Score-Field Heatmap (ScoreField) for Polytomous Biclustering
#'
#' @description
#' Creates a heatmap visualization showing the expected scores for each field
#' across latent classes or ranks in polytomous biclustering models
#' (nominalBiclustering, ordinalBiclustering).
#'
#' The expected score for each field-class/rank combination is calculated as
#' the sum of (category × probability) across all categories.
#'
#' @param data An exametrika model object from nominalBiclustering or ordinalBiclustering.
#' @param title Logical or character. If TRUE (default), displays an automatic title.
#'   If FALSE, no title is displayed. If a character string, uses it as the title.
#' @param colors Character vector of colors for the gradient, or NULL (default) to use
#'   a colorblind-friendly yellow-orange-red palette. If provided, should be a vector
#'   of at least 2 colors for the gradient.
#' @param show_legend Logical. If TRUE (default), displays the color scale legend.
#' @param legend_position Character. Position of the legend: "right" (default),
#'   "left", "top", "bottom", or "none".
#' @param show_values Logical. If TRUE (default), displays the expected score values
#'   as text on each cell of the heatmap.
#' @param text_size Numeric. Size of the text labels showing values (default: 3.5).
#'   Only used when show_values = TRUE.
#'
#' @return A ggplot2 object representing the Score-Field heatmap.
#'
#' @details
#' This function is designed for polytomous (multi-valued) biclustering models
#' where items have more than two response categories. It displays the expected
#' score (weighted sum of category probabilities) for each field across all
#' latent classes or ranks.
#'
#' The heatmap uses:
#' - **Y-axis**: Fields (F1, F2, ...)
#' - **X-axis**: Latent Classes (C1, C2, ...) or Ranks (R1, R2, ...)
#' - **Color**: Expected score magnitude (lighter = lower, darker/redder = higher)
#' - **Text**: Actual expected score values (optional, controlled by show_values)
#'
#' Higher expected scores indicate that students in that class/rank are expected
#' to achieve higher scores in that field.
#'
#' @examples
#' \dontrun{
#' # Ordinal Biclustering example
#' data(J35S500)
#' result <- Biclustering(J35S500, ncls = 5, nfld = 5, method = "R")
#'
#' # Basic plot
#' plotScoreField_gg(result)
#'
#' # Custom title and hide values
#' plotScoreField_gg(result,
#'   title = "Expected Scores by Field and Rank",
#'   show_values = FALSE
#' )
#'
#' # Custom color gradient
#' plotScoreField_gg(result,
#'   colors = c("white", "blue", "darkblue"),
#'   legend_position = "bottom"
#' )
#'
#' # Nominal Biclustering example
#' data(J20S600)
#' result_nom <- Biclustering(J20S600, ncls = 5, nfld = 4)
#' plotScoreField_gg(result_nom)
#' }
#'
#' @seealso
#' \code{\link{plotFCRP_gg}} for field category response profiles,
#' \code{\link{plotFCBR_gg}} for field cumulative boundary reference,
#' \code{\link{plotArray_gg}} for array plots,
#' \code{\link{plotScoreRank_gg}} for score-rank heatmaps
#'
#' @export
plotScoreField_gg <- function(data,
                              title = TRUE,
                              colors = NULL,
                              show_legend = TRUE,
                              legend_position = "right",
                              show_values = TRUE,
                              text_size = 3.5) {
  # Input validation
  if (!inherits(data, "exametrika")) {
    stop("Input must be an exametrika model object")
  }

  # Check if this is a polytomous biclustering model
  valid_models <- c("nominalBiclustering", "ordinalBiclustering")
  if (!any(class(data) %in% valid_models)) {
    stop("ScoreField plot is only available for nominalBiclustering and ordinalBiclustering models")
  }

  # Check if FRP exists and has 3 dimensions (polytomous data)
  if (is.null(data$FRP)) {
    stop("FRP (Field Reference Profile) data not found in model object")
  }

  if (length(dim(data$FRP)) != 3) {
    stop("ScoreField plot requires polytomous data (FRP must be a 3D array)")
  }

  # Extract data
  BCRM <- data$FRP # Field × Class/Rank × Category
  nfld <- dim(BCRM)[1]
  ncls <- dim(BCRM)[2]
  maxQ <- dim(BCRM)[3]
  msg <- data$msg # "Class" or "Rank"

  # Calculate expected scores for each field × class/rank
  score_mat <- matrix(0, nrow = nfld, ncol = ncls)
  for (f in 1:nfld) {
    for (cc in 1:ncls) {
      # Expected score = sum(category * probability)
      # Categories are numbered 1, 2, 3, ... maxQ
      score_mat[f, cc] <- sum((1:maxQ) * BCRM[f, cc, ])
    }
  }

  # Convert to long format for ggplot
  plot_data <- data.frame(
    Field = rep(paste0("F", 1:nfld), each = ncls),
    LatentVar = rep(1:ncls, times = nfld),
    ExpectedScore = as.vector(t(score_mat))
  )

  # Create labels for latent variable
  latent_labels <- paste0(substr(msg, 1, 1), 1:ncls)
  plot_data$LatentLabel <- factor(
    plot_data$LatentVar,
    levels = 1:ncls,
    labels = latent_labels
  )

  # Set field order (F1 at top, increasing downward)
  plot_data$Field <- factor(plot_data$Field, levels = rev(paste0("F", 1:nfld)))

  # Determine title
  if (is.logical(title)) {
    if (title) {
      plot_title <- "Score Field Heatmap"
    } else {
      plot_title <- NULL
    }
  } else if (is.character(title)) {
    plot_title <- title
  } else {
    plot_title <- NULL
  }

  # Set color palette
  if (is.null(colors)) {
    # Default: YlOrRd palette (yellow-orange-red, colorblind-friendly)
    colors <- c("#FFFFCC", "#FFEDA0", "#FED976", "#FEB24C", "#FD8D3C",
                "#FC4E2A", "#E31A1C", "#BD0026", "#800026")
  }

  # Create base plot
  p <- ggplot(plot_data, aes(x = LatentLabel, y = Field, fill = ExpectedScore)) +
    geom_tile(color = "white", linewidth = 0.5) +
    scale_fill_gradientn(
      colors = colors,
      name = "Expected\nScore"
    ) +
    labs(
      title = plot_title,
      x = paste("Latent", msg),
      y = "Field"
    ) +
    theme_minimal() +
    theme(
      axis.text.x = element_text(angle = 0, hjust = 0.5),
      axis.text.y = element_text(),
      panel.grid = element_blank(),
      legend.position = legend_position
    )

  # Add text labels if requested
  if (show_values) {
    p <- p + geom_text(
      aes(label = sprintf("%.2f", ExpectedScore)),
      size = text_size,
      color = "black"
    )
  }

  # Handle legend visibility
  if (!show_legend) {
    p <- p + theme(legend.position = "none")
  }

  return(p)
}
