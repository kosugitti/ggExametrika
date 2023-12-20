devtools::install_github("kosugitti/Exametrika")

library(Exametrika)

library(ggplot2)

CTT(J15S500)

result.IRT <- IRT(J15S500, model = 2)

plotTIC_gg(result.IRT)

class(result.IRT)

result.IRT


plot(result.IRT, type = "TIC")

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

plll <- TestInformationFunc(result.IRT$params, c(1:101))

curve(TestInformationFunc(result.IRT$params, x),
      from = -4,
      to = 4,
      xlab = "ability", ylab = "Information",
      main = "Test Informaiton Curve"
      )

curve(TestInformationFunc(mm, theta = x))

plot(result.IRT, type = "TIC", items = 1:6, nc = 2, nr = 3)

result.IRT <- IRT(J15S500, model = 3)

plot(result.IRT, type = "TIC")

plotTIC_gg <- function(data, xvariable = c(-4, 4)) {
    if (!all(class(data) %in% c("Exametrika", "IRT"))) {
        stop("Invalid input. The variable must be from Exametrika output or an output from IRT.")
    }

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
            tmp <- tmp + ItemInformationFunc(x, a = a, b = b, c = c, d = d)
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

tl <- nrow(result.IRT$params)

params <- result.IRT$params

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

ItemInformationFunc <- function(x, a = 1, b, c = 0, d = 1) {
    numerator <- a^2 * (LogisticModel(x, a, b, c, d) - c) * (d - LogisticModel(x, a, b, c, d)) *
        (LogisticModel(x, a, b, c, d) * (c + d - LogisticModel(x, a, b, c, d)) - c * d)
    denominator <- (d - c)^2 * LogisticModel(x, a, b, c, d) * (1 - LogisticModel(x, a, b, c, d))
    tmp <- numerator / denominator
    return(tmp)
}

TestInformationFunc <- function(x, params) {

    ItemInformationFunc <- function(a = 1, b, c = 1, d = 0, theta) {
        numerator <- a^2 * (LogisticModel(a, b, c, d, theta) - c) * (d - LogisticModel(a, b, c, d, theta)) *
            (LogisticModel(a, b, c, d, theta) * (c + d - LogisticModel(a, b, c, d, theta)) - c * d)
        denominator <- (d - c)^2 * LogisticModel(a, b, c, d, theta) * (1 - LogisticModel(a, b, c, d, theta))
        tmp <- numerator / denominator
        return(tmp)
    }

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


tl <- nrow(result.IRT$params)

a <- result.IRT$params[1, 1]








ItemInformationFunc <- function(x, a = 1, b, c = 0, d = 1) {
    numerator <- a^2 * (LogisticModel(x, a, b, c, d) - c) * (d - LogisticModel(x, a, b, c, d)) *
        (LogisticModel(x, a, b, c, d) * (c + d - LogisticModel(x, a, b, c, d)) - c * d)
    denominator <- (d - c)^2 * LogisticModel(x, a, b, c, d) * (1 - LogisticModel(x, a, b, c, d))
    tmp <- numerator / denominator
    return(tmp)
}



ggplot(data = data.frame(x = c(-4,4))) +
    xlim(-4, 4) +
    stat_function(fun = TestInformationFunc, args = result.IRT$params) +
    labs(
        title = "Test Information Curve",
        x = "ability",
        y = "information"
    )


x <- c(1:101)

TestInformationFunc(result.IRT$params, 2)



curve(TestInformationFunc(params =  result.IRT$params, theta = x),
      from = -4,
      to = 4,
      xlab = "ability", ylab = "Information",
      main = "Test Informaiton Curve"
      )

ItemInformationFunc <- function(theta, a = 1, b, c = 1, d = 0) {
    numerator <- a^2 * (LogisticModel(a, b, c, d, theta) - c) * (d - LogisticModel(a, b, c, d, theta)) *
        (LogisticModel(a, b, c, d, theta) * (c + d - LogisticModel(a, b, c, d, theta)) - c * d)
    denominator <- (d - c)^2 * LogisticModel(a, b, c, d, theta) * (1 - LogisticModel(a, b, c, d, theta))
    tmp <- numerator / denominator
    return(tmp)
}

plotTIC_gg(result.IRT)

TestInformationFunc()

result.IRT$params[1,4]

result.IRT$params

ncol(result.IRT$params)

plotTIC_gg(result.IRT)

TestInformationFunc <- function(theta, params) {
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

ItemInformationFunc <- function(x, a = 1, b, c = 0, d = 1) {
    numerator <- a^2 * (LogisticModel(x, a, b, c, d) - c) * (d - LogisticModel(x, a, b, c, d)) *
        (LogisticModel(x, a, b, c, d) * (c + d - LogisticModel(x, a, b, c, d)) - c * d)
    denominator <- (d - c)^2 * LogisticModel(x, a, b, c, d) * (1 - LogisticModel(x, a, b, c, d))
    tmp <- numerator / denominator
    return(tmp)
}

x <- seq(-4,4,101)

ItemInformationFunc(x, result.IRT$params[1,1], result.IRT$params[1,2], result.IRT$params[1,3], 1)

is.null(result.IRT$params[1,4])


multi <- function(x) {
    total <- 0
    for (i in 1:15) {
        total <- total + ItemInformationFunc(
            x,
            result.IRT$params[i, 1],  # slope
            result.IRT$params[i, 2],  # location
            ifelse(is.null(result.IRT$params[i, 3]), 0, result.IRT$params[i, 3]),  # rower
            ifelse(is.null(result.IRT$params[i, 4]), 1, result.IRT$params[i, 4])  # upper
        )
    }
    return(total)
}



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
        for (i in 1:15) {
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

plotTIC_gg(result.IRT)


IIC <- list()

x <- seq(-4,4,0.07)


p <- ggplot(data=data.frame(X=c(-4,4)), aes(x=X))
p <- p + stat_function(fun=dnorm)
p <- p + stat_function(fun=dnorm, args=list(mean=2, sd=.5))
p <- p + stat_function(fun=function(x) 0.01*x^2-0.1)

p <- plotIIC_gg(result.IRT)

p[[12]]


library(ggplot2)

# 複数の関数を定義
func1 <- function(x) x^2
func2 <- function(x) 2 * x
func3 <- function(x) sin(x)

# ggplot2で描画
ggplot(data.frame(x = c(-5, 5)), aes(x)) +
    stat_function(fun = func1, color = "red") +
    stat_function(fun = func2, color = "blue") +
    stat_function(fun = func3, color = "green") +
    xlim(-5, 5)


combined_function <- function(x) sin(x) + cos(x)

# ggplot2で描画
ggplot(data.frame(x = c(-2 * pi, 2 * pi)), aes(x)) +
    stat_function(fun = combined_function, color = "blue") +
    xlim(-2 * pi, 2 * pi) +
    ylim(-2, 2)


ggplot(data = data.frame(x = c(-4, 4))) +
    xlim(-4, 4) +
    stat_function(fun = multi) +
    labs(
        title = "Item Information Curve, ",
        x = "ability",
        y = "information"
    )

multi <- function(x) ItemInformationFunc(x, result.IRT$params[1,1],result.IRT$params[1,2],result.IRT$params[1,3],1) + ItemInformationFunc(x, result.IRT$params[2,1],result.IRT$params[2,2],result.IRT$params[2,3],1) + ItemInformationFunc(x, result.IRT$params[3,1],result.IRT$params[3,2],result.IRT$params[3,3],1) +
    ItemInformationFunc(x, result.IRT$params[4,1],result.IRT$params[4,2],result.IRT$params[4,3],1) + ItemInformationFunc(x, result.IRT$params[5,1],result.IRT$params[5,2],result.IRT$params[5,3],1) + ItemInformationFunc(x, result.IRT$params[6,1],result.IRT$params[6,2],result.IRT$params[6,3],1) +
    ItemInformationFunc(x, result.IRT$params[7,1],result.IRT$params[7,2],result.IRT$params[7,3],1) + ItemInformationFunc(x, result.IRT$params[8,1],result.IRT$params[8,2],result.IRT$params[8,3],1) + ItemInformationFunc(x, result.IRT$params[9,1],result.IRT$params[9,2],result.IRT$params[9,3],1) +
    ItemInformationFunc(x, result.IRT$params[10,1],result.IRT$params[10,2],result.IRT$params[10,3],1) + ItemInformationFunc(x, result.IRT$params[11,1],result.IRT$params[11,2],result.IRT$params[11,3],1) + ItemInformationFunc(x, result.IRT$params[12,1],result.IRT$params[12,2],result.IRT$params[12,3],1) +
    ItemInformationFunc(x, result.IRT$params[13,1],result.IRT$params[13,2],result.IRT$params[13,3],1) + ItemInformationFunc(x, result.IRT$params[14,1],result.IRT$params[14,2],result.IRT$params[14,3],1) + ItemInformationFunc(x, result.IRT$params[15,1],result.IRT$params[15,2],result.IRT$params[15,3],1)

multi <- function(x, params) {
    total <- 0
    for (i in 1:15) {
        total <- total + ItemInformationFunc(
            x,
            params[i, 1],  # slope
            params[i, 2],  # location
            params[i, 3],  # other parameters
            1              # constant parameter
        )
    }
    return(total)
}

multi <- function(x) {
    result <- Reduce(`+`, lapply(1:nrow(params), function(i) {
        ItemInformationFunc(
            x,
            result.IRT$params[i, 1],  # slope
            result.IRT$params[i, 2],  # location
            result.IRT$params[i, 3],  # other parameters
            1              # constant parameter
        )
    }))
    return(result)
}

multi <- function(x) {
    total <- 0
    for (i in 1:15) {
        total <- total + ItemInformationFunc(
            x,
            result.IRT$params[i, 1],  # slope
            result.IRT$params[i, 2],  # location
            result.IRT$params[i, 3],  # other parameters
            1              # constant parameter
        )
    }
    return(total)
}
