library(Exametrika)

library(ggplot2)

CTT(J15S500)

result.IRT <- IRT(J15S500, model = 4)
result.IRT <- IRT(J15S500, model = 3)
result.IRT <- IRT(J15S500, model = 2)


ICC_plot <- function(data){
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

ICC_plot(result.IRT)
ICC_plot(5)
ICC_plot(iris)

# 挙動
# クラスを確認し、当てはまらなければストップエラー
# parameta数を判定して2パラ、3パラ、4パラ
# plotsにlistとして図を格納し、返す

#　問題点
# Exametrikaで出力された中身(名前や順番)をいじられると正しく挙動しなくなる。
# -4から4の範囲で固定


ICC_plot <- function(data, xvariable = c(-4,4)) {
    if (!(all(class(data) == c("Exametrika", "IRT")) && ncol(data$params) %in% c(2, 3, 4))) {
        stop("Invalid input.")
    }

    num_params <- ncol(data$params)

    get_Item_Characteristic_function <- function(num_params) {
        switch(num_params,
               2, function(x, slope, location) {
                   1 / (1 + exp(-1 * slope * (x - location)))
               },
               3, function(x, slope, location, lowerAsym) {
                   lowerAsym + ((1 - lowerAsym) / (1 + exp(-1 * slope * (x - location))))
               },
               4, function(x, slope, location, lowerAsym, upperAsym) {
                   lowerAsym + ((upperAsym - lowerAsym) / (1 + exp(-1 * slope * (x - location))))
               },
               stop("Invalid number of parameters.")
        )
    }

    plots <- NULL

    Item_Characteristic_function <- get_Item_Characteristic_function(num_params)

    for (i in 1:nrow(data$params)) {
        plots[[i]] <- ggplot(data = data.frame(x = xvariable), mapping = aes()) +
            xlim(xvariable[1], xvariable[2]) +
            ylim(0, 1) +
            stat_function(fun = Item_Characteristic_function,
                          args = as.list(data$params[i, ])) +
            labs(
                title = paste0("Item Characteristic Curve, ", rownames(result.IRT$params)[i])
            )
    }

    return(plots)
}

warnings()

a <- ICC_plot(result.IRT)

b <- a[[2]] + theme_dark()

b

ncol(result.IRT$params)

rownames(result.IRT$params)[1]


