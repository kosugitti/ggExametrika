# ggExametrika 0.0.28

## Test Infrastructure Setup

Comprehensive testthat test suite for all 26 exported plot functions.

* Create `helper-setup.R` with shared test fixtures (IRT 2PL/3PL, GRM, LCA, LRA, Biclustering binary/ordinal/nominal, LRAordinal, LRArated, BNM). Fixtures computed once and shared across all test files.
* Add 10 new test files covering all plot function families:
  - `test-IRT-plots.R`: plotICC_gg, plotTRF_gg, plotICC_overlay_gg
  - `test-IIC-TIC-plots.R`: plotIIC_gg, plotTIC_gg, plotIIC_overlay_gg (IRT + GRM)
  - `test-GRM-plots.R`: plotICRF_gg
  - `test-LCA-LRA-plots.R`: plotIRP_gg, plotTRP_gg, plotLCD_gg, plotLRD_gg, plotCMP_gg, plotRMP_gg
  - `test-Biclustering-plots.R`: plotFRP_gg, plotCRV_gg, plotRRV_gg (binary + polytomous)
  - `test-PolyBiclustering-plots.R`: plotFCRP_gg, plotFCBR_gg, plotScoreField_gg
  - `test-LRAordinal-plots.R`: plotScoreFreq_gg, plotScoreRank_gg, plotICRP_gg, plotICBR_gg
  - `test-DAG-plots.R`: plotGraph_gg (BNM)
  - `test-utility.R`: combinePlots_gg
  - `test-validation.R`: Cross-cutting input validation for all 24+ plot functions
* Add input validation tests for all functions: NULL, data.frame, numeric, character, list inputs and wrong model type cross-checks.
* Add common options tests for all functions: title (TRUE/FALSE/custom), colors, linetype, show_legend, legend_position.
* Remove empty legacy test files (test_ICCtoTIC.R, test_IRPtoCMPRMP.R, test_option.R) and Rplots.pdf artifact.
* Total: 433 PASS, 0 FAIL, 22 WARN (ggplot2 deprecation only), 4 SKIP (BNM fixture unavailable).

# ggExametrika 0.0.27

## Common Options Unification

Add common plot options (title, colors, linetype, show_legend, legend_position) to 11 functions for API consistency.

### Fully new common options (6 functions)
* Add common options to `plotICC_gg()`: title (logical/character), colors, linetype, show_legend, legend_position. Also add `items` parameter for selecting which items to plot.
* Add common options to `plotTRF_gg()`: title (logical/character), colors, linetype, show_legend, legend_position.
* Add common options to `plotIRP_gg()`: title (logical/character), colors, linetype (default: "dashed"), show_legend, legend_position.
* Add common options to `plotCMP_gg()`: title (logical/character), colors, linetype (default: "dashed"), show_legend, legend_position.
* Add common options to `plotRMP_gg()`: title (logical/character), colors, linetype (default: "dashed"), show_legend, legend_position.
* Add common options to `plotFieldPIRP_gg()`: title (logical/character), colors (per-field), linetype, show_legend, legend_position.

### Supplemented missing options (4 functions)
* Rename `color` to `colors` in `plotTIC_gg()` for API consistency. Add `show_legend` and `legend_position` parameters.
* Add `colors`, `linetype`, `show_legend`, `legend_position` to `plotTRP_gg()`. Extend `title` to support character strings. colors[1]=bar fill, colors[2]=line/point color.
* Add `colors`, `linetype`, `show_legend`, `legend_position` to `plotLCD_gg()`. Extend `title` to support character strings. colors[1]=bar fill, colors[2]=line/point color.
* Add `colors`, `linetype`, `show_legend`, `legend_position` to `plotLRD_gg()`. Extend `title` to support character strings. colors[1]=bar fill, colors[2]=line/point color.

### DAG visualization (1 function)
* Add `title` (logical/character), `colors` (node fill), `show_legend`, `legend_position` to `plotGraph_gg()`. Note: `linetype` is not applicable to DAG edge arrows.

# ggExametrika 0.0.26

* Fix `plotCMP_gg()` and `plotRMP_gg()` to access Students columns by name (`Membership *`) instead of index position. Prevents column-shift bugs when exametrika adds columns (e.g., `Estimate`).
* Fix `plotCMP_gg()` and `plotRMP_gg()` `$Nclass` reference to fallback chain: `n_class` -> `Nclass` -> `n_rank` -> `Nrank`. Now accepts LRA/Biclustering objects without errors.
* Migrate `$Nclass`/`$Nfield` references in `plotArray_gg()` and `plotFieldPIRP_gg()` to new naming convention (`n_class`/`n_field`/`n_rank`) with fallback to deprecated names (`Nclass`/`Nfield`/`Nrank`).
* Add internal utility `.first_non_null()` for safe fallback chains across naming conventions.
* Fix `plotTRP_gg()`, `plotLCD_gg()`, `plotLRD_gg()` to use LCD/LRD fallback chains. LRA and LDLRA models (which have `$LRD` but not `$LCD`) now work correctly with all three functions.
* Add LDLRA support to `plotTRP_gg()` (previously missing from valid model types).
* Fix `plotArray_gg()` single-panel return value: when only `Original = FALSE` or `Clusterd = FALSE`, the function now correctly returns a list with the single plot at index 1 (previously stored at index 2 when only Clusterd was TRUE, causing `plot[[1]]` to be NULL).
* Full backward compatibility maintained with older exametrika versions.

# ggExametrika 0.0.25

* Fix class validation in `plotLCD_gg()`, `plotLRD_gg()`, `plotCMP_gg()`, and `plotRMP_gg()` to support polytomous biclustering models.
* Add support for `ordinalBiclustering` and `nominalBiclustering` classes in LCD, LRD, CMP, and RMP plots.
* Change class validation from `all(class(data) %in% c(...))` to `any(class(data) %in% c(...))` for better compatibility.
* Add `inherits(data, "exametrika")` check for more robust input validation.
* Full backward compatibility maintained for binary Biclustering, LCA, LRA, LDLRA, LDB, and BINET models.

# ggExametrika 0.0.24

* Add multi-valued (polytomous) data support to `plotRRV_gg()` and `plotCRV_gg()` for ordinal/nominal Biclustering.
* Add `stat` parameter to `plotRRV_gg()` and `plotCRV_gg()` for polytomous data: "mean" (default), "median", or "mode".
* Add `show_labels` parameter to `plotRRV_gg()` and `plotCRV_gg()` (default: FALSE) for displaying rank/class labels using ggrepel.
* Add ggrepel to Imports for automatic label positioning without overlaps.
* Y-axis automatically adjusts: 0-1 for binary data (Correct Response Rate), 1-maxQ for polytomous data (Expected Score).
* Title automatically includes stat name for polytomous data (e.g., "Rank Reference Vector (mean)").
* Full backward compatibility maintained for binary Biclustering models.

# ggExametrika 0.0.23

* Add `plotFCRP_gg()` for Field Category Response Profile (FCRP) visualization (exametrika v1.9.0 feature).
* FCRP displays category response probability profiles for each field across latent classes/ranks in polytomous biclustering models (ordinalBiclustering, nominalBiclustering).
* Support two visualization styles: "line" (default, line plot with points) and "bar" (stacked bar chart).
* For bar style, add category boundary transition lines (dashed lines connecting adjacent bars).
* Support common plot options (title, colors, linetype, show_legend, legend_position).
* Requires 3+ response categories (use plotFRP_gg for binary data).
* Completes exametrika v1.9.0 polytomous biclustering feature set (FCBR, ScoreField, FCRP all implemented).

# ggExametrika 0.0.22

* Add multi-valued data support to `plotFRP_gg()` (Field Reference Profile).
* Add `stat` parameter for polytomous data: "mean" (weighted average), "median", "mode".
* Support ordinalBiclustering and nominalBiclustering in addition to binary Biclustering/IRM/LDB/BINET.
* Change return value from list to single ggplot object showing all fields.
* Add common plot options (title, colors, linetype, show_legend, legend_position) to `plotFRP_gg()`.
* For binary data: displays correct response rate (0-1).
* For polytomous data: displays expected score calculated using selected `stat` method.
* Add comprehensive test suite (develop/test_FRP_multivalue.R) covering binary/ordinal/nominal data.

# ggExametrika 0.0.21

* Add `plotScoreField_gg()` for Score-Field heatmap visualization (exametrika v1.9.0 feature).
* `plotScoreField_gg()` displays expected scores for each field across latent classes/ranks in polytomous biclustering models (nominalBiclustering, ordinalBiclustering).
* Expected score calculation: sum of (category × probability) for each field-class/rank combination.
* Support common plot options (title, colors, show_legend, legend_position).
* Add `show_values` parameter to toggle display of score values on heatmap cells.
* Add `text_size` parameter to control size of value labels.
* Uses colorblind-friendly yellow-orange-red gradient by default.

# ggExametrika 0.0.20

* Add `plotFCBR_gg()` for Field Cumulative Boundary Reference (FCBR) visualization (ordinalBiclustering).
* FCBR shows cumulative probability curves for each category boundary across latent classes/ranks.
* Support common plot options (title, colors, linetype, show_legend, legend_position) in `plotFCBR_gg()`.
* FCBR displays ALL boundary probabilities including P(Q>=1) (always 1.0), P(Q>=2), P(Q>=3), etc.
* P(Q>=1) appears as a horizontal line at the top (y=1.0) for reference.

# ggExametrika 0.0.19

* Add `plotScoreRank_gg()` for Score-Rank heatmap visualization (LRAordinal, LRArated).
* Support common plot options (title, colors, show_legend, legend_position) in `plotScoreRank_gg()`.

# ggExametrika 0.0.18

* Add `plotICBR_gg()` for Item Category Boundary Response (ICBR) visualization (LRAordinal).
* Add `plotICRP_gg()` for Item Category Reference Profile (ICRP) visualization (LRAordinal, LRArated).
* Both functions support common plot options (title, colors, linetype, show_legend, legend_position).
* ICBR shows cumulative probability curves for each category boundary across latent ranks.
* ICRP shows response probability curves for each category across latent ranks (probabilities sum to 1.0).
* Add tidyr to Imports for data transformation in plotICBR_gg() and plotICRP_gg().

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
