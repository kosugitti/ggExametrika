#' @title Plot Field Cumulative Boundary Reference from exametrika
#'
#' @description
#' This function takes exametrika ordinalBiclustering output as input and generates a
#' Field Cumulative Boundary Reference (FCBR) plot using ggplot2. The plot shows
#' cumulative probability curves for each category boundary across latent classes or ranks.
#' For each field, multiple lines represent the probability of scoring at or above
#' each category boundary.
#'
#' @param data An object of class \code{c("exametrika", "ordinalBiclustering")} from
#'   \code{exametrika::Biclustering()} with \code{dataType = "ordinal"}.
#' @param fields Integer vector specifying which fields to plot. Default is all fields.
#' @param title Logical or character. If \code{TRUE} (default), display field labels
#'   as subplot titles. If \code{FALSE}, no titles. If a character string,
#'   use it as the main plot title.
#' @param colors Character vector. Colors for category boundary lines.
#'   If \code{NULL} (default), uses the package default palette.
#' @param linetype Character or numeric vector. Line types for category boundaries.
#'   If \code{NULL} (default), uses automatic line type assignment.
#' @param show_legend Logical. If \code{TRUE}, display the legend showing boundary labels.
#'   Default is \code{TRUE}.
#' @param legend_position Character. Position of the legend.
#'   One of \code{"right"} (default), \code{"top"}, \code{"bottom"},
#'   \code{"left"}, \code{"none"}.
#'
#' @return A single ggplot object with faceted subplots for each field.
#'
#' @details
#' The Field Cumulative Boundary Reference (FCBR) visualizes how the probability
#' of reaching each category boundary changes across latent classes or ranks in
#' ordinal biclustering. This is particularly useful for understanding the difficulty
#' of each response category threshold across different ability levels.
#'
#' For a field with \eqn{K} categories (1, 2, ..., K), the FCBR shows:
#' \itemize{
#'   \item Line 1: P(response >= 1 | class/rank) = 1.0 (always)
#'   \item Line 2: P(response >= 2 | class/rank)
#'   \item Line 3: P(response >= 3 | class/rank)
#'   \item ...
#'   \item Line K: P(response >= K | class/rank)
#' }
#'
#' The boundary probabilities are calculated by summing the probabilities of all
#' categories at or above the boundary threshold. P(Q>=1) is always 1.0 and appears
#' as a horizontal line at the top. Higher classes/ranks (higher ability) typically
#' show higher probabilities for higher boundaries.
#'
#' @examples
#' \dontrun{
#' library(exametrika)
#' # Ordinal biclustering example with polytomous data
#' result <- Biclustering(OrdinalData, ncls = 4, dataType = "ordinal")
#'
#' # Plot first 4 fields
#' plot <- plotFCBR_gg(result, fields = 1:4)
#' plot
#'
#' # Custom colors and title
#' plot <- plotFCBR_gg(result, fields = 1:6,
#'                     title = "Field Cumulative Boundary Reference",
#'                     colors = c("red", "blue", "green", "purple"))
#' plot
#' }
#'
#' @seealso \code{\link{plotFCRP_gg}}, \code{\link{plotScoreField_gg}}, \code{\link{plotArray_gg}}
#'
#' @importFrom ggplot2 ggplot aes geom_line facet_wrap labs theme element_text
#'   scale_color_manual scale_linetype_manual scale_y_continuous
#' @export

plotFCBR_gg <- function(data,
                        fields = NULL,
                        title = TRUE,
                        colors = NULL,
                        linetype = NULL,
                        show_legend = TRUE,
                        legend_position = "right") {

  # クラスチェック - ordinalBiclustering専用
  if (!all(c("exametrika", "ordinalBiclustering") %in% class(data))) {
    stop("Invalid input. The data must be from exametrika ordinalBiclustering output (dataType = 'ordinal').")
  }

  # FRPデータの存在確認（ordinalBiclusteringではBCRMがFRPとして格納される）
  if (!"FRP" %in% names(data)) {
    stop("FRP (BCRM) data not found in the input object.")
  }

  BCRM <- data$FRP  # 3次元配列: [field, class/rank, category]
  nfld <- dim(BCRM)[1]
  ncls <- dim(BCRM)[2]
  maxQ <- dim(BCRM)[3]
  msg <- data$msg  # "Class" or "Rank"

  # フィールドの選択
  if (is.null(fields)) {
    selected_fields <- 1:nfld
  } else {
    if (!is.numeric(fields) || any(fields < 1 | fields > nfld)) {
      stop("'fields' must be a numeric vector with values between 1 and ", nfld)
    }
    selected_fields <- fields
  }

  # 境界数（カテゴリ数）- P(Q>=1), P(Q>=2), ... P(Q>=maxQ)を全て表示
  n_boundaries <- maxQ

  # 各フィールド・クラス・境界の確率を計算
  # Boundary b: P(Q >= b) = sum(BCRM[f, cc, b:maxQ])
  plot_data_list <- list()

  for (f in selected_fields) {
    for (b in 1:n_boundaries) {
      q_threshold <- b
      for (cc in 1:ncls) {
        boundary_prob <- sum(BCRM[f, cc, q_threshold:maxQ])
        plot_data_list[[length(plot_data_list) + 1]] <- data.frame(
          Field = paste0("Field ", f),
          ClassRank = cc,
          Boundary = paste0("P(Q>=", q_threshold, ")"),
          Probability = boundary_prob
        )
      }
    }
  }

  # データフレームに結合
  long_data <- do.call(rbind, plot_data_list)

  # Boundaryを因子化（順序を保持）
  boundary_levels <- paste0("P(Q>=", 1:maxQ, ")")
  long_data$Boundary <- factor(long_data$Boundary, levels = boundary_levels)

  # 色の設定
  if (is.null(colors)) {
    colors <- .gg_exametrika_palette(n_boundaries)
  }

  # linetypeの設定
  if (is.null(linetype)) {
    # 自動的にlinetypeを割り当て
    linetype_options <- c("solid", "dashed", "dotted", "dotdash", "longdash", "twodash")
    linetype <- rep(linetype_options, length.out = n_boundaries)
  }

  # プロット作成
  p <- ggplot(long_data, aes(x = ClassRank, y = Probability,
                             color = Boundary,
                             linetype = Boundary,
                             group = interaction(Field, Boundary))) +
    geom_line(linewidth = 0.8) +
    geom_point(size = 2) +
    facet_wrap(~ Field) +
    scale_y_continuous(breaks = seq(0, 1, 0.25), limits = c(0, 1)) +
    scale_x_continuous(breaks = 1:ncls) +
    labs(
      x = paste("Latent", msg),
      y = "Boundary Probability",
      color = "Boundary",
      linetype = "Boundary"
    ) +
    theme(
      strip.text = element_text(size = 10, face = "bold"),
      legend.position = legend_position
    )

  # 色とlinetypeのスケール設定
  if (!is.null(colors)) {
    p <- p + scale_color_manual(values = colors)
  }
  if (!is.null(linetype)) {
    p <- p + scale_linetype_manual(values = linetype)
  }

  # タイトルの設定
  if (is.logical(title)) {
    if (title && length(selected_fields) == 1) {
      p <- p + labs(title = paste("Field Cumulative Boundary Reference: Field", selected_fields[1]))
    } else if (title && length(selected_fields) > 1) {
      p <- p + labs(title = "Field Cumulative Boundary Reference")
    }
    # title = FALSE の場合は何もしない
  } else if (is.character(title)) {
    p <- p + labs(title = title)
  }

  # 凡例の制御
  if (!show_legend) {
    p <- p + theme(legend.position = "none")
  }

  return(p)
}
