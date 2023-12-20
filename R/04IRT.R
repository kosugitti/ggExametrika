#' @title Plot Item Characteristic Curves (ICC) from Exametrika
#' @description
#' This function takes Exametrika output or from Item Response Theory (IRT) as input
#' and generates Item Characteristic Curves (ICC) using ggplot2.
#'
#' @param data Exametrika output results
#' @param xvariable Specify the vector to set the drawing range at both ends of the x-axis
#'
#' @importFrom ggplot2 ggplot
#' @importFrom ggplot2 xlim
#' @importFrom ggplot2 ylim
#' @importFrom ggplot2 stat_function
#' @importFrom ggplot2 labs
#' @export


plotICC_gg <- function(data, xvariable = c(-4,4)) {
    if (!all(class(data) %in% c("Exametrika", "IRT"))) {
        stop("Invalid input. The variable must be from Exametrika output or an output from IRT.")
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
            ylim(0, 1) +
            stat_function(fun = Item_Characteristic_function, args = args) +
            labs(
                title = paste0("Item Characteristic Curve, ", rownames(data$params)[i]),
                x = "ability",
                y = "probability"
            )
    }

    return(plots)
    combinePlots_gg(plots)
}


#' @title Four-Parameter Logistic Model
#' @description
#' The four-parameter logistic model is a model where one additional
#' parameter d, called the upper asymptote parameter, is added to the
#' 3PLM.
#' @param x ability parameter
#' @param a slope parameter
#' @param b locaiton parameter
#' @param c lower asymptote parameter
#' @param d upper asymptote parameter
#' @export

LogisticModel <- function(x, a = 1, b, c = 0, d = 1) {
    p <- c + ((d - c) / (1 + exp(-a * (x - b))))
    return(p)
}

#' @title IIF for 4PLM
#' @description
#' Item Information Function for 4PLM
#' @param x ability parameter
#' @param a slope parameter
#' @param b locaiton parameter
#' @param c lower asymptote parameter
#' @param d upper asymptote parameter
#' @export

ItemInformationFunc <- function(x, a = 1, b, c = 0, d = 1) {
    numerator <- a^2 * (LogisticModel(x, a, b, c, d) - c) * (d - LogisticModel(x, a, b, c, d)) *
        (LogisticModel(x, a, b, c, d) * (c + d - LogisticModel(x, a, b, c, d)) - c * d)
    denominator <- (d - c)^2 * LogisticModel(x, a, b, c, d) * (1 - LogisticModel(x, a, b, c, d))
    tmp <- numerator / denominator
    return(tmp)
}


#' @title Plot Item Characteristic Curves (IIC) from Exametrika
#' @description
#' This function takes Exametrika output or from Item Response Theory (IRT) as input
#' and generates Item Characteristic Curves (IIC) using ggplot2.
#'
#' @param data Exametrika output results
#' @param xvariable Specify the vector to set the drawing range at both ends of the x-axis
#'
#' @importFrom ggplot2 ggplot
#' @importFrom ggplot2 xlim
#' @importFrom ggplot2 ylim
#' @importFrom ggplot2 stat_function
#' @importFrom ggplot2 labs
#' @export


plotIIC_gg <- function(data, xvariable = c(-4, 4)) {
    if (!all(class(data) %in% c("Exametrika", "IRT"))) {
        stop("Invalid input. The variable must be from Exametrika output or an output from IRT.")
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

#' @title Plot Test Information Curves (TIC) from Exametrika
#' @description
#' This function takes Exametrika output or from Item Response Theory (IRT) as input
#' and generates Test Information Curves (TIC) using ggplot2.
#'
#' @param data Exametrika output results
#' @param xvariable Specify the vector to set the drawing range at both ends of the x-axis
#'
#' @importFrom ggplot2 ggplot
#' @importFrom ggplot2 xlim
#' @importFrom ggplot2 ylim
#' @importFrom ggplot2 stat_function
#' @importFrom ggplot2 labs
#' @export


plotTIC_gg <- function(data, xvariable = c(-4, 4)) {
    if (!all(class(data) %in% c("Exametrika", "IRT"))) {
        stop("Invalid input. The variable must be from Exametrika output or an output from IRT.")
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
                data$params[i, 1],  # slope
                data$params[i, 2],  # location
                ifelse(is.null(data$params[i, 3]), 0, data$params[i, 3]),  # rower
                ifelse(is.null(data$params[i, 4]), 1, data$params[i, 4])  # upper
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


