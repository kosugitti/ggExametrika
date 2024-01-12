#' @title Display Multiple Plots Simultaneously from ggExametrika Output"
#' @description
#' This function consolidates multiple plots generated from the ggExametrika function into a single display.
#' @param plots ggExametrika output plots
#' @param selectPlots In the vector, specify the range or indices you want to display.
#' @importFrom gridExtra grid.arrange
#' @export

combinePlots_gg <- function(plots, selectPlots = c(1:6)) {

    selectPlots <- selectPlots[selectPlots <= length(plots)]

    selected <- lapply(selectPlots, function(i) plots[[i]])
    return(grid.arrange(grobs = selected))
}

