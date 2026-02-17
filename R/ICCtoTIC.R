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
#' This function takes exametrika IRT output as input and generates
#' Item Information Curves (IIC) using ggplot2. IIC shows how much
#' information each item provides at different ability levels.
#'
#' @param data An object of class \code{c("exametrika", "IRT")} from
#'   \code{exametrika::IRT()}.
#' @param xvariable A numeric vector of length 2 specifying the range of the
#'   x-axis (ability). Default is \code{c(-4, 4)}.
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
#' The function supports 2PL, 3PL, and 4PL IRT models.
#'
#' @examples
#' \dontrun{
#' library(exametrika)
#' result <- IRT(J15S500, model = 3)
#' plots <- plotIIC_gg(result)
#' plots[[1]] # Show IIC for the first item
#' combinePlots_gg(plots, selectPlots = 1:6) # Show first 6 items
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


plotIIC_gg <- function(data, xvariable = c(-4, 4)) {
  if (!all(class(data) %in% c("exametrika", "IRT"))) {
    stop("Invalid input. The variable must be from exametrika output or an output from IRT.")
  }

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

  plots <- list()

  for (i in 1:nrow(data$params)) {
    args <- c(a = data$params$slope[i], b = data$params$location[i])
    if (n_params == 3) {
      args["c"] <- data$params$lowerAsym[i]
    }
    if (n_params == 4) {
      args["d"] <- data$params$upperAsym[i]
    }

    plots[[i]] <- ggplot(data = data.frame(x = xvariable)) +
      xlim(xvariable[1], xvariable[2]) +
      stat_function(fun = ItemInformationFunc, args = args) +
      labs(
        title = paste0("Item Information Curve, ", rownames(data$params)[i]),
        x = "ability",
        y = "information"
      )
  }

  return(plots)
}

#' @title Plot Test Information Curve (TIC) from exametrika
#'
#' @description
#' This function takes exametrika IRT output as input and generates a
#' Test Information Curve (TIC) using ggplot2. TIC shows the total
#' information provided by all items at each ability level.
#'
#' @param data An object of class \code{c("exametrika", "IRT")} from
#'   \code{exametrika::IRT()}.
#' @param xvariable A numeric vector of length 2 specifying the range of the
#'   x-axis (ability). Default is \code{c(-4, 4)}.
#'
#' @return A single ggplot object showing the Test Information Curve.
#'
#' @details
#' The Test Information Function is the sum of all Item Information Functions.
#' It indicates how precisely the test as a whole measures ability at each
#' point on the theta scale. The reciprocal of test information is
#' approximately equal to the squared standard error of measurement.
#'
#' The function supports 2PL, 3PL, and 4PL IRT models.
#'
#' @examples
#' \dontrun{
#' library(exametrika)
#' result <- IRT(J15S500, model = 3)
#' plot <- plotTIC_gg(result)
#' plot # Show Test Information Curve
#' }
#'
#' @seealso \code{\link{plotICC_gg}}, \code{\link{plotIIC_gg}}
#'
#' @importFrom ggplot2 ggplot
#' @importFrom ggplot2 xlim
#' @importFrom ggplot2 ylim
#' @importFrom ggplot2 stat_function
#' @importFrom ggplot2 labs
#' @export


plotTIC_gg <- function(data, xvariable = c(-4, 4)) {
  if (!all(class(data) %in% c("exametrika", "IRT"))) {
    stop("Invalid input. The variable must be from exametrika output or an output from IRT.")
  }


  n_params <- ncol(data$params)

  if (n_params < 2 || n_params > 4) {
    stop("Invalid number of parameters.")
  }

  plot <- NULL

  multi <- function(x) {
    total <- 0
    for (i in 1:nrow(data$params)) {
      total <- total + ItemInformationFunc(
        x,
        data$params[i, 1], # slope
        data$params[i, 2], # location
        ifelse(is.null(data$params[i, 3]), 0, data$params[i, 3]), # rower
        ifelse(is.null(data$params[i, 4]), 1, data$params[i, 4]) # upper
      )
    }
    return(total)
  }

  plot <- ggplot(data = data.frame(x = xvariable)) +
    xlim(xvariable[1], xvariable[2]) +
    stat_function(fun = multi) +
    labs(
      title = "Test Information Curve",
      x = "ability",
      y = "information"
    )

  return(plot)
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
