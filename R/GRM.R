#' @title Plot Item Category Response Function (ICRF) for GRM from exametrika
#'
#' @description
#' This function takes exametrika GRM output as input and generates
#' Item Category Response Function (ICRF) plots using ggplot2.
#' Each plot shows the probability of selecting each response category
#' as a function of ability (theta).
#'
#' @param data An object of class \code{c("exametrika", "GRM")} from
#'   \code{exametrika::GRM()}.
#' @param items Numeric vector specifying which items to plot.
#'   If \code{NULL} (default), all items are plotted.
#' @param xvariable A numeric vector of length 2 specifying the range of the
#'   x-axis (ability). Default is \code{c(-4, 4)}.
#' @param title Logical or character. If \code{TRUE} (default), display an
#'   auto-generated title. If \code{FALSE}, no title. If a character string,
#'   use it as a custom title (only for single-item plots).
#' @param colors Character vector of colors for each category.
#'   If \code{NULL} (default), a colorblind-friendly palette is used.
#' @param linetype Character or numeric specifying the line type.
#'   Default is \code{"solid"}.
#' @param show_legend Logical. If \code{TRUE} (default), display the legend.
#' @param legend_position Character. Position of the legend.
#'   One of \code{"right"} (default), \code{"top"}, \code{"bottom"},
#'   \code{"left"}, \code{"none"}.
#'
#' @return A list of ggplot objects, one for each item. Each plot shows the
#'   Item Category Response Function for that item.
#'
#' @details
#' The Graded Response Model (GRM) estimates the probability of selecting
#' each ordered response category. For an item with \eqn{K} categories,
#' the ICRF shows \eqn{K} curves, one for each category. At any given
#' ability level, the probabilities across all categories sum to 1.
#'
#' The category probabilities are derived from cumulative probabilities:
#' \deqn{P_k^*(\theta) = \frac{1}{1 + \exp(-a(\theta - b_k))}}
#' \deqn{P_k(\theta) = P_k^*(\theta) - P_{k+1}^*(\theta)}
#'
#' @examples
#' \dontrun{
#' library(exametrika)
#' result <- GRM(J5S1000)
#' plots <- plotICRF_gg(result)
#' plots[[1]] # Show ICRF for the first item
#' combinePlots_gg(plots, selectPlots = 1:5)
#' }
#'
#' @seealso \code{\link{plotICC_gg}}
#'
#' @importFrom ggplot2 ggplot aes geom_line labs theme element_text
#'   scale_color_manual guides guide_legend
#' @export


plotICRF_gg <- function(data,
                        items = NULL,
                        xvariable = c(-4, 4),
                        title = TRUE,
                        colors = NULL,
                        linetype = "solid",
                        show_legend = TRUE,
                        legend_position = "right") {
  if (!all(class(data) %in% c("exametrika", "GRM"))) {
    stop("Invalid input. The variable must be from exametrika output or an output from GRM.")
  }

  params <- data$params
  n_items <- nrow(params)

  if (is.null(items)) {
    items <- 1:n_items
  }
  if (any(items < 1 | items > n_items)) {
    stop("'items' must contain values between 1 and ", n_items)
  }

  # デフォルトのカラーパレット（パッケージ共通）

  # grm_prob相当の計算（exametrikaに依存しないようローカル定義）
  grm_cumprob <- function(theta, a, b) {
    1 / (1 + exp(-a * (theta - b)))
  }

  grm_category_prob <- function(theta, a, b) {
    K <- length(b) + 1
    cum_p <- numeric(K + 1)
    cum_p[1] <- 1
    cum_p[K + 1] <- 0
    for (k in 1:(K - 1)) {
      cum_p[k + 1] <- grm_cumprob(theta, a, b[k])
    }
    p <- numeric(K)
    for (k in 1:K) {
      p[k] <- cum_p[k] - cum_p[k + 1]
    }
    return(p)
  }

  thetas <- seq(xvariable[1], xvariable[2], length.out = 501)

  plots <- list()

  for (idx in seq_along(items)) {
    i <- items[idx]
    a <- params[i, 1]
    b <- as.numeric(params[i, -1])
    b <- b[!is.na(b)]
    K <- length(b) + 1

    # カテゴリ応答確率を計算
    prob_matrix <- matrix(0, nrow = length(thetas), ncol = K)
    for (t in seq_along(thetas)) {
      prob_matrix[t, ] <- grm_category_prob(thetas[t], a, b)
    }

    # long format に変換
    plot_data <- data.frame(
      theta = rep(thetas, K),
      probability = as.vector(prob_matrix),
      category = factor(rep(paste("Category", 1:K), each = length(thetas)))
    )

    # 色の設定
    if (is.null(colors)) {
      use_colors <- .gg_exametrika_palette(K)
    } else {
      use_colors <- colors[1:K]
    }

    # タイトルの設定
    if (is.logical(title) && title) {
      plot_title <- paste("Item Category Response Function,", rownames(params)[i])
    } else if (is.logical(title) && !title) {
      plot_title <- NULL
    } else {
      plot_title <- title
    }

    p <- ggplot(plot_data, aes(x = theta, y = probability, color = category)) +
      geom_line(linetype = linetype) +
      scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.25)) +
      scale_color_manual(values = use_colors) +
      labs(
        title = plot_title,
        x = "ability",
        y = "probability",
        color = NULL
      )

    # 凡例の制御
    if (show_legend) {
      p <- p + theme(legend.position = legend_position)
    } else {
      p <- p + theme(legend.position = "none")
    }

    plots[[idx]] <- p
  }

  return(plots)
}


#' @title GRM Item Information Function
#'
#' @description
#' Computes the Item Information Function (IIF) for the Graded Response Model.
#' The information function indicates how precisely an item measures ability
#' at different theta levels.
#'
#' @param theta Numeric. The ability parameter (theta).
#' @param a Numeric. The slope (discrimination) parameter.
#' @param b Numeric vector. The threshold (boundary) parameters.
#'
#' @return A numeric value representing the item information at the given
#'   ability level.
#'
#' @details
#' For GRM, the Item Information Function is computed as:
#' \deqn{I(\theta) = a^2 \sum_{k=1}^{K-1} P_k^*(\theta) [1 - P_k^*(\theta)]}
#'
#' where \eqn{P_k^*(\theta)} is the cumulative probability of scoring in
#' category \eqn{k} or above.
#'
#' @examples
#' # Information at ability = 0 for a 5-category item
#' ItemInformationFunc_GRM(theta = 0, a = 1.5, b = c(-1, -0.5, 0.5, 1))
#'
#' @seealso \code{\link{plotICRF_gg}}
#'
#' @export

ItemInformationFunc_GRM <- function(theta, a, b) {
  grm_cumprob <- function(theta, a, b) {
    1 / (1 + exp(-a * (theta - b)))
  }

  K <- length(b) + 1  # number of categories
  info <- 0

  for (k in seq_along(b)) {
    Pk_star <- grm_cumprob(theta, a, b[k])
    info <- info + Pk_star * (1 - Pk_star)
  }

  info <- a^2 * info
  return(info)
}
