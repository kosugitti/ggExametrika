# Plot Latnt Rank Distribution (LRD) from Exametrika

This function takes Exametrika output as input and generates Latnt Rank
Distribution (LRD) using ggplot2. The applicable analytical methods are
Latent Rank Analysis (LRA), Biclustering, Local Dependent Latent Rank
Analysis (LDLRA), and Local Dependence Biclustering (LDB).

## Usage

``` r
plotLRD_gg(data, Num_Students = TRUE, title = TRUE)
```

## Arguments

- data:

  Exametrika output results

- Num_Students:

  Display the number of students on the bar graph

- title:

  Toggle the presence of the title using TRUE/FALSE
