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
#' @param nr Number of rows of the grid. Default \code{NULL} lets
#'   \code{gridExtra::grid.arrange} choose.
#' @param nc Number of columns of the grid. Default \code{NULL} lets
#'   \code{gridExtra::grid.arrange} choose. The names follow the
#'   \code{nr}/\code{nc} arguments of \code{plot.exametrika}.
#'
#' @return A gtable object containing the arranged plots, displayed as
#'   a side effect.
#'
#' @details
#' This function uses \code{gridExtra::grid.arrange} to combine multiple
#' plots. The number of rows and columns is determined automatically unless
#' \code{nr} and/or \code{nc} are given. When only one of them is given the
#' other follows from the number of plots. Selected plots are placed row by
#' row. For more control over layout, use \code{gridExtra::grid.arrange}
#' directly.
#'
#' @examplesIf requireNamespace("exametrika", quietly = TRUE)
#' library(exametrika)
#' result <- IRT(J15S500, model = 3)
#' plots <- plotICC_gg(result)
#' combinePlots_gg(plots, selectPlots = 1:6) # Show first 6 items
#' combinePlots_gg(plots, selectPlots = c(1, 5, 10)) # Show specific items
#' combinePlots_gg(plots, selectPlots = 1:9, nr = 3, nc = 3) # 3 x 3 grid
#'
#' @importFrom gridExtra grid.arrange
#' @export

combinePlots_gg <- function(plots, selectPlots = c(1:6), nr = NULL, nc = NULL) {
  # Input validation
  if (!is.list(plots) || length(plots) == 0) {
    stop("'plots' must be a non-empty list of ggplot objects.", call. = FALSE)
  }
  if (!is.numeric(selectPlots) || anyNA(selectPlots)) {
    stop("'selectPlots' must be a numeric vector without NA.", call. = FALSE)
  }
  for (nm in c("nr", "nc")) {
    v <- get(nm)
    if (!is.null(v) && (!is.numeric(v) || length(v) != 1 || is.na(v) || v < 1)) {
      stop(sprintf("'%s' must be a single positive number.", nm), call. = FALSE)
    }
  }

  # Keep only valid indices (1..length(plots))
  selectPlots <- selectPlots[selectPlots >= 1 & selectPlots <= length(plots)]
  if (length(selectPlots) == 0) {
    stop("'selectPlots' contains no valid plot indices.", call. = FALSE)
  }

  selected <- lapply(selectPlots, function(i) plots[[i]])
  if (!is.null(nr) && !is.null(nc) && nr * nc < length(selected)) {
    stop(
      sprintf(
        "A %d x %d grid holds %d plots but %d were selected.",
        nr, nc, nr * nc, length(selected)
      ),
      call. = FALSE
    )
  }
  args <- list(grobs = selected)
  if (!is.null(nr)) args$nrow <- nr
  if (!is.null(nc)) args$ncol <- nc
  return(do.call(grid.arrange, args))
}
