devtools::install_github("kosugitti/Exametrika")

library(Exametrika)

library(ggplot2)

CTT(J15S500)

result.IRT <- IRT(J15S500, model = 2)

class(result.IRT)

result.IRT


plot(result.IRT, type = "ICC", items = 1:6, nc = 2, nr = 3)

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
