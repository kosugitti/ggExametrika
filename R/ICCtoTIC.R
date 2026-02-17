#' @title Plot Item Characteristic Curves (ICC) from exametrika
#'
#' @description
#' This function takes exametrika IRT output as input and generates
#' Item Characteristic Curves (ICC) using ggplot2. ICC shows the probability
#' of a correct response as a function of ability (theta).
#'
#' @param data An object of class \code{c("exametrika", "IRT")} from
#'   \code{exametrika::IRT()}.
#' @param xvariable A numeric vector of length 2 specifying the range of the
#'   x-axis (ability). Default is \code{c(-4, 4)}.
#'
#' @return A list of ggplot objects, one for each item. Each plot shows the
#'   Item Characteristic Curve for that item.
#'
#' @details
#' The function supports 2PL, 3PL, and 4PL IRT models:
#' \itemize{
#'   \item 2PL: slope (a) and location (b) parameters
#'   \item 3PL: adds lower asymptote (c) parameter
#'   \item 4PL: adds upper asymptote (d) parameter
#' }
#'
#' The ICC is computed using the four-parameter logistic model:
#' \deqn{P(\theta) = c + \frac{d - c}{1 + \exp(-a(\theta - b))}}
#'
#' @examples
#' \dontrun{
#' library(exametrika)
#' result <- IRT(J15S500, model = 3)
#' plots <- plotICC_gg(result)
#' plots[[1]] # Show ICC for the first item
#' combinePlots_gg(plots, selectPlots = 1:6) # Show first 6 items
#' }
#'
#' @seealso \code{\link{plotIIC_gg}}, \code{\link{plotTIC_gg}}
#'
#' @importFrom ggplot2 ggplot
#' @importFrom ggplot2 xlim
#' @importFrom ggplot2 ylim
#' @importFrom ggplot2 stat_function
#' @importFrom ggplot2 labs
#' @export


plotICC_gg <- function(data, xvariable = c(-4, 4)) {
  if (!all(class(data) %in% c("exametrika", "IRT"))) {
    stop("Invalid input. The variable must be from exametrika output or an output from IRT.")
  }

  Item_Characteristic_function <- function(x, slope = 1, location, lowerAsym = 0, upperAsym = 1) {
    lowerAsym + ((upperAsym - lowerAsym) / (1 + exp(-1 * slope * (x - location))))
  }

  n_params <- ncol(data$params)

  if (n_params < 2 || n_params > 4) {
    stop("Invalid number of parameters.")
  }

  plots <- list()

  for (i in 1:nrow(data$params)) {
    args <- c(slope = data$params$slope[i], location = data$params$location[i])
    if (n_params == 3) {
      args["lowerAsym"] <- data$params$lowerAsym[i]
    }
    if (n_params == 4) {
      args["upperAsym"] <- data$params$upperAsym[i]
    }

    plots[[i]] <- ggplot(data = data.frame(x = xvariable)) +
      xlim(xvariable[1], xvariable[2]) +
      scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.25)) +
      stat_function(fun = Item_Characteristic_function, args = args) +
      labs(
        title = paste0("Item Characteristic Curve, ", rownames(data$params)[i]),
        x = "ability",
        y = "probability"
      )
  }

  return(plots)
}


#' @title Four-Parameter Logistic Model
#'
#' @description
#' Computes the probability of a correct response using the four-parameter
#' logistic model (4PLM) in Item Response Theory.
#'
#' @param x Numeric. The ability parameter (theta).
#' @param a Numeric. The slope (discrimination) parameter. Default is 1.
#' @param b Numeric. The location (difficulty) parameter.
#' @param c Numeric. The lower asymptote (guessing) parameter. Default is 0.
#' @param d Numeric. The upper asymptote (carelessness) parameter. Default is 1.
#'
#' @return A numeric value representing the probability of a correct response.
#'
#' @details
#' The four-parameter logistic model extends the 3PLM by adding an upper
#' asymptote parameter \code{d}, which accounts for careless errors by
#' high-ability examinees.
#'
#' The model formula is:
#' \deqn{P(\theta) = c + \frac{d - c}{1 + \exp(-a(\theta - b))}}
#'
#' Special cases:
#' \itemize{
#'   \item 1PLM: \code{a = 1}, \code{c = 0}, \code{d = 1}
#'   \item 2PLM: \code{c = 0}, \code{d = 1}
#'   \item 3PLM: \code{d = 1}
#' }
#'
#' @examples
#' # Compute probability for ability = 0, difficulty = 0
#' LogisticModel(x = 0, a = 1, b = 0, c = 0, d = 1) # Returns 0.5
#'
#' # 3PLM with guessing parameter
#' LogisticModel(x = -3, a = 1.5, b = 0, c = 0.2, d = 1)
#'
#' @seealso \code{\link{ItemInformationFunc}}
#'
#' @export

LogisticModel <- function(x, a = 1, b, c = 0, d = 1) {
  p <- c + ((d - c) / (1 + exp(-a * (x - b))))
  return(p)
}

#' @title Item Information Function for 4PLM
#'
#' @description
#' Computes the Item Information Function (IIF) for the four-parameter
#' logistic model in Item Response Theory. The information function indicates
#' how precisely an item measures ability at different theta levels.
#'
#' @param x Numeric. The ability parameter (theta).
#' @param a Numeric. The slope (discrimination) parameter. Default is 1.
#' @param b Numeric. The location (difficulty) parameter.
#' @param c Numeric. The lower asymptote (guessing) parameter. Default is 0.
#' @param d Numeric. The upper asymptote (carelessness) parameter. Default is 1.
#'
#' @return A numeric value representing the item information at the given
#'   ability level.
#'
#' @details
#' Higher discrimination (\code{a}) parameters result in higher information.
#' Items provide maximum information near their difficulty (\code{b}) parameter.
#' The guessing (\code{c}) and upper asymptote (\code{d}) parameters reduce
#' the maximum information an item can provide.
#'
#' @examples
#' # Information at ability = 0 for an item with b = 0
#' ItemInformationFunc(x = 0, a = 1.5, b = 0, c = 0, d = 1)
#'
#' # Compare information at different ability levels
#' sapply(seq(-3, 3, 0.5), function(x) ItemInformationFunc(x, a = 1, b = 0))
#'
#' @seealso \code{\link{LogisticModel}}
#'
#' @export

ItemInformationFunc <- function(x, a = 1, b, c = 0, d = 1) {
  numerator <- a^2 * (LogisticModel(x, a, b, c, d) - c) * (d - LogisticModel(x, a, b, c, d)) *
    (LogisticModel(x, a, b, c, d) * (c + d - LogisticModel(x, a, b, c, d)) - c * d)
  denominator <- (d - c)^2 * LogisticModel(x, a, b, c, d) * (1 - LogisticModel(x, a, b, c, d))
  tmp <- numerator / denominator
  return(tmp)
}


#' @title Plot Item Information Curves (IIC) from exametrika
#'
#' @description
#' This function takes exametrika IRT or GRM output as input and generates
#' Item Information Curves (IIC) using ggplot2. IIC shows how much
#' information each item provides at different ability levels.
#'
#' @param data An object of class \code{c("exametrika", "IRT")} from
#'   \code{exametrika::IRT()} or \code{c("exametrika", "GRM")} from
#'   \code{exametrika::GRM()}.
#' @param items Numeric vector specifying which items to plot.
#'   If \code{NULL} (default), all items are plotted.
#' @param xvariable A numeric vector of length 2 specifying the range of the
#'   x-axis (ability). Default is \code{c(-4, 4)}.
#' @param title Logical or character. If \code{TRUE} (default), display an
#'   auto-generated title. If \code{FALSE}, no title. If a character string,
#'   use it as a custom title (only for single-item plots).
#' @param colors Character vector of colors. For IRT, single color for the curve.
#'   If \code{NULL} (default), a colorblind-friendly palette is used.
#' @param linetype Character or numeric specifying the line type.
#'   Default is \code{"solid"}.
#' @param show_legend Logical. If \code{TRUE}, display the legend (mainly for GRM).
#'   Default is \code{FALSE}.
#' @param legend_position Character. Position of the legend.
#'   One of \code{"right"} (default), \code{"top"}, \code{"bottom"},
#'   \code{"left"}, \code{"none"}.
#'
#' @return A list of ggplot objects, one for each item. Each plot shows the
#'   Item Information Curve for that item.
#'
#' @details
#' The Item Information Function indicates how precisely an item measures
#' ability at each point on the theta scale. Items with higher discrimination
#' parameters provide more information. The peak of the information curve
#' occurs near the item's difficulty parameter.
#'
#' For IRT models (2PL, 3PL, 4PL), the function uses the standard IRT
#' information function. For GRM, the information is computed as:
#' \deqn{I(\theta) = a^2 \sum_{k=1}^{K-1} P_k^*(\theta) [1 - P_k^*(\theta)]}
#'
#' @examples
#' \dontrun{
#' library(exametrika)
#' # IRT example
#' result_irt <- IRT(J15S500, model = 3)
#' plots_irt <- plotIIC_gg(result_irt)
#' plots_irt[[1]] # Show IIC for the first item
#'
#' # GRM example
#' result_grm <- GRM(J5S1000)
#' plots_grm <- plotIIC_gg(result_grm)
#' plots_grm[[1]] # Show IIC for the first item
#' }
#'
#' @seealso \code{\link{plotICC_gg}}, \code{\link{plotTIC_gg}}, \code{\link{plotICRF_gg}}
#'
#' @importFrom ggplot2 ggplot aes geom_line
#' @importFrom ggplot2 xlim
#' @importFrom ggplot2 ylim
#' @importFrom ggplot2 stat_function
#' @importFrom ggplot2 labs theme
#' @export


plotIIC_gg <- function(data,
                       items = NULL,
                       xvariable = c(-4, 4),
                       title = TRUE,
                       colors = NULL,
                       linetype = "solid",
                       show_legend = FALSE,
                       legend_position = "right") {
  # Check model type
  is_IRT <- all(class(data) %in% c("exametrika", "IRT"))
  is_GRM <- all(class(data) %in% c("exametrika", "GRM"))

  if (!is_IRT && !is_GRM) {
    stop("Invalid input. The variable must be from exametrika output (IRT or GRM).")
  }

  # === IRT Model ===
  if (is_IRT) {
    ItemInformationFunc <- function(x, a = 1, b, c = 0, d = 1) {
      numerator <- a^2 * (LogisticModel(x, a, b, c, d) - c) * (d - LogisticModel(x, a, b, c, d)) *
        (LogisticModel(x, a, b, c, d) * (c + d - LogisticModel(x, a, b, c, d)) - c * d)
      denominator <- (d - c)^2 * LogisticModel(x, a, b, c, d) * (1 - LogisticModel(x, a, b, c, d))
      tmp <- numerator / denominator
      return(tmp)
    }

    n_params <- ncol(data$params)
    if (n_params < 2 || n_params > 4) {
      stop("Invalid number of parameters.")
    }

    n_items <- nrow(data$params)
    if (is.null(items)) {
      items <- 1:n_items
    }
    if (any(items < 1 | items > n_items)) {
      stop("'items' must contain values between 1 and ", n_items)
    }

    # 色の設定
    if (is.null(colors)) {
      use_color <- .gg_exametrika_palette(1)[1]
    } else {
      use_color <- colors[1]
    }

    plots <- list()

    for (idx in seq_along(items)) {
      i <- items[idx]
      args <- c(a = data$params$slope[i], b = data$params$location[i])
      if (n_params == 3) {
        args["c"] <- data$params$lowerAsym[i]
      }
      if (n_params == 4) {
        args["d"] <- data$params$upperAsym[i]
      }

      # タイトルの設定
      if (is.logical(title) && title) {
        plot_title <- paste0("Item Information Curve, ", rownames(data$params)[i])
      } else if (is.logical(title) && !title) {
        plot_title <- NULL
      } else {
        plot_title <- title
      }

      p <- ggplot(data = data.frame(x = xvariable)) +
        xlim(xvariable[1], xvariable[2]) +
        stat_function(fun = ItemInformationFunc, args = args, color = use_color, linetype = linetype) +
        labs(
          title = plot_title,
          x = "ability",
          y = "information"
        )

      # 凡例の制御（IRT では基本的に不要）
      if (!show_legend) {
        p <- p + theme(legend.position = "none")
      } else {
        p <- p + theme(legend.position = legend_position)
      }

      plots[[idx]] <- p
    }

    return(plots)
  }

  # === GRM Model ===
  if (is_GRM) {
    params <- data$params
    n_items <- nrow(params)

    if (is.null(items)) {
      items <- 1:n_items
    }
    if (any(items < 1 | items > n_items)) {
      stop("'items' must contain values between 1 and ", n_items)
    }

    # 色の設定
    if (is.null(colors)) {
      use_color <- .gg_exametrika_palette(1)[1]
    } else {
      use_color <- colors[1]
    }

    thetas <- seq(xvariable[1], xvariable[2], length.out = 501)
    plots <- list()

    for (idx in seq_along(items)) {
      i <- items[idx]
      a <- params[i, 1]
      b <- as.numeric(params[i, -1])
      b <- b[!is.na(b)]

      # GRM Item Information を計算
      info_values <- sapply(thetas, function(theta) {
        ItemInformationFunc_GRM(theta, a, b)
      })

      plot_data <- data.frame(
        theta = thetas,
        information = info_values
      )

      # タイトルの設定
      if (is.logical(title) && title) {
        plot_title <- paste("Item Information Curve,", rownames(params)[i])
      } else if (is.logical(title) && !title) {
        plot_title <- NULL
      } else {
        plot_title <- title
      }

      p <- ggplot(plot_data, aes(x = theta, y = information)) +
        geom_line(color = use_color, linetype = linetype) +
        labs(
          title = plot_title,
          x = "ability",
          y = "information"
        )

      # 凡例の制御
      if (!show_legend) {
        p <- p + theme(legend.position = "none")
      } else {
        p <- p + theme(legend.position = legend_position)
      }

      plots[[idx]] <- p
    }

    return(plots)
  }
}

#' @title Plot Test Information Curve (TIC) from exametrika
#'
#' @description
#' This function takes exametrika IRT or GRM output as input and generates a
#' Test Information Curve (TIC) using ggplot2. TIC shows the total
#' information provided by all items at each ability level.
#'
#' @param data An object of class \code{c("exametrika", "IRT")} from
#'   \code{exametrika::IRT()} or \code{c("exametrika", "GRM")} from
#'   \code{exametrika::GRM()}.
#' @param xvariable A numeric vector of length 2 specifying the range of the
#'   x-axis (ability). Default is \code{c(-4, 4)}.
#' @param title Logical or character. If \code{TRUE} (default), display an
#'   auto-generated title. If \code{FALSE}, no title. If a character string,
#'   use it as a custom title.
#' @param color Character. Color for the curve.
#'   If \code{NULL} (default), a colorblind-friendly palette is used.
#' @param linetype Character or numeric specifying the line type.
#'   Default is \code{"solid"}.
#'
#' @return A single ggplot object showing the Test Information Curve.
#'
#' @details
#' The Test Information Function is the sum of all Item Information Functions.
#' It indicates how precisely the test as a whole measures ability at each
#' point on the theta scale. The reciprocal of test information is
#' approximately equal to the squared standard error of measurement.
#'
#' The function supports IRT models (2PL, 3PL, 4PL) and GRM.
#'
#' @examples
#' \dontrun{
#' library(exametrika)
#' # IRT example
#' result_irt <- IRT(J15S500, model = 3)
#' plot_irt <- plotTIC_gg(result_irt)
#' plot_irt # Show Test Information Curve
#'
#' # GRM example
#' result_grm <- GRM(J5S1000)
#' plot_grm <- plotTIC_gg(result_grm)
#' plot_grm # Show Test Information Curve
#' }
#'
#' @seealso \code{\link{plotICC_gg}}, \code{\link{plotIIC_gg}}, \code{\link{plotICRF_gg}}
#'
#' @importFrom ggplot2 ggplot aes geom_line
#' @importFrom ggplot2 xlim
#' @importFrom ggplot2 ylim
#' @importFrom ggplot2 stat_function
#' @importFrom ggplot2 labs
#' @export


plotTIC_gg <- function(data,
                       xvariable = c(-4, 4),
                       title = TRUE,
                       color = NULL,
                       linetype = "solid") {
  # Check model type
  is_IRT <- all(class(data) %in% c("exametrika", "IRT"))
  is_GRM <- all(class(data) %in% c("exametrika", "GRM"))

  if (!is_IRT && !is_GRM) {
    stop("Invalid input. The variable must be from exametrika output (IRT or GRM).")
  }

  # 色の設定
  if (is.null(color)) {
    use_color <- .gg_exametrika_palette(1)[1]
  } else {
    use_color <- color
  }

  # タイトルの設定
  if (is.logical(title) && title) {
    plot_title <- "Test Information Curve"
  } else if (is.logical(title) && !title) {
    plot_title <- NULL
  } else {
    plot_title <- title
  }

  # === IRT Model ===
  if (is_IRT) {
    n_params <- ncol(data$params)

    if (n_params < 2 || n_params > 4) {
      stop("Invalid number of parameters.")
    }

    multi <- function(x) {
      total <- 0
      for (i in 1:nrow(data$params)) {
        total <- total + ItemInformationFunc(
          x,
          data$params[i, 1], # slope
          data$params[i, 2], # location
          ifelse(is.null(data$params[i, 3]), 0, data$params[i, 3]), # lower
          ifelse(is.null(data$params[i, 4]), 1, data$params[i, 4]) # upper
        )
      }
      return(total)
    }

    plot <- ggplot(data = data.frame(x = xvariable)) +
      xlim(xvariable[1], xvariable[2]) +
      stat_function(fun = multi, color = use_color, linetype = linetype) +
      labs(
        title = plot_title,
        x = "ability",
        y = "information"
      )

    return(plot)
  }

  # === GRM Model ===
  if (is_GRM) {
    params <- data$params
    n_items <- nrow(params)

    thetas <- seq(xvariable[1], xvariable[2], length.out = 501)

    # 全アイテムの情報量を合計
    total_info <- numeric(length(thetas))

    for (i in 1:n_items) {
      a <- params[i, 1]
      b <- as.numeric(params[i, -1])
      b <- b[!is.na(b)]

      item_info <- sapply(thetas, function(theta) {
        ItemInformationFunc_GRM(theta, a, b)
      })

      total_info <- total_info + item_info
    }

    plot_data <- data.frame(
      theta = thetas,
      information = total_info
    )

    plot <- ggplot(plot_data, aes(x = theta, y = information)) +
      geom_line(color = use_color, linetype = linetype) +
      labs(
        title = plot_title,
        x = "ability",
        y = "information"
      )

    return(plot)
  }
}

#' @title Plot Test Response Function (TRF) from exametrika
#'
#' @description
#' This function takes exametrika IRT output as input and generates a
#' Test Response Function (TRF) using ggplot2. TRF shows the expected
#' total score as a function of ability (theta).
#'
#' @param data An object of class \code{c("exametrika", "IRT")} from
#'   \code{exametrika::IRT()}.
#' @param xvariable A numeric vector of length 2 specifying the range of the
#'   x-axis (ability). Default is \code{c(-4, 4)}.
#'
#' @return A single ggplot object showing the Test Response Function.
#'
#' @details
#' The Test Response Function is the sum of all Item Characteristic Curves
#' (ICCs). At each ability level, TRF represents the expected number of
#' correct responses across all items. For a test with \eqn{J} items:
#' \deqn{TRF(\theta) = \sum_{j=1}^{J} P_j(\theta)}
#'
#' The y-axis ranges from 0 to the total number of items.
#' The function supports 2PL, 3PL, and 4PL IRT models.
#'
#' @examples
#' \dontrun{
#' library(exametrika)
#' result <- IRT(J15S500, model = 3)
#' plot <- plotTRF_gg(result)
#' plot # Show Test Response Function
#' }
#'
#' @seealso \code{\link{plotICC_gg}}, \code{\link{plotTIC_gg}}
#'
#' @importFrom ggplot2 ggplot
#' @importFrom ggplot2 xlim
#' @importFrom ggplot2 ylim
#' @importFrom ggplot2 stat_function
#' @importFrom ggplot2 labs
#' @export


plotTRF_gg <- function(data, xvariable = c(-4, 4)) {
  if (!all(class(data) %in% c("exametrika", "IRT"))) {
    stop("Invalid input. The variable must be from exametrika output or an output from IRT.")
  }

  n_params <- ncol(data$params)

  if (n_params < 2 || n_params > 4) {
    stop("Invalid number of parameters.")
  }

  n_items <- nrow(data$params)

  multi <- function(x) {
    total <- 0
    for (i in 1:n_items) {
      total <- total + LogisticModel(
        x,
        a = data$params[i, 1], # slope
        b = data$params[i, 2], # location
        c = ifelse(is.null(data$params[i, 3]), 0, data$params[i, 3]), # lower
        d = ifelse(is.null(data$params[i, 4]), 1, data$params[i, 4]) # upper
      )
    }
    return(total)
  }

  plot <- ggplot(data = data.frame(x = xvariable)) +
    xlim(xvariable[1], xvariable[2]) +
    ylim(0, n_items) +
    stat_function(fun = multi) +
    labs(
      title = "Test Response Function",
      x = "ability",
      y = "expected score"
    )

  return(plot)
}
