#' @title Plot which category boundary moves at each rank step
#'
#' @description
#' Takes an ordinal Ranklustering result from \code{exametrika::Biclustering()}
#' (\code{method = "R"}) and draws, for every field, a heatmap of how much the
#' probability of answering each category or above rises when a respondent goes
#' up one rank. Rows are the rank steps (1 to 2, 2 to 3, ...) from top to
#' bottom, columns the category boundaries. It is the ggplot2 version of
#' \code{plot(x, type = "RankUpShift")} in exametrika.
#'
#' @param data An object of class \code{c("exametrika", "ordinalBiclustering")}
#'   fitted with \code{method = "R"}.
#' @param fields Integer vector of the fields to draw. Default is all fields.
#' @param title Logical or character. If \code{TRUE} (default), a default
#'   title is used; if \code{FALSE}, none; a character string is used as the
#'   title.
#' @param colors Character vector of length 1 or 2: the colour for increases
#'   and, optionally, for decreases. Default \code{c("darkorange3", "steelblue")}.
#' @param label_min Cells whose absolute value is at least this are labelled
#'   with the value. Default 0.05; \code{Inf} turns the labels off.
#' @param digits Number of decimals in the cell labels. Default 2.
#' @param show_legend Logical. Show the colour key. Default \code{TRUE}.
#' @param legend_position Position of the colour key. Default \code{"right"}.
#'
#' @return A ggplot object (one facet per field).
#'
#' @details
#' A cell is \eqn{P_f(X \ge b \mid c + 1) - P_f(X \ge b \mid c)}: the change of
#' the upper-cumulative field reference profile from rank \eqn{c} to
#' \eqn{c + 1} at boundary \eqn{b}. Under the isotonic estimation it is never
#' negative; under GTM a negative cell is an order violation and is shaded in
#' the second colour. exametrika 2.3.0 and later return the values as
#' \code{RankUpShift}; for a fit from an earlier version they are computed
#' here from the field reference profile in the same way.
#'
#' @examplesIf requireNamespace("exametrika", quietly = TRUE)
#' \donttest{
#' library(exametrika)
#' result <- Biclustering(J5S1000, ncls = 5, nfld = 2, method = "R")
#' plotRankUpShift_gg(result)
#' }
#'
#' @seealso \code{\link{plotRankOdds_gg}}, \code{\link{plotFCBR_gg}}
#'
#' @importFrom ggplot2 ggplot aes geom_tile geom_text facet_wrap labs theme
#'   theme_minimal element_blank scale_fill_gradient2 scale_y_discrete
#' @export
plotRankUpShift_gg <- function(data,
                               fields = NULL,
                               title = TRUE,
                               colors = c("darkorange3", "steelblue"),
                               label_min = 0.05,
                               digits = 2,
                               show_legend = TRUE,
                               legend_position = "right") {
  .validate_exametrika(data, "ordinalBiclustering")
  D <- .rank_up_shift(data)
  nfld <- dim(D)[2]
  if (is.null(fields)) fields <- seq_len(nfld)
  if (any(fields < 1 | fields > nfld)) {
    stop("'fields' must be between 1 and ", nfld, ".", call. = FALSE)
  }
  steps <- sub("^Rank([0-9]+)->Rank([0-9]+)$", "\\1\u2192\\2", dimnames(D)[[1]])
  bounds <- sub("^>=", "\u2265", dimnames(D)[[3]])
  df <- expand.grid(
    step = seq_along(steps), field = fields, boundary = seq_along(bounds),
    KEEP.OUT.ATTRS = FALSE
  )
  df$delta <- D[cbind(df$step, df$field, df$boundary)]
  df$step <- factor(steps[df$step], levels = steps)
  df$field <- factor(dimnames(D)[[2]][df$field], levels = dimnames(D)[[2]][fields])
  df$boundary <- factor(bounds[df$boundary], levels = bounds)
  df$label <- ifelse(abs(df$delta) >= label_min, formatC(df$delta, format = "f", digits = digits), "")

  pos_col <- colors[1]
  neg_col <- if (length(colors) >= 2) colors[2] else "steelblue"
  main <- if (isTRUE(title)) {
    "Which boundary moves when the rank goes up by one"
  } else if (is.character(title)) {
    title
  } else {
    NULL
  }

  p <- ggplot(df, aes(x = boundary, y = step, fill = delta)) +
    geom_tile(color = "white") +
    geom_text(aes(label = label), size = 3.2) +
    facet_wrap(~field) +
    scale_fill_gradient2(low = neg_col, mid = "white", high = pos_col, midpoint = 0) +
    scale_y_discrete(limits = rev) +
    labs(
      x = "Category boundary (answering this or above)", y = "Rank step",
      fill = "Increase", title = main
    ) +
    theme_minimal() +
    theme(panel.grid = element_blank(), legend.position = if (show_legend) legend_position else "none")
  return(p)
}

#' @title Plot the rank-up and rank-down odds by rank
#'
#' @description
#' Box plots of the rank-up odds (membership of the next rank up over that of
#' the estimated rank) and the rank-down odds, by estimated rank, on a log
#' axis with a dashed line at 1. Odds near 1 mark respondents on the border
#' with the neighbouring rank. The ggplot2 version of
#' \code{plot(x, type = "RankOdds")} in exametrika.
#'
#' @param data A Ranklustering result of exametrika: an ordinal
#'   \code{Biclustering()} with \code{method = "R"}, or a binary or rated one.
#' @param floor Odds below this are drawn at this value. Default 1e-4.
#' @param title Logical or character, as in \code{\link{plotRankUpShift_gg}}.
#' @param fill Fill colour of the boxes. Default \code{"grey85"}.
#'
#' @return A ggplot object with two facets (rank-up and rank-down odds).
#'
#' @details
#' exametrika returns the odds in \code{Students} for the binary and rated
#' Ranklustering and, since 2.3.0, for the ordinal one. For an ordinal fit from
#' an earlier version they are computed here from the class membership in the
#' same way.
#'
#' @examplesIf requireNamespace("exametrika", quietly = TRUE)
#' \donttest{
#' library(exametrika)
#' result <- Biclustering(J5S1000, ncls = 5, nfld = 2, method = "R")
#' plotRankOdds_gg(result)
#' }
#'
#' @seealso \code{\link{plotRankUpShift_gg}}
#'
#' @importFrom ggplot2 ggplot aes geom_boxplot geom_hline facet_wrap labs
#'   scale_y_log10 theme_minimal
#' @export
plotRankOdds_gg <- function(data, floor = 1e-4, title = TRUE, fill = "grey85") {
  .validate_exametrika(data, c("ordinalBiclustering", "Biclustering", "ratedBiclustering"))
  odds <- .rank_odds(data)
  df <- data.frame(
    rank = factor(rep(odds$rank, 2), levels = seq_len(odds$ncls)),
    which = factor(rep(c("Rank-Up Odds", "Rank-Down Odds"), each = length(odds$rank)),
      levels = c("Rank-Up Odds", "Rank-Down Odds")
    ),
    value = pmax(c(odds$up, odds$down), floor)
  )
  df <- df[!is.na(df$value), ]
  main <- if (isTRUE(title)) {
    "Rank-up and rank-down odds"
  } else if (is.character(title)) {
    title
  } else {
    NULL
  }
  p <- ggplot(df, aes(x = rank, y = value)) +
    geom_boxplot(fill = fill, outlier.size = 0.6) +
    geom_hline(yintercept = 1, linetype = "dashed", color = "firebrick") +
    scale_y_log10() +
    facet_wrap(~which, ncol = 1) +
    labs(x = "Estimated rank", y = "Odds (log scale)", title = main) +
    theme_minimal()
  return(p)
}

#' RankUpShift of an ordinal Ranklustering, computed if the fit predates it
#' @keywords internal
#' @noRd
.rank_up_shift <- function(data) {
  if (!is.null(data$RankUpShift)) {
    return(data$RankUpShift)
  }
  if (!identical(data$model, 2) && !identical(data$msg, "Rank")) {
    stop("This plot needs a Ranklustering (method = \"R\"); a plain ",
      "Biclustering has no rank order.",
      call. = FALSE
    )
  }
  P <- data$FRP
  nfld <- dim(P)[1]
  ncls <- dim(P)[2]
  maxQ <- dim(P)[3]
  shift <- if (is.null(data$CategoryShift)) 0 else data$CategoryShift
  out <- array(0, dim = c(ncls - 1, nfld, maxQ - 1))
  for (f in seq_len(nfld)) {
    up <- t(apply(matrix(P[f, , ], nrow = ncls), 1, function(p) rev(cumsum(rev(p)))))[, -1, drop = FALSE]
    out[, f, ] <- up[-1, , drop = FALSE] - up[-ncls, , drop = FALSE]
  }
  if (identical(data$estimation, "isotonic")) {
    out[out < 0 & out > -1e-6] <- 0
  }
  dimnames(out) <- list(
    paste0("Rank", seq_len(ncls - 1), "->Rank", seq_len(ncls - 1) + 1),
    paste0("Field", seq_len(nfld)),
    paste0(">=", seq(2, maxQ) - shift)
  )
  return(out)
}

#' Rank-up and rank-down odds from Students, computed if absent
#' @keywords internal
#' @noRd
.rank_odds <- function(data) {
  S <- data$Students
  M <- as.matrix(S[, grep("^Membership", colnames(S)), drop = FALSE])
  ncls <- ncol(M)
  rank <- as.integer(S[, "Estimate"])
  if (all(c("Rank-Up Odds", "Rank-Down Odds") %in% colnames(S))) {
    return(list(
      rank = rank, ncls = ncls,
      up = as.numeric(S[, "Rank-Up Odds"]), down = as.numeric(S[, "Rank-Down Odds"])
    ))
  }
  if (!identical(data$msg, "Rank")) {
    stop("This plot needs a Ranklustering (method = \"R\"); a plain ",
      "Biclustering has no rank order.",
      call. = FALSE
    )
  }
  n <- nrow(M)
  up <- ifelse(rank < ncls, M[cbind(seq_len(n), pmin(rank + 1, ncls))] / M[cbind(seq_len(n), rank)], NA)
  down <- ifelse(rank > 1, M[cbind(seq_len(n), pmax(rank - 1, 1))] / M[cbind(seq_len(n), rank)], NA)
  return(list(rank = rank, ncls = ncls, up = up, down = down))
}
