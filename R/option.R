#' @title Display Multiple Plots Simultaneously from ggExametrika Output
#'
#' @description
#' This function arranges multiple ggplot objects from ggExametrika functions
#' into a single display using a grid layout. Useful for comparing plots
#' across items or students.
#'
#' @param plots A list of ggplot objects, typically output from functions
#'   like \code{\link{plotICC_gg}}, \code{\link{plotIRP_gg}}, etc.
#' @param selectPlots A numeric vector specifying which plots to display.
#'   Default is \code{1:6} (first 6 plots). Indices exceeding the list
#'   length are automatically excluded.
#'
#' @return A gtable object containing the arranged plots, displayed as
#'   a side effect.
#'
#' @details
#' This function uses \code{gridExtra::grid.arrange} to combine multiple
#' plots. The number of rows and columns is automatically determined.
#' For more control over layout, consider using \code{gridExtra::grid.arrange}
#' directly with the \code{nrow} and \code{ncol} arguments.
#'
#' @examples
#' \dontrun{
#' library(exametrika)
#' result <- IRT(J15S500, model = 3)
#' plots <- plotICC_gg(result)
#' combinePlots_gg(plots, selectPlots = 1:6) # Show first 6 items
#' combinePlots_gg(plots, selectPlots = c(1, 5, 10)) # Show specific items
#' }
#'
#' @importFrom gridExtra grid.arrange
#' @export

combinePlots_gg <- function(plots, selectPlots = c(1:6)) {
  selectPlots <- selectPlots[selectPlots <= length(plots)]

  selected <- lapply(selectPlots, function(i) plots[[i]])
  return(grid.arrange(grobs = selected))
}
