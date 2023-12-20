LCA(J15S500, ncls = 5)

result.LCA <- LCA(J15S500, ncls = 5)
head(result.LCA$Students)

plot(result.LCA, type = "IRP", items = 1:6, nc = 2, nr = 3)

plot(result.LCA, type = "CMP", students = 1:9, nc = 3, nr = 3)

plot(result.LCA, type = "TRP")

plot(result.LCA, type = "LCD")

plotIRP_gg <- function(data, xvariable = c(-4,4)) {
    if (!all(class(data) %in% c("Exametrika", "IRT"))) {
        stop("Invalid input. The variable must be from Exametrika output or an output from IRT.")
    }

    Item_Characteristic_function <- function(x, slope = 1, location, lowerAsym = 0, upperAsym = 1) {
        lowerAsym + ((upperAsym - lowerAsym) / (1 + exp(-1 * slope * (x - location))))
    }

    n_params <- ncol(data$params)

    if (n_params < 2 || n_params > 4) {
        stop("Invalid number of parameters.")
    }

    plots <- list()

    for (i in 1:nrow(data$params)) {
        args <- c(slope = data$params$slope[i], location = data$params$location[i])
        if (n_params == 3) {
            args["lowerAsym"] <- data$params$lowerAsym[i]
        }
        if (n_params == 4) {
            args["upperAsym"] <- data$params$upperAsym[i]
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
    combinePlots_gg(plots)
}
