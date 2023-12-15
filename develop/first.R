devtools::install_github("kosugitti/Exametrika")

library(Exametrika)

library(ggplot2)

CTT(J15S500)

result.IRT <- IRT(J15S500, model = 3)

plotIIC_gg(result.IRT)

class(result.IRT)

result.IRT


plot(result.IRT, type = "IIC", items = 1:6, nc = 2, nr = 3)

k <- NULL

plots <- NULL

result.IRT$params$upperAsym

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



plots <- NULL

result.IRT$params

ggplot(data = result.IRT$params)

ICC_plot(5)

ICC_plot(result.IRT)

a[7]

k
result.IRT$params

all(class(result.IRT) == c("Exametrika","IRT"))

ggplot()

result.IRT$params$slope

length(result.IRT$params)
result.IRT$params
nrow(result.IRT$params)

a <- curve()

nrow(result.IRT$params)



ICC <- ggplot() +
    geom_density()

icc2PL <- function(a, b, theta){
    prob <- 1/(1+exp(-1.7*a*(theta-b)))
    prob
}

icc2PL(a=1,b=1,theta = 0)

x <- seq(-4,4,0.025)

plot(x,icc2PL(a=1,b=1,x))

x <- NULL

p <- NULL

plots <- NULL

plots <- list()

j <- 1

is.numeric(nrow(result.IRT$params))
nrow(result.IRT$params)

plots <- NULL

plots <- list()

i <- 1

Item_Characteristic_function <- function(x, slope, location) {
    1 / (1 + exp(-1.7 * slope * (x - location)))
}

Item_Characteristic_function <- function(x, slope, location, lowerAsym, upperAsym) {
    lowerAsym + ((upperAsym - lowerAsym) / (1 + exp(-1.7 * slope * (x - location))))
}

Item_Characteristic_function <- function(a = 1, b, c = 0, d = 1, theta) {
    p <- c + ((d - c) / (1 + exp(-a * (theta - b))))
    return(p)
}

plots <- NULL

for (i in 1:nrow(result.IRT$params)) {
    plots[[i]] <-
        ggplot(data = data.frame(x = c(-4, 4))) +
        xlim(-4,4) +
        ylim(0,1) +
        stat_function(fun = Item_Characteristic_function,
                      args = list(a = result.IRT$params$slope[i],
                                  b = result.IRT$params$location[i],
                                  c = result.IRT$params$lowerAsym[i],
                                  d = result.IRT$params$upperAsym[i])) +
        labs(
            title = paste0("Item Characteristic Curve, item ",i)
        )
}

result.IRT$params$upperAsym

plots[2]



for (i in 1:nrow(result.IRT$params)) {
    plots[[i]] <-
        ggplot(data = data.frame(x = seq(-4, 4, length.out = 100))) +
        xlim(-4,4) +
        ylim(0,1) +
        stat_function(fun = Item_Characteristic_function,
                      args = list(slope =result.IRT$params$slope[i], location =result.IRT$params$location[i])) +
        labs(
            title = paste0("Item Characteristic Curve, item ",i)
        )
}

plots[[7]]

plots[[2]] <- ggplot(data = data.frame(x = seq(-4, 4, length.out = 100))) +
    xlim(-4,4) +
    ylim(0,1) +
    stat_function(fun = function(x) 1/(1+exp(-1.7*result.IRT$params$slope[[2]]*(x-(result.IRT$params$location[[2]]))))) +
    labs(
        title = paste0("Item Characteristic Curve, item ",2)
)
a <- list(plots)



print(plots)


print(plots[[6]])


result.IRT$params$slope
result.IRT$params$location

plots[[10]]

length(result.IRT$params)

plots[[3]]

print(p[[2]])

nrow(result.IRT$params)

a <- curve(1/(1+exp(-1.7*1*(x-1))), -4, 4)

help("curve")

df <- data.frame(x = seq(-4, 4, length.out = 100))


ICC_function <- function(x) {
    function(x) 1/(1+exp(-1.7*result.IRT$params$slope[1]*(x-result.IRT$params$location[1])))
}

a <- result.IRT$params$slope[1]
b <- result.IRT$params$location[1]

ICC_function(x, result.IRT$params$slope[1],result.IRT$params$location[1])

ggplot(df, aes(x = x)) +
    stat_function(fun = ICC_function, color = "blue") +
    labs(title = "Logistic Function", x = "x", y = "f(x)")

plots[[j]] <-
    ggplot(data = data.frame(x = seq(-4, 4, length.out = 100))) +
    xlim(-4,4) +
    ylim(0,1) +
    stat_function(fun =function(x) 1/(1+exp(-1.7*result.IRT$params$slope[i]*(x-(result.IRT$params$location[i])))))

plots[[15]] <-
    ggplot(data = data.frame(x = seq(-4, 4, length.out = 100))) +
    xlim(-4,4) +
    ylim(0,1) +
    stat_function(fun =function(x) 1/(1+exp(-1.7*result.IRT$params$slope[15]*(x-(result.IRT$params$location[15])))))

plots[[15]]

for (i in 1:nrow(result.IRT$params)) {
    plots[[i]] <-
        ggplot(data = data.frame(x = seq(-4, 4, length.out = 100))) +
        xlim(-4,4) +
        ylim(0,1) +
        stat_function(fun =function(x) 1/(1+exp(-1.7*result.IRT$params$slope[i]*(x-(result.IRT$params$location[i])))))
}


ICC_plot <- function(data, xvariable = c(-4,4)){
    if (all(class(data) == c("Exametrika","IRT"))) {

        plots <- NULL

        for (i in 1:nrow(data$params)) {
            plots[[i]] <-
                ggplot(data = data.frame(x = xvariable)) +
                xlim(xvariable[1],xvariable[2]) +
                ylim(0,1) +
                stat_function(fun = Item_Characteristic_function,
                              args = list(a = data$params$slope[i],
                                          b = data$params$location[i],
                                          c = data$params$lowerAsym[i],
                                          d = data$params$upperAsym[i])) +
                labs(
                    title = paste0("Item Characteristic Curve, item ",i)
                )

        }

        return(plots)


    }else{
        stop("The input variable is not from Exametrika output, nor is it an output from IRT.")
    }


}

Item_Characteristic_function <- function(a = 1, b, c = 0, d = 1, theta) {
    p <- c + ((d - c) / (1 + exp(-a * (theta - b))))
    return(p)
}

m <- c(-4,4)

m[7]

a <- ICC_plot(result.IRT, xvariable = c(-4,4))

a[[7]]

warnings()



# ここまでICC

# ここからIIC

plot(result.IRT, type = "IIC", items = 1:6, nc = 2, nr = 3)

result.IRT$params

for (i in 1:nrow(result.IRT$params)) {
    plots[[i]] <-
        ggplot(data = data.frame(x = c(-4,4))) +
        xlim(-4,4) +
        ylim(0,1) +
        stat_function(fun = Item_Characteristic_function,
                      args = list(a = result.IRT$params$slope[i],
                                  b = result.IRT$params$location[i],
                                  c = result.IRT$params$lowerAsym[i],
                                  d = result.IRT$params$upperAsym[i])) +
        labs(
            title = paste0("Item Characteristic Curve, item ",i)
        )

}

plots[5]

IIF_plot

ItemInformationFunc <- function(a = 1, b, c = 1, d = 0, theta) {
    numerator <- a^2 * (LogisticModel(a, b, c, d, theta) - c) * (d - LogisticModel(a, b, c, d, theta)) *
        (LogisticModel(a, b, c, d, theta) * (c + d - LogisticModel(a, b, c, d, theta)) - c * d)
    denominator <- (d - c)^2 * LogisticModel(a, b, c, d, theta) * (1 - LogisticModel(a, b, c, d, theta))
    tmp <- numerator / denominator
    return(tmp)
}

Item_Characteristic_function()

IIC_plot <- function(data, xvariable = c(-4,4)) {
    if (!all(class(data) %in% c("Exametrika", "IRT"))) {
        stop("Invalid input. The variable must be from Exametrika output or an output from IRT.")
    }

    ItemInformationFunc <- function(x, a = 1, b, c = 1, d = 0) {
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
        args <- c(slope = data$params$slope[i], location = data$params$location[i])
        if (n_params == 3) {
            args["c"] <- data$params$lowerAsym[i]
        }
        if (n_params == 4) {
            args["d"] <- data$params$upperAsym[i]
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
}

args <- c(a = result.IRT$params$slope[15], b = result.IRT$params$location[15])

plots <- list()

plot(result.IRT, type = "IIC", items = 1:6, nc = 2, nr = 3)

plots[15]

plots[[15]] <- ggplot(data = data.frame(x = c(-4, 4))) +
    xlim(-4, 4) +
    stat_function(fun = ItemInformationFunc, args = args) +
    labs(
        title = paste0("Item Information Curve, ", rownames(result.IRT$params)[15]),
        x = "ability",
        y = "information"
    )

result.IRT$params

plots[[15]]

LogisticModel <- function(x, a = 1, b, c = 0, d = 1) {
    p <- c + ((d - c) / (1 + exp(-a * (x - b))))
    return(p)
}


result.IRT$params
plotIIC_gg(result.IRT)

plots[[1]]

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
            ylim(0, 1) +
            stat_function(fun = ItemInformationFunc, args = args) +
            labs(
                title = paste0("Item Information Curve, ", rownames(data$params)[i]),
                x = "ability",
                y = "information"
            )
    }

    return(plots)
}


ItemInformationFunc <- function(x, a = 1, b, c = 0, d = 1) {
    numerator <- a^2 * (LogisticModel(x, a, b, c, d) - c) * (d - LogisticModel(x, a, b, c, d)) *
        (LogisticModel(x, a, b, c, d) * (c + d - LogisticModel(x, a, b, c, d)) - c * d)
    denominator <- (d - c)^2 * LogisticModel(x, a, b, c, d) * (1 - LogisticModel(x, a, b, c, d))
    tmp <- numerator / denominator
    return(tmp)
}

n_params <- ncol(result.IRT$params)
n_params
plots <- list()

for (i in 1:nrow(result.IRT$params)) {
    args <- c(a = result.IRT$params$slope[i], b = result.IRT$params$location[i])
    if (n_params == 3) {
        args["c"] <- result.IRT$params$lowerAsym[i]
    }
    if (n_params == 4) {
        args["d"] <- result.IRT$params$upperAsym[i]
    }

    plots[[i]] <- ggplot(data = data.frame(x = c(-4, 4))) +
        xlim(-4, 4) +
        stat_function(fun = ItemInformationFunc, args = args) +
        labs(
            title = paste0("Item Information Curve, ", rownames(result.IRT$params)[i]),
            x = "ability",
            y = "information"
        )
}


# 以上、IIC
# 以下、TIC

plotTIC_gg <- function(data, xvariable = c(-4, 4)) {
    if (!all(class(data) %in% c("Exametrika", "IRT"))) {
        stop("Invalid input. The variable must be from Exametrika output or an output from IRT.")
    }

    params <- data$params

    TestInformationFunc <- function(params, theta) {
        tl <- nrow(params)
        tmp <- 0
        for (i in 1:tl) {
            a <- params[i, 1]
            b <- params[i, 2]
            if (ncol(params) > 2) {
                c <- params[i, 3]
            } else {
                c <- 0
            }
            if (ncol(params) > 3) {
                d <- params[i, 4]
            } else {
                d <- 1
            }
            tmp <- tmp + ItemInformationFunc(a = a, b = b, c = c, d = d, theta)
        }
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


params <- result.IRT$params

TestInformationFunc <- function(params) {
    tl <- nrow(params)
    tmp <- 0
    for (i in 1:tl) {
        a <- params[i, 1]
        b <- params[i, 2]
        if (ncol(params) > 2) {
            c <- params[i, 3]
        } else {
            c <- 0
        }
        if (ncol(params) > 3) {
            d <- params[i, 4]
        } else {
            d <- 1
        }
        tmp <- tmp + ItemInformationFunc(x, a = a, b = b, c = c, d = d)
    }
    return(tmp)
}

nrow(params)
params[2,2]

TestInformationFunc(params)

TestInformationFunc <- function(params, theta) {
    tl <- nrow(params)
    tmp <- 0
    for (i in 1:tl) {
        a <- params[i, 1]
        b <- params[i, 2]
        if (ncol(params) > 2) {
            c <- params[i, 3]
        } else {
            c <- 0
        }
        if (ncol(params) > 3) {
            d <- params[i, 4]
        } else {
            d <- 1
        }
        tmp <- tmp + ItemInformationFunc(a = a, b = b, c = c, d = d, theta)
    }
    return(tmp)
}

curve(TestInformationFunc(params, theta = x))

plot(result.IRT, type = "TIC", items = 1:6, nc = 2, nr = 3)
