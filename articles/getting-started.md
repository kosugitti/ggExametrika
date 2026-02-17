# Getting Started with ggExametrika

## Overview

**ggExametrika** provides ggplot2-based visualization functions for
outputs from the [exametrika](https://kosugitti.github.io/Exametrika/)
package. It covers a wide range of psychometric models including IRT,
GRM, Latent Class/Rank Analysis, Biclustering, and Bayesian Network
Models.

## Installation

``` r
# Install from GitHub
devtools::install_github("kosugitti/ggExametrika")
```

## Quick Start

``` r
library(exametrika)
library(ggExametrika)
```

### IRT: Item Characteristic Curve (ICC)

``` r
# Run 2PL IRT model
result_irt <- IRT(J15S500, model = 2)

# Plot ICC for all items
plots <- plotICC_gg(result_irt)
plots[[1]]  # Show first item

# Combine multiple plots in a grid
combinePlots_gg(plots, selectPlots = 1:6, ncol = 3)
```

### IRT: Item/Test Information Curve

``` r
# Item Information Curves
iic_plots <- plotIIC_gg(result_irt)
combinePlots_gg(iic_plots, selectPlots = 1:6, ncol = 3)

# Test Information Curve
tic_plot <- plotTIC_gg(result_irt)
tic_plot

# Test Response Function
trf_plot <- plotTRF_gg(result_irt)
trf_plot
```

### GRM: Item Category Response Function (ICRF)

``` r
# Run Graded Response Model
result_grm <- GRM(J5S1000)

# Plot ICRF for all items
icrf_plots <- plotICRF_gg(result_grm)
icrf_plots[[1]]

# GRM also supports IIC and TIC
iic_grm <- plotIIC_gg(result_grm)
tic_grm <- plotTIC_gg(result_grm)
```

### Latent Class Analysis (LCA)

``` r
result_lca <- LCA(J15S500, ncls = 3)

# Item Reference Profile
irp_plots <- plotIRP_gg(result_lca)
combinePlots_gg(irp_plots)

# Field Reference Profile
frp_plot <- plotFRP_gg(result_lca)
frp_plot

# Test Reference Profile
trp_plot <- plotTRP_gg(result_lca)
trp_plot

# Latent Class Distribution
lcd_plot <- plotLCD_gg(result_lca)
lcd_plot

# Class Membership Profile
cmp_plot <- plotCMP_gg(result_lca)
cmp_plot
```

### Latent Rank Analysis (LRA)

``` r
result_lra <- LRA(J15S500, nrank = 4)

# Item/Field/Test Reference Profile
irp_plots <- plotIRP_gg(result_lra)
frp_plot <- plotFRP_gg(result_lra)
trp_plot <- plotTRP_gg(result_lra)

# Latent Rank Distribution
lrd_plot <- plotLRD_gg(result_lra)
lrd_plot

# Rank Membership Profile
rmp_plot <- plotRMP_gg(result_lra)
rmp_plot
```

### Biclustering

``` r
result_bic <- Biclustering(J15S500, nfld = 3, nrank = 4)

# Class/Rank Reference Vectors
crv_plot <- plotCRV_gg(result_bic)
crv_plot

rrv_plot <- plotRRV_gg(result_bic)
rrv_plot

# Array plot (sorted data matrix)
array_plot <- plotArray_gg(result_bic)
array_plot
```

### Bayesian Network Model (BNM) - DAG Visualization

``` r
result_bnm <- BNM(J15S500)

# DAG visualization
dag_plot <- plotGraph_gg(result_bnm)
dag_plot
```

## Common Plot Options

Most plot functions support the following options:

| Parameter         | Description                                        | Default                     |
|-------------------|----------------------------------------------------|-----------------------------|
| `title`           | `TRUE` (auto), `FALSE` (none), or character string | `TRUE`                      |
| `colors`          | Color vector for lines/bars                        | Colorblind-friendly palette |
| `linetype`        | Line type (`"solid"`, `"dashed"`, etc.)            | `"solid"`                   |
| `show_legend`     | Show legend                                        | `TRUE`                      |
| `legend_position` | `"right"`, `"top"`, `"bottom"`, `"left"`, `"none"` | `"right"`                   |

Example:

``` r
plotICC_gg(result_irt,
  title = "Custom Title",
  colors = c("red", "blue"),
  linetype = "dashed",
  show_legend = FALSE
)
```

## Function Reference

### IRT (2PL, 3PL, 4PL)

| Function                                                                           | Description               |
|------------------------------------------------------------------------------------|---------------------------|
| [`plotICC_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotICC_gg.md) | Item Characteristic Curve |
| [`plotIIC_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotIIC_gg.md) | Item Information Curve    |
| [`plotTIC_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotTIC_gg.md) | Test Information Curve    |
| [`plotTRF_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotTRF_gg.md) | Test Response Function    |

### GRM (Graded Response Model)

| Function                                                                             | Description                     |
|--------------------------------------------------------------------------------------|---------------------------------|
| [`plotICRF_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotICRF_gg.md) | Item Category Response Function |
| [`plotIIC_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotIIC_gg.md)   | Item Information Curve (GRM)    |
| [`plotTIC_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotTIC_gg.md)   | Test Information Curve (GRM)    |

### Latent Class/Rank Models

| Function                                                                           | Description               |
|------------------------------------------------------------------------------------|---------------------------|
| [`plotIRP_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotIRP_gg.md) | Item Reference Profile    |
| [`plotFRP_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotFRP_gg.md) | Field Reference Profile   |
| [`plotTRP_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotTRP_gg.md) | Test Reference Profile    |
| [`plotLCD_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotLCD_gg.md) | Latent Class Distribution |
| [`plotLRD_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotLRD_gg.md) | Latent Rank Distribution  |
| [`plotCMP_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotCMP_gg.md) | Class Membership Profile  |
| [`plotRMP_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotRMP_gg.md) | Rank Membership Profile   |

### Biclustering

| Function                                                                                       | Description            |
|------------------------------------------------------------------------------------------------|------------------------|
| [`plotCRV_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotCRV_gg.md)             | Class Reference Vector |
| [`plotRRV_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotRRV_gg.md)             | Rank Reference Vector  |
| [`plotArray_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotArray_gg.md)         | Array Plot             |
| [`plotFieldPIRP_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotFieldPIRP_gg.md) | Field PIRP Plot        |

### DAG Visualization

| Function                                                                               | Description            |
|----------------------------------------------------------------------------------------|------------------------|
| [`plotGraph_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotGraph_gg.md) | Directed Acyclic Graph |

### Utilities

| Function                                                                                                     | Description                      |
|--------------------------------------------------------------------------------------------------------------|----------------------------------|
| [`combinePlots_gg()`](https://kosugitti.github.io/ggExametrika/reference/combinePlots_gg.md)                 | Arrange multiple plots in a grid |
| [`LogisticModel()`](https://kosugitti.github.io/ggExametrika/reference/LogisticModel.md)                     | Four-parameter logistic model    |
| [`ItemInformationFunc()`](https://kosugitti.github.io/ggExametrika/reference/ItemInformationFunc.md)         | IRT item information function    |
| [`ItemInformationFunc_GRM()`](https://kosugitti.github.io/ggExametrika/reference/ItemInformationFunc_GRM.md) | GRM item information function    |
