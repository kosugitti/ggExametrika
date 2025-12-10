# Plot Latnt Class Distribution (LCD) from Exametrika

This function takes Exametrika output as input and generates Latnt Class
Distribution (LCD) using ggplot2. The applicable analytical methods are
Latent Class Analysis (LCA) and Bicluster Network Model (BINET).

## Usage

``` r
plotLCD_gg(data, Num_Students = TRUE, title = TRUE)
```

## Arguments

- data:

  Exametrika output results

- Num_Students:

  Display the number of students on the bar graph

- title:

  Toggle the presence of the title using TRUE/FALSE
