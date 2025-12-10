# Plot Test Reference Profile (TRP) from Exametrika

This function takes Exametrika output as input and generates Test
Reference Profile (TRP) using ggplot2. The applicable analytical methods
are Latent Class Analysis (LCA), Latent Rank Analysis (LRA),
Biclustering, Infinite Relational Model (IRM), Local Dependence
Biclustering (LDB), and Bicluster Network Model (BINET).

## Usage

``` r
plotTRP_gg(data, Num_Students = TRUE, title = TRUE)
```

## Arguments

- data:

  Exametrika output results

- Num_Students:

  Display the number of students on the bar graph

- title:

  Toggle the presence of the title using TRUE/FALSE
