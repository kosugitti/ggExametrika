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
#'   use it as a custom title applied to every item's plot.
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
#' @examplesIf requireNamespace("exametrika", quietly = TRUE)
#' library(exametrika)
#' \donttest{
#' result <- GRM(J5S1000)
#' plots <- plotICRF_gg(result)
#' plots[[1]] # Show ICRF for the first item
#' combinePlots_gg(plots, selectPlots = 1:5)
#' }
#'
#' @seealso \code{\link{plotICC_gg}}
#'
#' @importFrom ggplot2 ggplot aes geom_line labs theme element_text scale_color_manual
#' @export


plotICRF_gg <- function(data,
                        items = NULL,
                        xvariable = c(-4, 4),
                        title = TRUE,
                        colors = NULL,
                        linetype = "solid",
                        show_legend = TRUE,
                        legend_position = "right") {
  .validate_exametrika(data, "GRM")

  params <- data$params
  n_items <- nrow(params)

  if (is.null(items)) {
    items <- 1:n_items
  }
  if (any(items < 1 | items > n_items)) {
    stop("'items' must contain values between 1 and ", n_items)
  }

  # Default color palette (shared across package)

  # Compute GRM probabilities (defined locally to avoid exametrika dependency)
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

    # Compute category response probabilities
    prob_matrix <- matrix(0, nrow = length(thetas), ncol = K)
    for (t in seq_along(thetas)) {
      prob_matrix[t, ] <- grm_category_prob(thetas[t], a, b)
    }

    # Convert to long format
    plot_data <- data.frame(
      theta = rep(thetas, K),
      probability = as.vector(prob_matrix),
      category = factor(rep(paste("Category", 1:K), each = length(thetas)))
    )

    # Color setup
    use_colors <- .resolve_colors(colors, K)

    # Title setup
    plot_title <- .resolve_title(title, paste("Item Category Response Function,", rownames(params)[i]))

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

    # Legend control
    p <- .apply_legend(p, show_legend, legend_position)

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
#' The information is Samejima's (1969) item information for the GRM,
#' computed identically to \code{exametrika::grm_iif} (>= 1.15.0.9000)
#' so that ggExametrika plots match the base plots of the parent
#' package:
#' \deqn{I(\theta) = \sum_{k=1}^{K} \frac{[P_k'(\theta)]^2}{P_k(\theta)}}
#'
#' where \eqn{P_k(\theta) = P_{k-1}^*(\theta) - P_k^*(\theta)} is the
#' category response probability, \eqn{P_k^*(\theta)} is the cumulative
#' (boundary) probability with \eqn{P_0^* = 1} and \eqn{P_K^* = 0}, and
#' \eqn{P_k^{*\prime}(\theta) = a P_k^*(\theta) [1 - P_k^*(\theta)]}.
#' The logistic metric of the parent package's estimation is used as is
#' (no 1.702 scaling constant).
#'
#' @examples
#' # Information at ability = 0 for a 5-category item
#' ItemInformationFunc_GRM(theta = 0, a = 1.5, b = c(-1, -0.5, 0.5, 1))
#'
#' @seealso \code{\link{plotICRF_gg}}
#'
#' @export

ItemInformationFunc_GRM <- function(theta, a, b) {
  K <- length(b) + 1 # number of categories
  # Boundary probabilities P*_0 = 1 > P*_1 > ... > P*_{K-1} > P*_K = 0
  cum_p <- c(1, 1 / (1 + exp(-a * (theta - b))), 0)
  # Category probabilities P_k = P*_{k-1} - P*_k
  p <- cum_p[1:K] - cum_p[2:(K + 1)]
  # dP*_k/dtheta = a P*_k (1 - P*_k); zero at both endpoints
  d_cum <- a * cum_p * (1 - cum_p)
  d_p <- d_cum[1:K] - d_cum[2:(K + 1)]
  info <- sum(d_p^2 / pmax(p, 1e-10))
  return(unname(info))
}
