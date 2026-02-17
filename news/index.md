# Changelog

## ggExametrika 0.0.13

- Add GRM support to
  [`plotIIC_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotIIC_gg.md)
  for Item Information Curve (IRT and GRM).
- Add GRM support to
  [`plotTIC_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotTIC_gg.md)
  for Test Information Curve (IRT and GRM).
- Add
  [`ItemInformationFunc_GRM()`](https://kosugitti.github.io/ggExametrika/reference/ItemInformationFunc_GRM.md)
  for computing GRM item information.
- Add common plot options (title, colors, linetype, show_legend,
  legend_position) to
  [`plotIIC_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotIIC_gg.md)
  and
  [`plotTIC_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotTIC_gg.md).

## ggExametrika 0.0.12

- Add
  [`plotCRV_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotCRV_gg.md)
  for Class Reference Vector (CRV) visualization (Biclustering).
- Add
  [`plotRRV_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotRRV_gg.md)
  for Rank Reference Vector (RRV) visualization (Biclustering).
- Both functions support common plot options (title, colors, linetype,
  show_legend, legend_position).

## ggExametrika 0.0.11

- Add
  [`plotICRF_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotICRF_gg.md)
  for Item Category Response Function (GRM) visualization.
- Add
  [`.gg_exametrika_palette()`](https://kosugitti.github.io/ggExametrika/reference/dot-gg_exametrika_palette.md)
  as package-wide default color palette (ColorBrewer Dark2).
- Add common plot options (title, colors, linetype, show_legend,
  legend_position) to
  [`plotICRF_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotICRF_gg.md).
- Fix y-axis on all probability plots to always display 0.00 and 1.00
  with breaks at 0.25 intervals.

## ggExametrika 0.0.10

- Add
  [`plotTRF_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotTRF_gg.md)
  for Test Response Function (TRF) visualization in IRT models.

## ggExametrika 0.0.9

- Add
  [`plotGraph_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotGraph_gg.md)
  for DAG visualization using ggraph.
- Expand help documentation for all functions.
- Apply `styler::style_pkg()` for consistent code formatting.
- Fix compatibility with current exametrika package.
- Add pkgdown site and GitHub Actions workflow.

## ggExametrika 0.0.8

- Add
  [`plotArray_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotArray_gg.md)
  for array plot (Biclustering, IRM, LDB, BINET).
- Add
  [`plotFieldPIRP_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotFieldPIRP_gg.md)
  for Field PIRP plot (LDB).

## ggExametrika 0.0.7

- Add
  [`plotTRP_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotTRP_gg.md)
  for Test Reference Profile (LCA, LRA, Biclustering, IRM, LDLRA, LDB,
  BINET).
- Add
  [`plotLCD_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotLCD_gg.md)
  for Latent Class Distribution (LCA, Biclustering).
- Add
  [`plotLRD_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotLRD_gg.md)
  for Latent Rank Distribution (LRA, Biclustering, LDLRA, LDB, BINET).
- Add
  [`plotCMP_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotCMP_gg.md)
  for Class Membership Profile (LCA, Biclustering, BINET).
- Add
  [`plotRMP_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotRMP_gg.md)
  for Rank Membership Profile (LRA, Biclustering, LDLRA, LDB, BINET,
  LRAordinal, LRArated).

## ggExametrika 0.0.6

- Add
  [`plotIRP_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotIRP_gg.md)
  for Item Reference Profile (LCA, LRA, LDLRA).
- Add
  [`plotFRP_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotFRP_gg.md)
  for Field Reference Profile (LCA, LRA, Biclustering, IRM, LDB, BINET).

## ggExametrika 0.0.5

- Add
  [`plotICC_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotICC_gg.md)
  for Item Characteristic Curve (IRT: 2PL, 3PL, 4PL).
- Add
  [`plotIIC_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotIIC_gg.md)
  for Item Information Curve (IRT: 2PL, 3PL, 4PL).
- Add
  [`plotTIC_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotTIC_gg.md)
  for Test Information Curve (IRT: 2PL, 3PL, 4PL).
- Add
  [`LogisticModel()`](https://kosugitti.github.io/ggExametrika/reference/LogisticModel.md)
  for four-parameter logistic model computation.
- Add
  [`ItemInformationFunc()`](https://kosugitti.github.io/ggExametrika/reference/ItemInformationFunc.md)
  for item information function computation.
- Add
  [`combinePlots_gg()`](https://kosugitti.github.io/ggExametrika/reference/combinePlots_gg.md)
  utility for arranging multiple plots in a grid.

## ggExametrika 0.0.1

- Initial package setup.
