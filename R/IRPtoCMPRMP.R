#' @title Plot Item Reference Profile (IRP) from exametrika
#'
#' @description
#' This function takes exametrika output as input and generates
#' Item Reference Profile (IRP) plots using ggplot2. IRP shows the
#' probability of a correct response for each item at each latent
#' class or rank level.
#'
#' @param data An object of class \code{c("exametrika", "LCA")},
#'   \code{c("exametrika", "LRA")}, or \code{c("exametrika", "LDLRA")}.
#'
#' @return A list of ggplot objects, one for each item. Each plot shows the
#'   correct response rate across latent classes or ranks.
#'
#' @details
#' The Item Reference Profile visualizes how item difficulty varies across
#' latent classes (LCA) or ranks (LRA, LDLRA). Items with monotonically
#' increasing profiles indicate good discrimination between classes/ranks.
#'
#' @examples
#' \dontrun{
#' library(exametrika)
#' result <- LRA(J15S500, nrank = 5)
#' plots <- plotIRP_gg(result)
#' plots[[1]] # Show IRP for the first item
#' }
#'
#' @seealso \code{\link{plotFRP_gg}}, \code{\link{plotTRP_gg}}
#'
#' @importFrom ggplot2 ggplot
#' @importFrom ggplot2 ylim
#' @importFrom ggplot2 geom_point
#' @importFrom ggplot2 geom_line
#' @importFrom ggplot2 scale_x_continuous
#' @importFrom ggplot2 labs
#' @export

plotIRP_gg <- function(data) {
  if (all(class(data) %in% c("exametrika", "LCA"))) {
    xlabel <- "Latent Class"
  } else if (all(class(data) %in% c("exametrika", "LRA")) || all(class(data) %in% c("exametrika", "LDLRA"))) {
    xlabel <- "Latent Rank"
  } else {
    stop("Invalid input. The variable must be from exametrika output or from either LCA, LRA, or LDLRA.")
  }


  n_cls <- ncol(data$IRP)

  if (n_cls < 2 || n_cls > 20) {
    stop("Invalid number of classes or Ranks")
  }

  plots <- list()

  for (i in 1:nrow(data$IRP)) {
    x <- data.frame(
      CRR = c(data$IRP[i, ]),
      rank = c(1:n_cls)
    )

    plots[[i]] <- ggplot(x, aes(x = rank, y = CRR)) +
      scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.25)) +
      geom_point() +
      geom_line(linetype = "dashed") +
      scale_x_continuous(breaks = seq(1, n_cls, 1)) +
      labs(
        title = paste0("Item Reference Profile, ", rownames(data$IRP)[i]),
        x = xlabel,
        y = "Correct Response Rate"
      )
  }

  return(plots)
}


#' @title Plot Field Reference Profile (FRP) from exametrika
#'
#' @description
#' This function takes exametrika output as input and generates a
#' Field Reference Profile (FRP) plot using ggplot2. For binary data,
#' it displays correct response rates. For polytomous data, it shows
#' expected scores calculated using the specified statistic.
#'
#' @param data An object from exametrika: Biclustering, nominalBiclustering,
#'   ordinalBiclustering, IRM, LDB, or BINET output.
#' @param stat Character. Statistic to use for polytomous data:
#'   \code{"mean"} (default), \code{"median"}, or \code{"mode"}.
#'   Ignored for binary data.
#' @param fields Integer vector specifying which fields to plot. Default is all fields.
#' @param title Logical or character. If \code{TRUE} (default), display automatic
#'   title. If \code{FALSE}, no title. If a character string, use it as the title.
#' @param colors Character vector. Colors for each field line.
#'   If \code{NULL} (default), uses the package default palette.
#' @param linetype Character or numeric. Line type for all lines.
#'   Default is \code{"solid"}.
#' @param show_legend Logical. If \code{TRUE} (default), display the legend.
#' @param legend_position Character. Position of the legend:
#'   \code{"right"} (default), \code{"top"}, \code{"bottom"},
#'   \code{"left"}, \code{"none"}.
#'
#' @return A single ggplot object with all selected fields.
#'
#' @details
#' The Field Reference Profile shows how response patterns vary across
#' latent classes/ranks for each field (cluster of items).
#'
#' For **binary data** (Biclustering, IRM, LDB, BINET):
#' \itemize{
#'   \item Y-axis: Correct Response Rate (0-1)
#'   \item Each line represents one field
#' }
#'
#' For **polytomous data** (nominalBiclustering, ordinalBiclustering):
#' \itemize{
#'   \item Y-axis: Expected Score (calculated using \code{stat} parameter)
#'   \item \code{stat = "mean"}: Weighted average across categories (default)
#'   \item \code{stat = "median"}: Median category value
#'   \item \code{stat = "mode"}: Most probable category
#' }
#'
#' @examples
#' \dontrun{
#' library(exametrika)
#'
#' # Binary biclustering
#' result_bin <- Biclustering(J35S515, ncls = 4, nfld = 3)
#' plot <- plotFRP_gg(result_bin)
#'
#' # Ordinal biclustering with mean (default)
#' result_ord <- Biclustering(OrdinalData, ncls = 4, nfld = 3, dataType = "ordinal")
#' plot_mean <- plotFRP_gg(result_ord, stat = "mean")
#'
#' # Using mode for polytomous data
#' plot_mode <- plotFRP_gg(result_ord, stat = "mode",
#'                         title = "Field Reference Profile (Mode)",
#'                         colors = c("red", "blue", "green"))
#' }
#'
#' @seealso \code{\link{plotIRP_gg}}, \code{\link{plotTRP_gg}},
#'   \code{\link{plotCRV_gg}}, \code{\link{plotRRV_gg}}
#'
#' @importFrom ggplot2 ggplot aes geom_point geom_line scale_x_continuous
#'   scale_y_continuous labs theme scale_color_manual scale_linetype_manual
#' @export

plotFRP_gg <- function(data,
                       stat = "mean",
                       fields = NULL,
                       title = TRUE,
                       colors = NULL,
                       linetype = "solid",
                       show_legend = TRUE,
                       legend_position = "right") {

  # クラスチェック
  valid_classes <- c("Biclustering", "nominalBiclustering", "ordinalBiclustering",
                     "IRM", "LDB", "BINET")
  data_class <- class(data)[class(data) != "exametrika"]

  if (!"exametrika" %in% class(data) || !any(data_class %in% valid_classes)) {
    stop("Invalid input. The data must be from exametrika output: ",
         "Biclustering, nominalBiclustering, ordinalBiclustering, IRM, LDB, or BINET.")
  }

  # statパラメータチェック
  if (!stat %in% c("mean", "median", "mode")) {
    stop("'stat' must be one of: 'mean', 'median', 'mode'")
  }

  # FRPデータの存在確認
  if (!"FRP" %in% names(data)) {
    stop("FRP data not found in the input object.")
  }

  # データ型判定: 2次元（2値）か3次元（多値）か
  is_polytomous <- length(dim(data$FRP)) == 3

  if (is_polytomous) {
    # === 多値データ（nominalBiclustering, ordinalBiclustering） ===
    BCRM <- data$FRP  # [field, class, category]
    nfld <- dim(BCRM)[1]
    ncls <- dim(BCRM)[2]
    maxQ <- dim(BCRM)[3]

    # フィールド選択
    if (is.null(fields)) {
      selected_fields <- 1:nfld
    } else {
      if (!is.numeric(fields) || any(fields < 1 | fields > nfld)) {
        stop("'fields' must be a numeric vector with values between 1 and ", nfld)
      }
      selected_fields <- fields
    }

    # 期待得点の計算
    expected_scores <- matrix(0, nrow = length(selected_fields), ncol = ncls)
    rownames(expected_scores) <- paste0("Field ", selected_fields)

    for (idx in seq_along(selected_fields)) {
      f <- selected_fields[idx]
      for (cc in 1:ncls) {
        probs <- BCRM[f, cc, ]  # カテゴリ確率ベクトル
        categories <- 1:maxQ

        if (stat == "mean") {
          # 重み付き平均
          expected_scores[idx, cc] <- sum(categories * probs)
        } else if (stat == "median") {
          # 累積確率から中央値を計算
          cum_probs <- cumsum(probs)
          median_cat <- min(which(cum_probs >= 0.5))
          expected_scores[idx, cc] <- median_cat
        } else if (stat == "mode") {
          # 最頻値（最も確率が高いカテゴリ）
          mode_cat <- which.max(probs)
          expected_scores[idx, cc] <- mode_cat
        }
      }
    }

    y_label <- switch(stat,
                      "mean" = "Expected Score (Mean)",
                      "median" = "Expected Score (Median)",
                      "mode" = "Expected Score (Mode)")

  } else {
    # === 2値データ（Biclustering, IRM, LDB, BINET） ===
    FRP_matrix <- data$FRP  # [field, class]
    nfld <- nrow(FRP_matrix)
    ncls <- ncol(FRP_matrix)

    # フィールド選択
    if (is.null(fields)) {
      selected_fields <- 1:nfld
    } else {
      if (!is.numeric(fields) || any(fields < 1 | fields > nfld)) {
        stop("'fields' must be a numeric vector with values between 1 and ", nfld)
      }
      selected_fields <- fields
    }

    expected_scores <- FRP_matrix[selected_fields, , drop = FALSE]
    rownames(expected_scores) <- paste0("Field ", selected_fields)
    y_label <- "Correct Response Rate"
  }

  # データフレーム作成
  plot_data_list <- list()
  for (idx in seq_along(selected_fields)) {
    for (cc in 1:ncls) {
      plot_data_list[[length(plot_data_list) + 1]] <- data.frame(
        Field = rownames(expected_scores)[idx],
        ClassRank = cc,
        Value = expected_scores[idx, cc]
      )
    }
  }
  long_data <- do.call(rbind, plot_data_list)

  # Fieldを因子化（順序保持）
  long_data$Field <- factor(long_data$Field, levels = unique(long_data$Field))

  # 色の設定
  n_fields <- length(selected_fields)
  if (is.null(colors)) {
    colors <- .gg_exametrika_palette(n_fields)
  }

  # msg取得（Class or Rank）
  msg <- if ("msg" %in% names(data)) data$msg else "Class"

  # プロット作成
  p <- ggplot(long_data, aes(x = ClassRank, y = Value, color = Field, group = Field)) +
    geom_line(linewidth = 0.8, linetype = linetype) +
    geom_point(size = 2) +
    scale_x_continuous(breaks = 1:ncls) +
    scale_y_continuous(breaks = seq(0, ceiling(max(long_data$Value)), by = 0.25)) +
    labs(
      x = paste("Latent", msg),
      y = y_label,
      color = "Field"
    ) +
    theme(legend.position = legend_position)

  # 色のスケール設定
  if (!is.null(colors)) {
    p <- p + scale_color_manual(values = colors)
  }

  # タイトル設定
  if (is.logical(title)) {
    if (title) {
      if (is_polytomous) {
        title_text <- paste0("Field Reference Profile (",
                             toupper(substring(stat, 1, 1)),
                             substring(stat, 2), ")")
      } else {
        title_text <- "Field Reference Profile"
      }
      p <- p + labs(title = title_text)
    }
  } else if (is.character(title)) {
    p <- p + labs(title = title)
  }

  # 凡例制御
  if (!show_legend) {
    p <- p + theme(legend.position = "none")
  }

  return(p)
}

#' @title Plot Test Reference Profile (TRP) from exametrika
#'
#' @description
#' This function takes exametrika output as input and generates a
#' Test Reference Profile (TRP) plot using ggplot2. TRP shows the
#' number of students in each latent class/rank (bar graph) and the
#' expected test score for each class/rank (line graph).
#'
#' @param data An object from exametrika: LCA, LRA, Biclustering, IRM,
#'   LDB, or BINET output.
#' @param Num_Students Logical. If \code{TRUE} (default), display the
#'   number of students on each bar.
#' @param title Logical. If \code{TRUE} (default), display the plot title.
#'
#' @return A single ggplot object with dual y-axes showing both the
#'   student distribution and expected scores.
#'
#' @details
#' The Test Reference Profile provides an overview of the latent structure.
#' The bar graph shows how students are distributed across classes/ranks,
#' while the line graph shows the expected test score for each class/rank.
#' In well-fitted models, expected scores should increase monotonically
#' with class/rank number.
#'
#' @examples
#' \dontrun{
#' library(exametrika)
#' result <- LRA(J15S500, nrank = 5)
#' plot <- plotTRP_gg(result)
#' plot
#' }
#'
#' @seealso \code{\link{plotIRP_gg}}, \code{\link{plotLCD_gg}},
#'   \code{\link{plotLRD_gg}}
#'
#' @importFrom ggplot2 ggplot
#' @importFrom ggplot2 geom_bar
#' @importFrom ggplot2 geom_point
#' @importFrom ggplot2 geom_line
#' @importFrom ggplot2 scale_x_continuous
#' @importFrom ggplot2 scale_y_continuous
#' @importFrom ggplot2 annotate
#' @importFrom ggplot2 theme
#' @importFrom ggplot2 labs
#' @export

plotTRP_gg <- function(data,
                       Num_Students = TRUE,
                       title = TRUE) {
  if (all(class(data) %in% c("exametrika", "LCA")) ||
    all(class(data) %in% c("exametrika", "BINET"))) {
    xlabel <- "Latent Class"
  } else if (all(class(data) %in% c("exametrika", "LRA")) ||
    all(class(data) %in% c("exametrika", "Biclustering")) ||
    all(class(data) %in% c("exametrika", "IRM")) ||
    all(class(data) %in% c("exametrika", "LDB")) ||
    all(class(data) %in% c("exametrika", "LDLRA"))) {
    xlabel <- "Latent Rank"
  } else {
    stop(
      "Invalid input. The variable must be from exametrika output or from either LCA, LRA, Biclustering, LDLRA, LDB, or BINET."
    )
  }

  # 受検者分布: rank系モデルはLRD優先、class系モデルはLCD優先（フォールバック付き）
  if (xlabel == "Latent Rank") {
    dist_data <- .first_non_null(data$LRD, data$LCD)
  } else {
    dist_data <- .first_non_null(data$LCD, data$LRD)
  }
  if (is.null(dist_data)) {
    stop("No LCD or LRD data found in the input object.")
  }

  x1 <- data.frame(
    LC = seq_along(dist_data),
    Num = c(dist_data)
  )

  x2 <- data.frame(
    LC = c(1:length(data$TRP)),
    ES = c(data$TRP)
  )

  variable_scaler <- function(y2, yaxis1, yaxis2) {
    a <- diff(yaxis1) / diff(yaxis2)
    b <-
      (yaxis1[1] * yaxis2[2] - yaxis1[2] * yaxis2[1]) / diff(yaxis2)
    a * y2 + b
  }

  axis_scaler <- function(y1, yaxis1, yaxis2) {
    c <- diff(yaxis2) / diff(yaxis1)
    d <-
      (yaxis2[1] * yaxis1[2] - yaxis2[2] * yaxis1[1]) / diff(yaxis1)
    c * y1 + d
  }


  yaxis1 <- c(0, max(x1$Num))
  yaxis2 <- c(0, max(x2$ES))

  if (Num_Students == T) {
    Num_label <- c(x1$Num)
  } else {
    Num_label <- ""
  }

  if (title == T) {
    title <- "Test Reference Profile"
  } else {
    title <- ""
  }


  plot <- ggplot(x1, aes(x = LC, y = Num)) +
    geom_bar(
      stat = "identity",
      fill = "gray",
      colour = "black"
    ) +
    geom_point(aes(y = variable_scaler(x2$ES, yaxis1, yaxis2)), size = 2.1) +
    geom_line(aes(y = variable_scaler(x2$ES, yaxis1, yaxis2)), linetype = "dashed") +
    scale_x_continuous(breaks = c(1:length(data$TRP))) +
    scale_y_continuous(
      name = "Number of Students",
      sec.axis = sec_axis(trans = ~ (axis_scaler(
        ., yaxis1, yaxis2
      )), name = "Expected Score")
    ) +
    annotate(
      "text",
      x = x1$LC,
      y = x1$Num - (median(x1$Num) * 0.05),
      label = Num_label
    ) +
    theme(axis.title.y.right = element_text(angle = 90, vjust = 0.5)) +
    labs(
      title = title,
      x = xlabel
    )


  return(plot)
}


#' @title Plot Latent Class Distribution (LCD) from exametrika
#'
#' @description
#' This function takes exametrika output as input and generates a
#' Latent Class Distribution (LCD) plot using ggplot2. LCD shows the
#' number of students in each latent class and the class membership
#' distribution.
#'
#' @param data An object of class \code{c("exametrika", "LCA")} or
#'   \code{c("exametrika", "BINET")}. If LRA or Biclustering output
#'   is provided, LRD will be plotted instead with a warning.
#' @param Num_Students Logical. If \code{TRUE} (default), display the
#'   number of students on each bar.
#' @param title Logical. If \code{TRUE} (default), display the plot title.
#'
#' @return A single ggplot object with dual y-axes showing both the
#'   student count and membership frequency.
#'
#' @details
#' The Latent Class Distribution shows how students are distributed
#' across latent classes. The bar graph shows the number of students
#' assigned to each class, and the line graph shows the cumulative
#' class membership distribution.
#'
#' @examples
#' \dontrun{
#' library(exametrika)
#' result <- LCA(J15S500, ncls = 5)
#' plot <- plotLCD_gg(result)
#' plot
#' }
#'
#' @seealso \code{\link{plotLRD_gg}}, \code{\link{plotTRP_gg}}
#'
#' @importFrom ggplot2 ggplot
#' @importFrom ggplot2 geom_bar
#' @importFrom ggplot2 geom_point
#' @importFrom ggplot2 geom_line
#' @importFrom ggplot2 scale_x_continuous
#' @importFrom ggplot2 scale_y_continuous
#' @importFrom ggplot2 annotate
#' @importFrom ggplot2 theme
#' @importFrom ggplot2 labs
#' @export

plotLCD_gg <- function(data,
                       Num_Students = TRUE,
                       title = TRUE) {
  # Validate exametrika object
  if (!inherits(data, "exametrika")) {
    stop("Invalid input. The variable must be from exametrika output.")
  }

  # Check model type
  if (any(class(data) %in% c("LCA", "BINET"))) {
    xlabel <- "Latent Class"
    mode <- TRUE
  } else if (any(class(data) %in% c("LRA", "Biclustering", "ordinalBiclustering", "nominalBiclustering"))) {
    xlabel <- "Latent Rank"
    mode <- FALSE
    warning(
      "The input data was supposed to be visualized with The Latent Rank Distribution, so I will plot the LRD."
    )
  } else if (any(class(data) %in% c("LDLRA", "LDB"))) {
    xlabel <- "Latent Rank"
    mode <- FALSE
    warning(
      "The input data was supposed to be visualized with The Latent Rank Distribution, so I will plot the LRD."
    )
  } else {
    stop(
      "Invalid input. The variable must be from exametrika output or from either LCA or BINET."
    )
  }

  # 受検者分布: class系モデルはLCD優先、rank系モデルはLRD優先（フォールバック付き）
  if (mode) {
    dist_data <- .first_non_null(data$LCD, data$LRD)
    freq_data <- .first_non_null(data$CMD, data$RMD)
  } else {
    dist_data <- .first_non_null(data$LRD, data$LCD)
    freq_data <- .first_non_null(data$RMD, data$CMD)
  }

  x1 <- data.frame(
    LC = seq_along(dist_data),
    Num = c(dist_data)
  )

  x2 <- data.frame(
    LC = seq_along(freq_data),
    Fre = c(freq_data)
  )

  variable_scaler <- function(y2, yaxis1, yaxis2) {
    a <- diff(yaxis1) / diff(yaxis2)
    b <-
      (yaxis1[1] * yaxis2[2] - yaxis1[2] * yaxis2[1]) / diff(yaxis2)
    a * y2 + b
  }

  axis_scaler <- function(y1, yaxis1, yaxis2) {
    c <- diff(yaxis2) / diff(yaxis1)
    d <-
      (yaxis2[1] * yaxis1[2] - yaxis2[2] * yaxis1[1]) / diff(yaxis1)
    c * y1 + d
  }


  yaxis1 <- c(0, max(x1$Num))
  yaxis2 <- c(0, max(x2$Fre))

  if (Num_Students == T) {
    Num_label <- c(x1$Num)
  } else {
    Num_label <- ""
  }

  if (title == T) {
    if (mode == TRUE) {
      title <- "Latent Class Distribution"
    } else if (mode == FALSE) {
      title <- "Latent Rank Distribution"
    }
  } else {
    title <- ""
  }


  plot <- ggplot(x1, aes(x = LC, y = Num)) +
    geom_bar(
      stat = "identity",
      fill = "gray",
      colour = "black"
    ) +
    geom_point(aes(y = variable_scaler(x2$Fre, yaxis1, yaxis2)), size = 2.1) +
    geom_line(aes(y = variable_scaler(x2$Fre, yaxis1, yaxis2)), linetype = "dashed") +
    scale_x_continuous(breaks = c(1:length(data$TRP))) +
    scale_y_continuous(
      name = "Number of Students",
      sec.axis = sec_axis(trans = ~ (axis_scaler(
        ., yaxis1, yaxis2
      )), name = "Frequency")
    ) +
    annotate(
      "text",
      x = x1$LC,
      y = x1$Num - (median(x1$Num) * 0.05),
      label = Num_label
    ) +
    theme(axis.title.y.right = element_text(angle = 90, vjust = 0.5)) +
    labs(
      title = title,
      x = xlabel
    )


  return(plot)
}

#' @title Plot Latent Rank Distribution (LRD) from exametrika
#'
#' @description
#' This function takes exametrika output as input and generates a
#' Latent Rank Distribution (LRD) plot using ggplot2. LRD shows the
#' number of students in each latent rank and the rank membership
#' distribution.
#'
#' @param data An object of class \code{c("exametrika", "LRA")},
#'   \code{c("exametrika", "Biclustering")}, \code{c("exametrika", "LDLRA")},
#'   or \code{c("exametrika", "LDB")}. If LCA or BINET output is provided,
#'   LCD will be plotted instead with a warning.
#' @param Num_Students Logical. If \code{TRUE} (default), display the
#'   number of students on each bar.
#' @param title Logical. If \code{TRUE} (default), display the plot title.
#'
#' @return A single ggplot object with dual y-axes showing both the
#'   student count and membership frequency.
#'
#' @details
#' The Latent Rank Distribution shows how students are distributed
#' across latent ranks. Unlike latent classes, ranks have an ordinal
#' interpretation where higher ranks indicate higher ability levels.
#'
#' @examples
#' \dontrun{
#' library(exametrika)
#' result <- LRA(J15S500, nrank = 5)
#' plot <- plotLRD_gg(result)
#' plot
#' }
#'
#' @seealso \code{\link{plotLCD_gg}}, \code{\link{plotTRP_gg}}
#'
#' @importFrom ggplot2 ggplot
#' @importFrom ggplot2 geom_bar
#' @importFrom ggplot2 geom_point
#' @importFrom ggplot2 geom_line
#' @importFrom ggplot2 scale_x_continuous
#' @importFrom ggplot2 scale_y_continuous
#' @importFrom ggplot2 annotate
#' @importFrom ggplot2 theme
#' @importFrom ggplot2 labs
#' @export

plotLRD_gg <- function(data,
                       Num_Students = TRUE,
                       title = TRUE) {
  # Validate exametrika object
  if (!inherits(data, "exametrika")) {
    stop("Invalid input. The variable must be from exametrika output.")
  }

  # Check model type
  if (any(class(data) %in% c("LCA", "BINET"))) {
    xlabel <- "Latent Class"
    mode <- TRUE
    warning(
      "The input data was supposed to be visualized with The Latent Class Distribution, so I will plot the LCD."
    )
  } else if (any(class(data) %in% c("LRA", "Biclustering", "ordinalBiclustering", "nominalBiclustering"))) {
    xlabel <- "Latent Rank"
    mode <- FALSE
  } else if (any(class(data) %in% c("LDLRA", "LDB"))) {
    xlabel <- "Latent Rank"
    mode <- FALSE
  } else {
    stop(
      "Invalid input. The variable must be from exametrika output or from either LRA, Biclustering, LDLRA or LDB."
    )
  }

  # 受検者分布: class系モデルはLCD優先、rank系モデルはLRD優先（フォールバック付き）
  if (mode) {
    dist_data <- .first_non_null(data$LCD, data$LRD)
    freq_data <- .first_non_null(data$CMD, data$RMD)
  } else {
    dist_data <- .first_non_null(data$LRD, data$LCD)
    freq_data <- .first_non_null(data$RMD, data$CMD)
  }

  x1 <- data.frame(
    LC = seq_along(dist_data),
    Num = c(dist_data)
  )

  x2 <- data.frame(
    LC = seq_along(freq_data),
    Fre = c(freq_data)
  )

  variable_scaler <- function(y2, yaxis1, yaxis2) {
    a <- diff(yaxis1) / diff(yaxis2)
    b <-
      (yaxis1[1] * yaxis2[2] - yaxis1[2] * yaxis2[1]) / diff(yaxis2)
    a * y2 + b
  }

  axis_scaler <- function(y1, yaxis1, yaxis2) {
    c <- diff(yaxis2) / diff(yaxis1)
    d <-
      (yaxis2[1] * yaxis1[2] - yaxis2[2] * yaxis1[1]) / diff(yaxis1)
    c * y1 + d
  }


  yaxis1 <- c(0, max(x1$Num))
  yaxis2 <- c(0, max(x2$Fre))

  if (Num_Students == T) {
    Num_label <- c(x1$Num)
  } else {
    Num_label <- ""
  }

  if (title == T) {
    if (mode == TRUE) {
      title <- "Latent Class Distribution"
    } else if (mode == FALSE) {
      title <- "Latent Rank Distribution"
    }
  } else {
    title <- ""
  }


  plot <- ggplot(x1, aes(x = LC, y = Num)) +
    geom_bar(
      stat = "identity",
      fill = "gray",
      colour = "black"
    ) +
    geom_point(aes(y = variable_scaler(x2$Fre, yaxis1, yaxis2)), size = 2.1) +
    geom_line(aes(y = variable_scaler(x2$Fre, yaxis1, yaxis2)), linetype = "dashed") +
    scale_x_continuous(breaks = c(1:length(data$TRP))) +
    scale_y_continuous(
      name = "Number of Students",
      sec.axis = sec_axis(trans = ~ (axis_scaler(
        ., yaxis1, yaxis2
      )), name = "Frequency")
    ) +
    annotate(
      "text",
      x = x1$LC,
      y = x1$Num - (median(x1$Num) * 0.05),
      label = Num_label
    ) +
    theme(axis.title.y.right = element_text(angle = 90, vjust = 0.5)) +
    labs(
      title = title,
      x = xlabel
    )


  return(plot)
}


#' @title Plot Class Membership Profile (CMP) from exametrika
#'
#' @description
#' This function takes exametrika output as input and generates
#' Class Membership Profile (CMP) plots using ggplot2. CMP shows
#' each student's membership probability across all latent classes.
#'
#' @param data An object of class \code{c("exametrika", "LCA")} or
#'   \code{c("exametrika", "BINET")}. If LRA, Biclustering, LDLRA, or LDB
#'   output is provided, RMP will be plotted instead with a warning.
#'
#' @return A list of ggplot objects, one for each student. Each plot shows
#'   the membership probability across all latent classes.
#'
#' @details
#' The Class Membership Profile visualizes how strongly each student
#' belongs to each latent class. Students with high membership probability
#' in a single class are well-classified, while students with similar
#' probabilities across classes may be ambiguous cases.
#'
#' @examples
#' \dontrun{
#' library(exametrika)
#' result <- LCA(J15S500, ncls = 5)
#' plots <- plotCMP_gg(result)
#' plots[[1]] # Show CMP for the first student
#' }
#'
#' @seealso \code{\link{plotRMP_gg}}, \code{\link{plotLCD_gg}}
#'
#' @importFrom ggplot2 ggplot
#' @importFrom ggplot2 ylim
#' @importFrom ggplot2 geom_point
#' @importFrom ggplot2 geom_line
#' @importFrom ggplot2 scale_x_continuous
#' @importFrom ggplot2 labs
#' @export


plotCMP_gg <- function(data) {
  # Validate exametrika object
  if (!inherits(data, "exametrika")) {
    stop("Invalid input. The variable must be from exametrika output.")
  }

  # Check model type
  if (any(class(data) %in% c("LCA"))) {
    xlabel <- "Class"
    change_rowname <- NULL
    dig <- nchar(nrow(data$Students))
    for (i in 1:nrow(data$Students)) {
      change_rowname <-
        c(change_rowname, paste0("Student ", formatC(
          i,
          width = dig, flag = "0"
        )))
    }
    rownames(data$Students) <- change_rowname
  } else if (any(class(data) %in% c("BINET"))) {
    xlabel <- "Class"
  } else if (any(class(data) %in% c("LRA", "Biclustering", "ordinalBiclustering", "nominalBiclustering", "LDB", "LDLRA"))) {
    xlabel <- "Rank"
    warning(
      "The input data was supposed to be visualized with The Rank Membership Profile, so I will plot the RMP."
    )
  } else {
    stop(
      "Invalid input. The variable must be from exametrika output or from either LCA or BINET."
    )
  }


  # フォールバック付きでクラス/ランク数を取得（新名称優先）
  n_cls <- .first_non_null(data$n_class, data$Nclass, data$n_rank, data$Nrank)

  if (is.null(n_cls) || n_cls < 2 || n_cls > 20) {
    stop("Invalid number of Class or Rank")
  }

  # 列名ベースでMembership列を取得（列ズレ防止）
  membership_cols <- grep("^Membership", colnames(data$Students))
  if (length(membership_cols) == 0) {
    stop("No 'Membership' columns found in data$Students")
  }

  plots <- list()

  for (i in 1:nrow(data$Students)) {
    x <- data.frame(
      Membership = as.numeric(data$Students[i, membership_cols]),
      rank = seq_along(membership_cols)
    )

    plots[[i]] <- ggplot(x, aes(x = rank, y = Membership)) +
      scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.25)) +
      geom_point() +
      geom_line(linetype = "dashed") +
      scale_x_continuous(breaks = seq_along(membership_cols)) +
      labs(
        title = paste0(
          xlabel,
          " Membership Profile, ",
          rownames(data$Students)[i]
        ),
        x = paste0("Latent ", xlabel),
        y = "Membership"
      )
  }

  return(plots)
}

#' @title Plot Rank Membership Profile (RMP) from exametrika
#'
#' @description
#' This function takes exametrika output as input and generates
#' Rank Membership Profile (RMP) plots using ggplot2. RMP shows
#' each student's membership probability across all latent ranks.
#'
#' @param data An object of class \code{c("exametrika", "LRA")},
#'   \code{c("exametrika", "Biclustering")}, \code{c("exametrika", "LDLRA")},
#'   or \code{c("exametrika", "LDB")}. If LCA or BINET output is provided,
#'   CMP will be plotted instead with a warning.
#'
#' @return A list of ggplot objects, one for each student. Each plot shows
#'   the membership probability across all latent ranks.
#'
#' @details
#' The Rank Membership Profile visualizes how strongly each student
#' belongs to each latent rank. Unlike class membership, rank membership
#' has an ordinal interpretation. Students with unimodal profiles
#' centered on a single rank are well-classified.
#'
#' @examples
#' \dontrun{
#' library(exametrika)
#' result <- LRA(J15S500, nrank = 5)
#' plots <- plotRMP_gg(result)
#' plots[[1]] # Show RMP for the first student
#' }
#'
#' @seealso \code{\link{plotCMP_gg}}, \code{\link{plotLRD_gg}}
#'
#' @importFrom ggplot2 ggplot
#' @importFrom ggplot2 ylim
#' @importFrom ggplot2 geom_point
#' @importFrom ggplot2 geom_line
#' @importFrom ggplot2 scale_x_continuous
#' @importFrom ggplot2 labs
#' @export

plotRMP_gg <- function(data) {
  # Validate exametrika object
  if (!inherits(data, "exametrika")) {
    stop("Invalid input. The variable must be from exametrika output.")
  }

  # Check model type
  if (any(class(data) %in% c("LCA"))) {
    xlabel <- "Class"
    change_rowname <- NULL
    dig <- nchar(nrow(data$Students))
    warning(
      "The input data was supposed to be visualized with The Class Membership Profile, so I will plot the CMP."
    )
    for (i in 1:nrow(data$Students)) {
      change_rowname <-
        c(change_rowname, paste0("Student ", formatC(
          i,
          width = dig, flag = "0"
        )))
    }
    rownames(data$Students) <- change_rowname
  } else if (any(class(data) %in% c("BINET"))) {
    xlabel <- "Class"
    warning(
      "The input data was supposed to be visualized with The Class Membership Profile, so I will plot the CMP."
    )
  } else if (any(class(data) %in% c("LRA", "Biclustering", "ordinalBiclustering", "nominalBiclustering", "LDB", "LDLRA"))) {
    xlabel <- "Rank"
  } else {
    stop(
      "Invalid input. The variable must be from exametrika output or from either LRA, Biclustering, LDLRA or LDB."
    )
  }


  # フォールバック付きでクラス/ランク数を取得（新名称優先）
  n_cls <- .first_non_null(data$n_class, data$Nclass, data$n_rank, data$Nrank)

  if (is.null(n_cls) || n_cls < 2 || n_cls > 20) {
    stop("Invalid number of Class or Rank")
  }

  # 列名ベースでMembership列を取得（列ズレ防止）
  membership_cols <- grep("^Membership", colnames(data$Students))
  if (length(membership_cols) == 0) {
    stop("No 'Membership' columns found in data$Students")
  }

  plots <- list()

  for (i in 1:nrow(data$Students)) {
    x <- data.frame(
      Membership = as.numeric(data$Students[i, membership_cols]),
      rank = seq_along(membership_cols)
    )

    plots[[i]] <- ggplot(x, aes(x = rank, y = Membership)) +
      scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.25)) +
      geom_point() +
      geom_line(linetype = "dashed") +
      scale_x_continuous(breaks = seq_along(membership_cols)) +
      labs(
        title = paste0(
          xlabel,
          " Membership Profile, ",
          rownames(data$Students)[i]
        ),
        x = paste0("Latent ", xlabel),
        y = "Membership"
      )
  }

  return(plots)
}
