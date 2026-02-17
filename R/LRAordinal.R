#' @title Plot Item Category Boundary Response from exametrika
#'
#' @description
#' This function takes exametrika LRAordinal output as input and generates an
#' Item Category Boundary Response (ICBR) plot using ggplot2. The plot shows
#' cumulative probability curves for each category boundary across latent ranks.
#' For each item, multiple lines represent the probability of scoring at or above
#' each category boundary.
#'
#' @param data An object of class \code{c("exametrika", "LRAordinal")} from
#'   \code{exametrika::LRA()} with \code{dataType = "ordinal"}.
#' @param items Integer vector specifying which items to plot. Default is all items.
#' @param title Logical or character. If \code{TRUE} (default), display item labels
#'   as subplot titles. If \code{FALSE}, no titles. If a character string,
#'   use it as the main plot title.
#' @param colors Character vector. Colors for category boundary lines.
#'   If \code{NULL} (default), uses the package default palette.
#' @param linetype Character or numeric vector. Line types for category boundaries.
#'   If \code{NULL} (default), uses automatic line type assignment.
#' @param show_legend Logical. If \code{TRUE}, display the legend showing category labels.
#'   Default is \code{TRUE}.
#' @param legend_position Character. Position of the legend.
#'   One of \code{"right"} (default), \code{"top"}, \code{"bottom"},
#'   \code{"left"}, \code{"none"}.
#'
#' @return A single ggplot object with faceted subplots for each item,
#'   or a combined plot using gridExtra if faceting is not suitable.
#'
#' @details
#' The Item Category Boundary Response (ICBR) visualizes how the probability
#' of reaching each category boundary changes across latent ranks. This is
#' particularly useful for understanding the difficulty of each response category
#' in ordinal items.
#'
#' For an item with \eqn{K} categories (0, 1, ..., K-1), the ICBR shows:
#' \itemize{
#'   \item Line 1: P(response >= 1 | rank)
#'   \item Line 2: P(response >= 2 | rank)
#'   \item ...
#'   \item Line K: P(response >= K | rank) (always 1.0 for category 0)
#' }
#'
#' Higher ranks typically show lower probabilities for higher categories,
#' indicating lower ability levels.
#'
#' @examples
#' \dontrun{
#' library(exametrika)
#' result <- LRA(J15S3810, nrank = 4, dataType = "ordinal")
#'
#' # Plot first 4 items
#' plot <- plotICBR_gg(result, items = 1:4)
#' plot
#'
#' # Custom colors and title
#' plot <- plotICBR_gg(result, items = 1:6,
#'                     title = "Item Category Boundary Response",
#'                     colors = c("red", "blue", "green", "purple"))
#' plot
#' }
#'
#' @seealso \code{\link{plotScoreFreq_gg}}, \code{\link{plotLRD_gg}}, \code{\link{plotRMP_gg}}
#'
#' @importFrom ggplot2 ggplot aes geom_line facet_wrap labs theme element_text
#'   scale_color_manual scale_linetype_manual scale_y_continuous
#' @importFrom tidyr pivot_longer
#' @export

plotICBR_gg <- function(data,
                        items = NULL,
                        title = TRUE,
                        colors = NULL,
                        linetype = NULL,
                        show_legend = TRUE,
                        legend_position = "right") {

  # クラスチェック
  if (!all(c("exametrika", "LRAordinal") %in% class(data))) {
    stop("Invalid input. The data must be from exametrika LRAordinal output (dataType = 'ordinal').")
  }

  # ICBRデータの存在確認
  if (!"ICBR" %in% names(data)) {
    stop("ICBR data not found in the input object.")
  }

  icbr_data <- data$ICBR

  # 項目の選択
  all_items <- unique(icbr_data$ItemLabel)
  if (is.null(items)) {
    selected_items <- all_items
  } else {
    # items が数値インデックスの場合、ItemLabelに変換
    if (is.numeric(items)) {
      selected_items <- all_items[items]
    } else {
      selected_items <- items
    }
  }

  # 選択された項目のみをフィルタリング
  plot_data <- icbr_data[icbr_data$ItemLabel %in% selected_items, ]

  # Wide形式からLong形式に変換
  # rank1, rank2, ... → Rank列と Probability列
  rank_cols <- grep("^rank[0-9]+$", colnames(plot_data), value = TRUE)

  long_data <- tidyr::pivot_longer(
    plot_data,
    cols = all_of(rank_cols),
    names_to = "Rank",
    values_to = "Probability",
    names_prefix = "rank"
  )

  # Rankを数値に変換
  long_data$Rank <- as.numeric(long_data$Rank)

  # ランクを逆順に変換（低能力→高能力の順にプロットするため）
  # exametrikaではrank1が高能力、rank4が低能力なので、逆転させる
  n_ranks <- max(long_data$Rank)
  long_data$Rank <- n_ranks - long_data$Rank + 1

  # CategoryLabelから項目名プレフィックスを除去（例: "V1-Cat1" → "Cat1"）
  # これにより、全項目で同じカテゴリラベルを使用し、色パレットの問題を回避
  long_data$Category <- sub("^.*-", "", long_data$CategoryLabel)

  # 色の設定
  n_categories <- length(unique(long_data$Category))
  if (is.null(colors)) {
    colors <- .gg_exametrika_palette(n_categories)
  }

  # linetypeの設定
  if (is.null(linetype)) {
    # 自動的にlinetypeを割り当て
    linetype_options <- c("solid", "dashed", "dotted", "dotdash", "longdash", "twodash")
    linetype <- rep(linetype_options, length.out = n_categories)
  }

  # プロット作成
  p <- ggplot(long_data, aes(x = Rank, y = Probability,
                             color = Category,
                             linetype = Category,
                             group = interaction(ItemLabel, Category))) +
    geom_line(linewidth = 0.8) +
    facet_wrap(~ ItemLabel) +
    scale_y_continuous(breaks = seq(0, 1, 0.25)) +
    labs(
      x = "Rank",
      y = "Probability",
      color = "Category",
      linetype = "Category"
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
    if (title && length(selected_items) == 1) {
      p <- p + labs(title = paste("Item Category Boundary Response:", selected_items[1]))
    } else if (title && length(selected_items) > 1) {
      p <- p + labs(title = "Item Category Boundary Response")
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


#' @title Plot Item Category Reference Profile from exametrika
#'
#' @description
#' This function takes exametrika LRAordinal or LRArated output as input and generates an
#' Item Category Reference Profile (ICRP) plot using ggplot2. The plot shows
#' response probability curves for each category across latent ranks.
#' For each item, multiple lines represent the probability of selecting each response category.
#'
#' @param data An object of class \code{c("exametrika", "LRAordinal")} or
#'   \code{c("exametrika", "LRArated")} from \code{exametrika::LRA()}.
#' @param items Integer vector specifying which items to plot. Default is all items.
#' @param title Logical or character. If \code{TRUE} (default), display item labels
#'   as subplot titles. If \code{FALSE}, no titles. If a character string,
#'   use it as the main plot title.
#' @param colors Character vector. Colors for category lines.
#'   If \code{NULL} (default), uses the package default palette.
#' @param linetype Character or numeric vector. Line types for categories.
#'   If \code{NULL} (default), uses automatic line type assignment.
#' @param show_legend Logical. If \code{TRUE}, display the legend showing category labels.
#'   Default is \code{TRUE}.
#' @param legend_position Character. Position of the legend.
#'   One of \code{"right"} (default), \code{"top"}, \code{"bottom"},
#'   \code{"left"}, \code{"none"}.
#'
#' @return A single ggplot object with faceted subplots for each item.
#'
#' @details
#' The Item Category Reference Profile (ICRP) visualizes how the response probability
#' for each category changes across latent ranks. Unlike ICBR which shows cumulative
#' probabilities, ICRP shows the raw probability of selecting each specific category.
#'
#' For an item with \eqn{K} categories (0, 1, ..., K-1), the ICRP shows:
#' \itemize{
#'   \item Line for Cat0: P(response = 0 | rank)
#'   \item Line for Cat1: P(response = 1 | rank)
#'   \item ...
#'   \item Line for CatK: P(response = K | rank)
#' }
#'
#' The sum of all probabilities at each rank equals 1.0, as they represent
#' mutually exclusive response options.
#'
#' Typically, higher ranks (higher ability) show higher probabilities for
#' higher categories and lower probabilities for lower categories.
#'
#' @examples
#' \dontrun{
#' library(exametrika)
#' result <- LRA(J15S3810, nrank = 4, dataType = "ordinal")
#'
#' # Plot first 4 items
#' plot <- plotICRP_gg(result, items = 1:4)
#' plot
#'
#' # Custom colors and title
#' plot <- plotICRP_gg(result, items = 1:6,
#'                     title = "Item Category Reference Profile",
#'                     colors = c("red", "blue", "green", "purple"))
#' plot
#' }
#'
#' @seealso \code{\link{plotICBR_gg}}, \code{\link{plotScoreFreq_gg}}, \code{\link{plotLRD_gg}}
#'
#' @importFrom ggplot2 ggplot aes geom_line facet_wrap labs theme element_text
#'   scale_color_manual scale_linetype_manual scale_y_continuous
#' @importFrom tidyr pivot_longer
#' @export

plotICRP_gg <- function(data,
                        items = NULL,
                        title = TRUE,
                        colors = NULL,
                        linetype = NULL,
                        show_legend = TRUE,
                        legend_position = "right") {

  # クラスチェック
  is_LRAordinal <- all(c("exametrika", "LRAordinal") %in% class(data))
  is_LRArated <- all(c("exametrika", "LRArated") %in% class(data))

  if (!is_LRAordinal && !is_LRArated) {
    stop("Invalid input. The data must be from exametrika LRAordinal or LRArated output.")
  }

  # ICRPデータの存在確認
  if (!"ICRP" %in% names(data)) {
    stop("ICRP data not found in the input object.")
  }

  icrp_data <- data$ICRP

  # 項目の選択
  all_items <- unique(icrp_data$ItemLabel)
  if (is.null(items)) {
    selected_items <- all_items
  } else {
    # items が数値インデックスの場合、ItemLabelに変換
    if (is.numeric(items)) {
      selected_items <- all_items[items]
    } else {
      selected_items <- items
    }
  }

  # 選択された項目のみをフィルタリング
  plot_data <- icrp_data[icrp_data$ItemLabel %in% selected_items, ]

  # Wide形式からLong形式に変換
  # rank1, rank2, ... → Rank列と Probability列
  rank_cols <- grep("^rank[0-9]+$", colnames(plot_data), value = TRUE)

  long_data <- tidyr::pivot_longer(
    plot_data,
    cols = all_of(rank_cols),
    names_to = "Rank",
    values_to = "Probability",
    names_prefix = "rank"
  )

  # Rankを数値に変換
  long_data$Rank <- as.numeric(long_data$Rank)

  # ランクを逆順に変換（低能力→高能力の順にプロットするため）
  # exametrikaではrank1が低能力、rank4が高能力なので、逆転させる
  n_ranks <- max(long_data$Rank)
  long_data$Rank <- n_ranks - long_data$Rank + 1

  # CategoryLabelから項目名プレフィックスを除去（例: "V1-Cat1" → "Cat1"）
  # これにより、全項目で同じカテゴリラベルを使用し、色パレットの問題を回避
  long_data$Category <- sub("^.*-", "", long_data$CategoryLabel)

  # 色の設定
  n_categories <- length(unique(long_data$Category))
  if (is.null(colors)) {
    colors <- .gg_exametrika_palette(n_categories)
  }

  # linetypeの設定
  if (is.null(linetype)) {
    # 自動的にlinetypeを割り当て
    linetype_options <- c("solid", "dashed", "dotted", "dotdash", "longdash", "twodash")
    linetype <- rep(linetype_options, length.out = n_categories)
  }

  # プロット作成
  p <- ggplot(long_data, aes(x = Rank, y = Probability,
                             color = Category,
                             linetype = Category,
                             group = interaction(ItemLabel, Category))) +
    geom_line(linewidth = 0.8) +
    facet_wrap(~ ItemLabel) +
    scale_y_continuous(breaks = seq(0, 1, 0.25)) +
    labs(
      x = "Rank",
      y = "Probability",
      color = "Category",
      linetype = "Category"
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
    if (title && length(selected_items) == 1) {
      p <- p + labs(title = paste("Item Category Reference Profile:", selected_items[1]))
    } else if (title && length(selected_items) > 1) {
      p <- p + labs(title = "Item Category Reference Profile")
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
