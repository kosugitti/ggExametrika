# Plot Field Reference Profile (FRP) from exametrika

This function takes exametrika output as input and generates a Field
Reference Profile (FRP) plot using ggplot2. For binary data, it displays
correct response rates. For polytomous data, it shows expected scores
calculated using the specified statistic.

## Usage

``` r
plotFRP_gg(
  data,
  stat = "mean",
  fields = NULL,
  title = TRUE,
  colors = NULL,
  linetype = "solid",
  show_legend = TRUE,
  legend_position = "right"
)
```

## Arguments

- data:

  An object from exametrika: Biclustering, nominalBiclustering,
  ordinalBiclustering, IRM, LDB, or BINET output.

- stat:

  Character. Statistic to use for polytomous data: `"mean"` (default),
  `"median"`, or `"mode"`. Ignored for binary data.

- fields:

  Integer vector specifying which fields to plot. Default is all fields.

- title:

  Logical or character. If `TRUE` (default), display automatic title. If
  `FALSE`, no title. If a character string, use it as the title.

- colors:

  Character vector. Colors for each field line. If `NULL` (default),
  uses the package default palette.

- linetype:

  Character or numeric. Line type for all lines. Default is `"solid"`.

- show_legend:

  Logical. If `TRUE` (default), display the legend.

- legend_position:

  Character. Position of the legend: `"right"` (default), `"top"`,
  `"bottom"`, `"left"`, `"none"`.

## Value

A single ggplot object with all selected fields.

## Details

The Field Reference Profile shows how response patterns vary across
latent classes/ranks for each field (cluster of items).

For **binary data** (Biclustering, IRM, LDB, BINET):

- Y-axis: Correct Response Rate (0-1)

- Each line represents one field

For **polytomous data** (nominalBiclustering, ordinalBiclustering):

- Y-axis: Expected Score (calculated using `stat` parameter)

- `stat = "mean"`: Weighted average across categories (default)

- `stat = "median"`: Median category value

- `stat = "mode"`: Most probable category

## See also

[`plotIRP_gg`](https://kosugitti.github.io/ggExametrika/reference/plotIRP_gg.md),
[`plotTRP_gg`](https://kosugitti.github.io/ggExametrika/reference/plotTRP_gg.md),
[`plotCRV_gg`](https://kosugitti.github.io/ggExametrika/reference/plotCRV_gg.md),
[`plotRRV_gg`](https://kosugitti.github.io/ggExametrika/reference/plotRRV_gg.md)

## Examples

``` r
library(exametrika)

# Binary biclustering
result_bin <- Biclustering(J35S515, ncls = 4, nfld = 3)
#> Biclustering is chosen.
#> iter 1 log_lik -8202.94                                                         
#> iter 2 log_lik -7852.32                                                         
#> iter 3 log_lik -7799.84                                                         
#> iter 4 log_lik -7773.54                                                         
#> iter 5 log_lik -7759.88                                                         
#> iter 6 log_lik -7752.48                                                         
#> iter 7 log_lik -7748.21                                                         
#> iter 8 log_lik -7745.63                                                         
#> iter 9 log_lik -7743.98                                                         
#> iter 10 log_lik -7742.87                                                        
#> iter 11 log_lik -7742.06                                                        
#> iter 12 log_lik -7741.42                                                        
#> 
#> 
#> Strongly ordinal alignment condition was satisfied.
plot <- plotFRP_gg(result_bin)

# Ordinal biclustering with mean (default)
result_ord <- Biclustering(J35S500, ncls = 4, nfld = 3)
#> Biclustering is chosen.
#> iter 1 log_lik -22980                                                           
#> iter 2 log_lik -22136.6                                                         
#> iter 3 log_lik -21583.8                                                         
#> iter 4 log_lik -21383.8                                                         
#> iter 5 log_lik -21354.4                                                         
#> iter 6 log_lik -21339.3                                                         
#> iter 7 log_lik -21321.3                                                         
#> iter 8 log_lik -21298                                                           
#> iter 9 log_lik -21272                                                           
#> iter 10 log_lik -21250.4                                                        
#> iter 11 log_lik -21238                                                          
#> iter 12 log_lik -21233.1                                                        
#> iter 13 log_lik -21229.5                                                        
#> iter 14 log_lik -21226.5                                                        
#> iter 15 log_lik -21224.3                                                        
#> iter 16 log_lik -21222.6                                                        
#> iter 17 log_lik -21221.3                                                        
#> iter 18 log_lik -21220.4                                                        
#> iter 19 log_lik -21219.6                                                        
#> iter 20 log_lik -21219.1                                                        
#> iter 21 log_lik -21218.6                                                        
#> iter 22 log_lik -21218.3                                                        
#> iter 23 log_lik -21218                                                          
#> iter 24 log_lik -21217.8                                                        
#> iter 25 log_lik -21217.6                                                        
#> iter 26 log_lik -21217.4                                                        
#> iter 27 log_lik -21217.3                                                        
#> iter 28 log_lik -21217.2                                                        
#> iter 29 log_lik -21217.2                                                        
#> iter 30 log_lik -21217.1                                                        
#> iter 31 log_lik -21217                                                          
#> iter 32 log_lik -21217                                                          
#> iter 33 log_lik -21217                                                          
#> iter 34 log_lik -21216.9                                                        
#> iter 35 log_lik -21216.9                                                        
#> iter 36 log_lik -21216.9                                                        
#> iter 37 log_lik -21216.9                                                        
#> iter 38 log_lik -21216.9                                                        
#> iter 39 log_lik -21216.8                                                        
#> iter 40 log_lik -21216.8                                                        
#> iter 41 log_lik -21216.8                                                        
#> iter 42 log_lik -21216.8                                                        
#> iter 43 log_lik -21216.8                                                        
#> iter 44 log_lik -21216.8                                                        
#> iter 45 log_lik -21216.8                                                        
#> iter 46 log_lik -21216.8                                                        
#> iter 47 log_lik -21216.8                                                        
#> iter 48 log_lik -21216.8                                                        
#> iter 49 log_lik -21216.8                                                        
#> iter 50 log_lik -21216.8                                                        
#> iter 51 log_lik -21216.8                                                        
#> iter 52 log_lik -21216.8                                                        
#> iter 53 log_lik -21216.8                                                        
#> iter 54 log_lik -21216.8                                                        
#> iter 55 log_lik -21216.8                                                        
#> iter 56 log_lik -21216.8                                                        
#> iter 57 log_lik -21216.8                                                        
#> iter 58 log_lik -21216.8                                                        
#> iter 59 log_lik -21216.8                                                        
#> iter 60 log_lik -21216.8                                                        
#> iter 61 log_lik -21216.8                                                        
#> iter 62 log_lik -21216.8                                                        
#> iter 63 log_lik -21216.8                                                        
#> iter 64 log_lik -21216.8                                                        
#> Weakly ordinal alignment condition was satisfied.
plot_mean <- plotFRP_gg(result_ord, stat = "mean")

# Using mode for polytomous data
plot_mode <- plotFRP_gg(result_ord, stat = "mode",
                        title = "Field Reference Profile (Mode)",
                        colors = c("red", "blue", "green"))
```
