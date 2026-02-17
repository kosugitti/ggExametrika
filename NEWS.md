# ggExametrika 0.0.17

* Add `plotIIC_overlay_gg()` for overlaying all Item Information Curves (IIC) on a single plot (IRT/GRM).
* `plotIIC_overlay_gg()` supports both IRT and GRM models.
* `plotIIC_overlay_gg()` supports common plot options (title, colors, linetype, show_legend, legend_position).
* Similar to `plot(IRT_result, type = "IIF", overlay = TRUE)` in exametrika, but returns a ggplot2 object.

# ggExametrika 0.0.16

* Add `plotICC_overlay_gg()` for overlaying all Item Characteristic Curves (ICC) on a single plot (IRT).
* `plotICC_overlay_gg()` supports common plot options (title, colors, linetype, show_legend, legend_position).
* Similar to `plot(IRT_result, type = "IRF", overlay = TRUE)` in exametrika, but returns a ggplot2 object.

# ggExametrika 0.0.15

* Add `plotScoreFreq_gg()` for Score Frequency Distribution (LRAordinal, LRArated).
* Common plot options (title, colors, linetype, show_legend, legend_position) supported.

# ggExametrika 0.0.14

* Add multi-valued data support to `plotArray_gg()` for ordinal/nominal Biclustering.
* Add common plot options (title, colors, show_legend, legend_position) to `plotArray_gg()`.
* Add `Clusterd_lines_color` parameter to `plotArray_gg()` for customizing boundary line colors (default: red for binary data, white for multi-valued data).
* `plotArray_gg()` now automatically detects the number of categories and uses appropriate color palettes.
* For binary data (0/1), uses white/black colors. For multi-valued data (2+ categories), uses a colorblind-friendly palette.
* Add special handling for missing values (-1): displayed as "NA" in legend with black color.
* Fix plot margins and title spacing to prevent overlapping in side-by-side displays.
* Fix boundary lines to stay within plot area using proper coordinate limits.
* Fix boundary line positions in `plotArray_gg()` to align exactly with class/field boundaries.
* **CRITICAL FIX**: Correct row sorting order in `plotArray_gg()` to match exametrika's original implementation. Now uses `order(ClassEstimated, decreasing = FALSE)` with reversed rown for proper visual alignment (higher class numbers at bottom).

# ggExametrika 0.0.13

* Add GRM support to `plotIIC_gg()` for Item Information Curve (IRT and GRM).
* Add GRM support to `plotTIC_gg()` for Test Information Curve (IRT and GRM).
* Add `ItemInformationFunc_GRM()` for computing GRM item information.
* Add common plot options (title, colors, linetype, show_legend, legend_position) to `plotIIC_gg()` and `plotTIC_gg()`.

# ggExametrika 0.0.12

* Add `plotCRV_gg()` for Class Reference Vector (CRV) visualization (Biclustering).
* Add `plotRRV_gg()` for Rank Reference Vector (RRV) visualization (Biclustering).
* Both functions support common plot options (title, colors, linetype, show_legend, legend_position).

# ggExametrika 0.0.11

* Add `plotICRF_gg()` for Item Category Response Function (GRM) visualization.
* Add `.gg_exametrika_palette()` as package-wide default color palette (ColorBrewer Dark2).
* Add common plot options (title, colors, linetype, show_legend, legend_position) to `plotICRF_gg()`.
* Fix y-axis on all probability plots to always display 0.00 and 1.00 with breaks at 0.25 intervals.

# ggExametrika 0.0.10

* Add `plotTRF_gg()` for Test Response Function (TRF) visualization in IRT models.

# ggExametrika 0.0.9

* Add `plotGraph_gg()` for DAG visualization using ggraph.
* Expand help documentation for all functions.
* Apply `styler::style_pkg()` for consistent code formatting.
* Fix compatibility with current exametrika package.
* Add pkgdown site and GitHub Actions workflow.

# ggExametrika 0.0.8

* Add `plotArray_gg()` for array plot (Biclustering, IRM, LDB, BINET).
* Add `plotFieldPIRP_gg()` for Field PIRP plot (LDB).

# ggExametrika 0.0.7

* Add `plotTRP_gg()` for Test Reference Profile (LCA, LRA, Biclustering, IRM, LDLRA, LDB, BINET).
* Add `plotLCD_gg()` for Latent Class Distribution (LCA, Biclustering).
* Add `plotLRD_gg()` for Latent Rank Distribution (LRA, Biclustering, LDLRA, LDB, BINET).
* Add `plotCMP_gg()` for Class Membership Profile (LCA, Biclustering, BINET).
* Add `plotRMP_gg()` for Rank Membership Profile (LRA, Biclustering, LDLRA, LDB, BINET, LRAordinal, LRArated).

# ggExametrika 0.0.6

* Add `plotIRP_gg()` for Item Reference Profile (LCA, LRA, LDLRA).
* Add `plotFRP_gg()` for Field Reference Profile (LCA, LRA, Biclustering, IRM, LDB, BINET).

# ggExametrika 0.0.5

* Add `plotICC_gg()` for Item Characteristic Curve (IRT: 2PL, 3PL, 4PL).
* Add `plotIIC_gg()` for Item Information Curve (IRT: 2PL, 3PL, 4PL).
* Add `plotTIC_gg()` for Test Information Curve (IRT: 2PL, 3PL, 4PL).
* Add `LogisticModel()` for four-parameter logistic model computation.
* Add `ItemInformationFunc()` for item information function computation.
* Add `combinePlots_gg()` utility for arranging multiple plots in a grid.

# ggExametrika 0.0.1

* Initial package setup.
