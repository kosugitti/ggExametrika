# Plot Array from Exametrika

This function takes Exametrika output as input and generates Rank
Membership Profile (RMP) using ggplot2. The applicable analytical
methods are Latent Rank Analysis (LRA), Biclustering, Local Dependent
Latent Rank Analysis (LDLRA), and Local Dependence Biclustering (LDB).

## Usage

``` r
plotArray_gg(
  data,
  Original = TRUE,
  Clusterd = TRUE,
  Clusterd_lines = TRUE,
  title = TRUE
)
```

## Arguments

- data:

  Exametrika output results

- Original:

  plot original data

- Clusterd:

  plot Clusterd data

- Clusterd_lines:

  plot the red lines representing ranks and fields

- title:

  Presence or absence of a title.
