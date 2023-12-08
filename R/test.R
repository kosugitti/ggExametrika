#' @title test
#' @description
#' plot_ICC
#' @param data output_Exametrika
#' @param type description
#' @export


ICC_plot <- function(data, type = 1){
    if (all(class(data) == c("Exametrika","IRT"))) {
        if (ncol(data$params) == 4) {
            Item_Characteristic_function <- function(x, slope, location, lowerAsym, upperAsym) {
                lowerAsym + ((upperAsym - lowerAsym) / (1 + exp(-1.7 * slope * (x - location))))
            }

            plots <- NULL

            for (i in 1:nrow(result.IRT$params)) {
                plots[[i]] <-
                    ggplot(data = data.frame(x = seq(-4, 4, length.out = 100))) +
                    xlim(-4,4) +
                    ylim(0,1) +
                    stat_function(fun = Item_Characteristic_function,
                                  args = list(slope = data$params$slope[i],
                                              location = data$params$location[i],
                                              lowerAsym = data$params$lowerAsym[i],
                                              upperAsym = data$params$upperAsym[i])) +
                    labs(
                        title = paste0("Item Characteristic Curve, item ",i)
                    )
            }

            return(plots)

        }else if(ncol(data$params) == 3){
            Item_Characteristic_function <- function(x, slope, location, lowerAsym) {
                lowerAsym + ((1 - lowerAsym) / (1 + exp(-1.7 * slope * (x - location))))
            }

            plots <- NULL

            for (i in 1:nrow(result.IRT$params)) {
                plots[[i]] <-
                    ggplot(data = data.frame(x = seq(-4, 4, length.out = 100))) +
                    xlim(-4,4) +
                    ylim(0,1) +
                    stat_function(fun = Item_Characteristic_function,
                                  args = list(slope = data$params$slope[i],
                                              location = data$params$location[i],
                                              lowerAsym = data$params$lowerAsym[i])) +
                    labs(
                        title = paste0("Item Characteristic Curve, item ",i)
                    )
            }
            return(plots)

        }else if(ncol(data$params) == 2){
            Item_Characteristic_function <- function(x, slope, location) {
                1 / (1 + exp(-1.7 * slope * (x - location)))
            }

            plots <- NULL

            for (i in 1:nrow(result.IRT$params)) {
                plots[[i]] <-
                    ggplot(data = data.frame(x = seq(-4, 4, length.out = 100))) +
                    xlim(-4,4) +
                    ylim(0,1) +
                    stat_function(fun = Item_Characteristic_function,
                                  args = list(slope = data$params$slope[i],
                                              location = data$params$location[i])) +
                    labs(
                        title = paste0("Item Characteristic Curve, item ",i)
                    )

            }

            return(plots)

        }else{
            stop("Invalid number of parameters.")
        }

    }else{
        stop("The input variable is not from Exametrika output, nor is it an output from IRT.")
    }



}
