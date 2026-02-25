# Changelog

## ggExametrika 0.0.33

### R CMD check Fixes

- Add `LICENSE` file (YEAR/COPYRIGHT HOLDER format) for CRAN compliance.
  `DESCRIPTION` specifies `License: MIT + file LICENSE`, which requires
  a `LICENSE` file (not just `LICENSE.md`).
- Wrap `J35S500` examples in `\dontrun{}` to avoid R CMD check failures
  when exametrika \< 1.9.0 is installed. `J35S500` dataset is only
  available in exametrika \>= 1.9.0 (not yet on CRAN). Affected
  functions:
  [`plotFCBR_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotFCBR_gg.md),
  [`plotFCRP_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotFCRP_gg.md),
  [`plotScoreField_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotScoreField_gg.md),
  [`plotFRP_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotFRP_gg.md),
  [`plotCRV_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotCRV_gg.md),
  [`plotRRV_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotRRV_gg.md).
  TODO: revert after exametrika v1.9.0 is released on CRAN.
- Remove `LazyData: true` from DESCRIPTION (package has no data
  directory).
- Remove `VignetteBuilder: knitr` and `knitr`/`rmarkdown` from Suggests
  (no vignettes after migration to pkgdown articles).
- Comprehensive NSE (Non-Standard Evaluation) global variable
  declarations in `R/zzz.R` via
  [`utils::globalVariables()`](https://rdrr.io/r/utils/globalVariables.html).
  Covers all ggplot2
  [`aes()`](https://ggplot2.tidyverse.org/reference/aes.html) and tidyr
  NSE variables across all plot functions (30+ variables). Previously
  only `value` was declared.
- Add `@importFrom` for missing function imports:
  [`stats::ave`](https://rdrr.io/r/stats/ave.html),
  [`stats::median`](https://rdrr.io/r/stats/median.html),
  [`stats::setNames`](https://rdrr.io/r/stats/setNames.html),
  [`utils::tail`](https://rdrr.io/r/utils/head.html),
  [`ggplot2::geom_segment`](https://ggplot2.tidyverse.org/reference/geom_segment.html),
  [`ggplot2::sec_axis`](https://ggplot2.tidyverse.org/reference/sec_axis.html),
  [`ggplot2::scale_fill_gradientn`](https://ggplot2.tidyverse.org/reference/scale_gradient.html),
  [`ggplot2::scale_x_reverse`](https://ggplot2.tidyverse.org/reference/scale_continuous.html),
  [`tidyr::all_of`](https://tidyselect.r-lib.org/reference/all_of.html).
  Resolves all “no visible global function definition” NOTEs.
- Add `github::kosugitti/exametrika` to `R-CMD-check.yaml` and
  `test-coverage.yaml` extra-packages. CRAN version (v1.8.1) lacks
  v1.9.0 datasets; examples with `@examplesIf` + `\dontrun{}` do not
  correctly suppress execution due to `withAutoprint` interaction.

### CI / Infrastructure Fixes

- Fix `_pkgdown.yml`: use `'"articles/name"'` syntax for article
  references in contents. pkgdown evaluates contents entries as R
  expressions, so bare `plot-gallery` was parsed as `plot - gallery`
  (subtraction). Additionally, pkgdown prefixes article names with
  `articles/` for files in `vignettes/articles/`.
- Move `getting-started.Rmd` and `getting-started-ja.Rmd` from
  `vignettes/` to `vignettes/articles/` as pkgdown-only articles. Remove
  vignette YAML metadata (`\VignetteIndexEntry`, `\VignetteEngine`,
  `\VignetteEncoding`) and `output: rmarkdown::html_vignette`. This
  resolves R CMD check vignette build errors caused by exametrika
  dependency during check.
- Add `^vignettes/articles$` to `.Rbuildignore` to exclude pkgdown-only
  articles from package build.
- Update `test-coverage.yaml`: upgrade `codecov/codecov-action` from v4
  to v5, add `print(cov)` for log output, add testthat output display
  and failure artifact upload steps, update parameter names for v5
  compatibility (`file` to `files`, `plugin` to `plugins`). Set
  `fail_ci_if_error: false` for codecov upload to avoid CI failure when
  `CODECOV_TOKEN` is not configured.
- Update `pkgdown.yaml`: install exametrika from GitHub
  (`github::kosugitti/exametrika`) to ensure v1.9.0 datasets (e.g.,
  `J35S500`) are available for article rendering.

### GitHub Pages / pkgdown (Phase 3)

- Add Plot Gallery article (`vignettes/articles/plot-gallery.Rmd`) as a
  pkgdown-only article showcasing all 27 visualization functions with
  live rendered examples. The gallery is organized into 7 sections: IRT
  Models, GRM, Latent Class/Rank Analysis, Biclustering
  (binary/ordinal/nominal), LRAordinal/LRArated, Network Models (DAG),
  and Common Options Demo.
- Uses six sample datasets (J15S500, J5S1000, J35S515, J35S500, J20S600,
  J15S3810) covering binary, ordinal, and nominal response types, and 8
  model types (IRT, GRM, LCA, LRA, LRAordinal, Biclustering, ordinal
  Biclustering, nominal Biclustering). Network models (BNM, LDLRA, LDB,
  BINET) are shown as reference code only (eval=FALSE) since they
  require explicit graph structure input.
- Add Plot Gallery to `_pkgdown.yml` navbar menu (displayed at the top
  of the Articles dropdown) and articles section.

### Vignette Bug Fixes

- Remove incorrect `plotFRP_gg(result_lca)` and `plotFRP_gg(result_lra)`
  calls from both English and Japanese getting-started vignettes.
  [`plotFRP_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotFRP_gg.md)
  requires Biclustering-family models; LCA/LRA do not produce FRP output
  (exametrika valid_types declaration is incorrect).
- Replace non-existent `OrdinalData` dataset with `J35S500` in ordinal
  Biclustering example.
- Fix `color =` to `colors =` in
  [`plotTIC_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotTIC_gg.md)
  customization example (parameter name mismatch).
- Fix `rankdir =` to `direction =` and remove non-existent
  `node_color`/`edge_color` parameters from
  [`plotGraph_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotGraph_gg.md)
  customization example.
- Set LDLRA, LDB, and BINET
  [`plotGraph_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotGraph_gg.md)
  examples to `eval = FALSE` with “coming soon” notes, as DAG
  visualization currently supports BNM only.
- Fix
  [`plotFRP_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotFRP_gg.md)
  usage in vignettes: the function returns a single ggplot object, not a
  list. Removed incorrect `[[1]]` indexing and
  [`combinePlots_gg()`](https://kosugitti.github.io/ggExametrika/reference/combinePlots_gg.md)
  calls.
- Set BNM, LDLRA, LDB, and BINET model fitting and all dependent plot
  chunks to `eval = FALSE` in both vignettes. BNM requires explicit
  graph input; LDLRA/LDB/BINET are computationally expensive and have
  unresolved API issues with current exametrika version.
- Set `devtools::install_github()` chunks to `eval = FALSE` in both
  vignettes. devtools is not available during R CMD check.
- Replace non-existent `OrdinalData` dataset with `J35S500` in
  [`plotFCBR_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotFCBR_gg.md)
  and
  [`plotFRP_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotFRP_gg.md)
  roxygen examples.
- Fix
  [`plotFCBR_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotFCBR_gg.md)
  example: `fields = 1:6` exceeded `nfld = 5`, and `colors` had 4 values
  for 5-category data. Changed to `fields = 1:5` and added 5th color.
- Add missing
  [`library(exametrika)`](https://kosugitti.github.io/exametrika/) to
  [`plotFCRP_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotFCRP_gg.md)
  and
  [`plotScoreField_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotScoreField_gg.md)
  roxygen examples.
- Change
  [`plotFieldPIRP_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotFieldPIRP_gg.md)
  and
  [`plotLDPSR_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotLDPSR_gg.md)
  examples from `@examplesIf` to `@examples` with `\dontrun{}`. LDB and
  BINET require explicit graph structure input that cannot be created in
  simple examples.

### GitHub Pages / pkgdown (Phase 2)

- Change vignettes (getting-started.Rmd, getting-started-ja.Rmd) from
  `eval = FALSE` to
  `eval = requireNamespace("exametrika", quietly = TRUE)`. Vignette code
  chunks now execute automatically when exametrika is installed,
  producing live output on pkgdown site, while still being skipped
  gracefully when unavailable.
- Add `nomBiclust` (nominalBiclustering) column to Function-Model
  Compatibility Matrix in both English and Japanese vignettes.
- Add three new function rows to the compatibility matrix: `plotFCRP_gg`
  (v1.9.0), `plotScoreField_gg` (v1.9.0), `plotLDPSR_gg` (v0.0.32).
- Fix missing `ordBiclust` marks in the compatibility matrix for
  `plotFRP_gg`, `plotLRD_gg`, `plotCRV_gg`, and `plotRRV_gg`. These
  functions natively accept ordinalBiclustering in their validation code
  but were not marked in the matrix.
- Fix missing `LDLRA` mark for `plotTRP_gg` in the compatibility matrix.
  The function accepts LDLRA in its validation code but was not marked.

### GitHub Pages / pkgdown (Phase 1)

- Migrate `@examples` + `\dontrun{}` to
  `@examplesIf requireNamespace("exametrika", quietly = TRUE)` for all
  28 plot functions. Examples now run automatically when exametrika is
  installed (improving pkgdown reference pages with live output) while
  still being skipped gracefully when exametrika is unavailable.
- Three pure utility functions (LogisticModel, ItemInformationFunc,
  ItemInformationFunc_GRM) retain `@examples` since they have no
  exametrika dependency.
- Add `plotLDPSR_gg` to `_pkgdown.yml` reference section under “DAG &
  Network Model Plots”.
- Rename “DAG Visualization” section to “DAG & Network Model Plots” in
  `_pkgdown.yml` to better reflect the inclusion of BINET-specific
  profile plots.
- Add `figures` section to `_pkgdown.yml` with explicit dimensions
  (fig.width=7, fig.height=5, dpi=96, fig.retina=2) for consistent
  example plot rendering on GitHub Pages.

## ggExametrika 0.0.32

### New Features

- Add
  [`plotLDPSR_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotLDPSR_gg.md)
  for Local Dependence Passing Student Rate (LDPSR) visualization (BINET
  only). LDPSR shows item-level correct response rate profiles comparing
  parent and child classes at each DAG edge, visualizing how students
  improve when transitioning between latent classes via a specific
  field.
- [`plotLDPSR_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotLDPSR_gg.md)
  supports common plot options (title, colors, linetype, show_legend,
  legend_position).
- Returns a list of ggplot objects (one per DAG edge), compatible with
  [`combinePlots_gg()`](https://kosugitti.github.io/ggExametrika/reference/combinePlots_gg.md).

### Test Infrastructure

- Add BINET test fixture to `helper-setup.R` using J35S515 with 3
  classes, 5 fields, and a simple chain DAG structure.
- Add `test-LDPSR-plots.R` with comprehensive tests: basic
  functionality, common options, input validation, model type rejection,
  and combinePlots_gg integration.
- Add `plotLDPSR_gg` validation entry to `test-validation.R`.

## ggExametrika 0.0.31

### Bug Fixes

- Fix legend control in
  [`plotICBR_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotICBR_gg.md),
  [`plotICRP_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotICRP_gg.md),
  [`plotFCRP_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotFCRP_gg.md),
  and
  [`plotFRP_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotFRP_gg.md):
  `legend.position` was unconditionally applied in the initial
  [`theme()`](https://ggplot2.tidyverse.org/reference/theme.html) call,
  then `show_legend = FALSE` attempted to override it in a separate
  [`theme()`](https://ggplot2.tidyverse.org/reference/theme.html) layer.
  Replaced with a single conditional block for consistent behavior.

### CRAN Compliance

- Convert all Japanese comments in R source files to English (9 files,
  ~100 comments). Non-ASCII characters in source code cause encoding
  warnings in R CMD check –as-cran.
- Translate Japanese text in NEWS.md v0.0.29 entry to English.

## ggExametrika 0.0.30

### Bug Fixes

- Fix
  [`plotRMP_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotRMP_gg.md)
  to support LRAordinal and LRArated model types. Previously these
  models were rejected with “Invalid input” error despite having valid
  Students/Membership data.
- Add polytomous (multi-valued) data support to
  [`plotCRV_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotCRV_gg.md)
  with `stat` parameter (“mean”, “median”, “mode”), matching the
  existing
  [`plotRRV_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotRRV_gg.md)
  functionality. For binary data, backward compatibility is fully
  maintained.
- Add `show_labels` parameter to
  [`plotCRV_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotCRV_gg.md)
  for displaying class labels using ggrepel.
- For polytomous CRV, Y-axis automatically adjusts to “Expected Score
  (stat)” with range 1-maxQ. Title includes stat name.

### CI / Test Infrastructure

- Add GitHub Actions workflow `R-CMD-check.yaml` for multi-platform R
  CMD check (macOS, Windows, Ubuntu with R release/devel/oldrel-1).
- Add GitHub Actions workflow `test-coverage.yaml` for covr test
  coverage with optional Codecov upload.
- Fix BNM test fixture in `helper-setup.R`: BNM requires a DAG graph
  argument (`g`). Added igraph DAG creation for J5S10 dataset. This
  resolves 4 previously skipped DAG tests.
- Add tests for
  [`plotRMP_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotRMP_gg.md)
  with LRAordinal/LRArated models.
- Update
  [`plotCRV_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotCRV_gg.md)
  tests: replace error-expectation test with polytomous support tests
  (stat, show_labels).
- Remove Dropbox conflict copy artifact from tests/testthat/.
- Test results: FAIL 0 \| WARN 22 \| SKIP 0 \| PASS 452 (previously 433
  PASS + 4 SKIP).

### Documentation

- Update CLAUDE.md: Correct FRP model support table. exametrika’s
  `plot.exametrika` `valid_types` declares FRP as valid for LCA and LRA,
  but neither
  [`LCA()`](https://kosugitti.github.io/exametrika/reference/LCA.html)
  nor
  [`LRA()`](https://kosugitti.github.io/exametrika/reference/LRA.html)
  actually produce a `$FRP` field in their output. The
  [`plotFRP_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotFRP_gg.md)
  correctly rejects these models. Added annotation (\*1) to model
  compatibility tables documenting this exametrika-side inconsistency.

## ggExametrika 0.0.29

### Documentation

- Comprehensive README.md update to reflect current implementation
  status
  - Add nominalBiclustering, ordinalBiclustering, LRAordinal, LRArated
    to model list
  - Reorganize Function-Model compatibility table into 4 sections
    (IRT/GRM, LCA/LRA, Biclustering, Network) with accurate coverage for
    all functions and models
  - Add previously unlisted functions: plotICC_overlay_gg,
    plotIIC_overlay_gg, plotFCRP_gg, plotFCBR_gg, plotScoreField_gg,
    plotScoreFreq_gg, plotScoreRank_gg, plotICRP_gg, plotICBR_gg
  - Fix missing marks in compatibility table (plotFRP_gg LCA/LRA
    support, plotLCD_gg/plotCMP_gg Biclustering support, plotRMP_gg
    BINET support, etc.)
  - Add usage examples for LRAordinal/LRArated, polytomous Biclustering,
    and overlay functions
  - Add function-specific parameters (stat, style, show_labels) to
    Common Plot Options section
  - Remove broken link to non-existent Japanese guide

## ggExametrika 0.0.28

### Test Infrastructure Setup

Comprehensive testthat test suite for all 26 exported plot functions.

- Create `helper-setup.R` with shared test fixtures (IRT 2PL/3PL, GRM,
  LCA, LRA, Biclustering binary/ordinal/nominal, LRAordinal, LRArated,
  BNM). Fixtures computed once and shared across all test files.
- Add 10 new test files covering all plot function families:
  - `test-IRT-plots.R`: plotICC_gg, plotTRF_gg, plotICC_overlay_gg
  - `test-IIC-TIC-plots.R`: plotIIC_gg, plotTIC_gg, plotIIC_overlay_gg
    (IRT + GRM)
  - `test-GRM-plots.R`: plotICRF_gg
  - `test-LCA-LRA-plots.R`: plotIRP_gg, plotTRP_gg, plotLCD_gg,
    plotLRD_gg, plotCMP_gg, plotRMP_gg
  - `test-Biclustering-plots.R`: plotFRP_gg, plotCRV_gg, plotRRV_gg
    (binary + polytomous)
  - `test-PolyBiclustering-plots.R`: plotFCRP_gg, plotFCBR_gg,
    plotScoreField_gg
  - `test-LRAordinal-plots.R`: plotScoreFreq_gg, plotScoreRank_gg,
    plotICRP_gg, plotICBR_gg
  - `test-DAG-plots.R`: plotGraph_gg (BNM)
  - `test-utility.R`: combinePlots_gg
  - `test-validation.R`: Cross-cutting input validation for all 24+ plot
    functions
- Add input validation tests for all functions: NULL, data.frame,
  numeric, character, list inputs and wrong model type cross-checks.
- Add common options tests for all functions: title (TRUE/FALSE/custom),
  colors, linetype, show_legend, legend_position.
- Remove empty legacy test files (test_ICCtoTIC.R, test_IRPtoCMPRMP.R,
  test_option.R) and Rplots.pdf artifact.
- Total: 433 PASS, 0 FAIL, 22 WARN (ggplot2 deprecation only), 4 SKIP
  (BNM fixture unavailable).

## ggExametrika 0.0.27

### Common Options Unification

Add common plot options (title, colors, linetype, show_legend,
legend_position) to 11 functions for API consistency.

#### Fully new common options (6 functions)

- Add common options to
  [`plotICC_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotICC_gg.md):
  title (logical/character), colors, linetype, show_legend,
  legend_position. Also add `items` parameter for selecting which items
  to plot.
- Add common options to
  [`plotTRF_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotTRF_gg.md):
  title (logical/character), colors, linetype, show_legend,
  legend_position.
- Add common options to
  [`plotIRP_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotIRP_gg.md):
  title (logical/character), colors, linetype (default: “dashed”),
  show_legend, legend_position.
- Add common options to
  [`plotCMP_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotCMP_gg.md):
  title (logical/character), colors, linetype (default: “dashed”),
  show_legend, legend_position.
- Add common options to
  [`plotRMP_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotRMP_gg.md):
  title (logical/character), colors, linetype (default: “dashed”),
  show_legend, legend_position.
- Add common options to
  [`plotFieldPIRP_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotFieldPIRP_gg.md):
  title (logical/character), colors (per-field), linetype, show_legend,
  legend_position.

#### Supplemented missing options (4 functions)

- Rename `color` to `colors` in
  [`plotTIC_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotTIC_gg.md)
  for API consistency. Add `show_legend` and `legend_position`
  parameters.
- Add `colors`, `linetype`, `show_legend`, `legend_position` to
  [`plotTRP_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotTRP_gg.md).
  Extend `title` to support character strings. colors\[1\]=bar fill,
  colors\[2\]=line/point color.
- Add `colors`, `linetype`, `show_legend`, `legend_position` to
  [`plotLCD_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotLCD_gg.md).
  Extend `title` to support character strings. colors\[1\]=bar fill,
  colors\[2\]=line/point color.
- Add `colors`, `linetype`, `show_legend`, `legend_position` to
  [`plotLRD_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotLRD_gg.md).
  Extend `title` to support character strings. colors\[1\]=bar fill,
  colors\[2\]=line/point color.

#### DAG visualization (1 function)

- Add `title` (logical/character), `colors` (node fill), `show_legend`,
  `legend_position` to
  [`plotGraph_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotGraph_gg.md).
  Note: `linetype` is not applicable to DAG edge arrows.

## ggExametrika 0.0.26

- Fix
  [`plotCMP_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotCMP_gg.md)
  and
  [`plotRMP_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotRMP_gg.md)
  to access Students columns by name (`Membership *`) instead of index
  position. Prevents column-shift bugs when exametrika adds columns
  (e.g., `Estimate`).
- Fix
  [`plotCMP_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotCMP_gg.md)
  and
  [`plotRMP_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotRMP_gg.md)
  `$Nclass` reference to fallback chain: `n_class` -\> `Nclass` -\>
  `n_rank` -\> `Nrank`. Now accepts LRA/Biclustering objects without
  errors.
- Migrate `$Nclass`/`$Nfield` references in
  [`plotArray_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotArray_gg.md)
  and
  [`plotFieldPIRP_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotFieldPIRP_gg.md)
  to new naming convention (`n_class`/`n_field`/`n_rank`) with fallback
  to deprecated names (`Nclass`/`Nfield`/`Nrank`).
- Add internal utility
  [`.first_non_null()`](https://kosugitti.github.io/ggExametrika/reference/dot-first_non_null.md)
  for safe fallback chains across naming conventions.
- Fix
  [`plotTRP_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotTRP_gg.md),
  [`plotLCD_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotLCD_gg.md),
  [`plotLRD_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotLRD_gg.md)
  to use LCD/LRD fallback chains. LRA and LDLRA models (which have
  `$LRD` but not `$LCD`) now work correctly with all three functions.
- Add LDLRA support to
  [`plotTRP_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotTRP_gg.md)
  (previously missing from valid model types).
- Fix
  [`plotArray_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotArray_gg.md)
  single-panel return value: when only `Original = FALSE` or
  `Clusterd = FALSE`, the function now correctly returns a list with the
  single plot at index 1 (previously stored at index 2 when only
  Clusterd was TRUE, causing `plot[[1]]` to be NULL).
- Full backward compatibility maintained with older exametrika versions.

## ggExametrika 0.0.25

- Fix class validation in
  [`plotLCD_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotLCD_gg.md),
  [`plotLRD_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotLRD_gg.md),
  [`plotCMP_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotCMP_gg.md),
  and
  [`plotRMP_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotRMP_gg.md)
  to support polytomous biclustering models.
- Add support for `ordinalBiclustering` and `nominalBiclustering`
  classes in LCD, LRD, CMP, and RMP plots.
- Change class validation from `all(class(data) %in% c(...))` to
  `any(class(data) %in% c(...))` for better compatibility.
- Add `inherits(data, "exametrika")` check for more robust input
  validation.
- Full backward compatibility maintained for binary Biclustering, LCA,
  LRA, LDLRA, LDB, and BINET models.

## ggExametrika 0.0.24

- Add multi-valued (polytomous) data support to
  [`plotRRV_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotRRV_gg.md)
  and
  [`plotCRV_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotCRV_gg.md)
  for ordinal/nominal Biclustering.
- Add `stat` parameter to
  [`plotRRV_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotRRV_gg.md)
  and
  [`plotCRV_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotCRV_gg.md)
  for polytomous data: “mean” (default), “median”, or “mode”.
- Add `show_labels` parameter to
  [`plotRRV_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotRRV_gg.md)
  and
  [`plotCRV_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotCRV_gg.md)
  (default: FALSE) for displaying rank/class labels using ggrepel.
- Add ggrepel to Imports for automatic label positioning without
  overlaps.
- Y-axis automatically adjusts: 0-1 for binary data (Correct Response
  Rate), 1-maxQ for polytomous data (Expected Score).
- Title automatically includes stat name for polytomous data (e.g.,
  “Rank Reference Vector (mean)”).
- Full backward compatibility maintained for binary Biclustering models.

## ggExametrika 0.0.23

- Add
  [`plotFCRP_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotFCRP_gg.md)
  for Field Category Response Profile (FCRP) visualization (exametrika
  v1.9.0 feature).
- FCRP displays category response probability profiles for each field
  across latent classes/ranks in polytomous biclustering models
  (ordinalBiclustering, nominalBiclustering).
- Support two visualization styles: “line” (default, line plot with
  points) and “bar” (stacked bar chart).
- For bar style, add category boundary transition lines (dashed lines
  connecting adjacent bars).
- Support common plot options (title, colors, linetype, show_legend,
  legend_position).
- Requires 3+ response categories (use plotFRP_gg for binary data).
- Completes exametrika v1.9.0 polytomous biclustering feature set (FCBR,
  ScoreField, FCRP all implemented).

## ggExametrika 0.0.22

- Add multi-valued data support to
  [`plotFRP_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotFRP_gg.md)
  (Field Reference Profile).
- Add `stat` parameter for polytomous data: “mean” (weighted average),
  “median”, “mode”.
- Support ordinalBiclustering and nominalBiclustering in addition to
  binary Biclustering/IRM/LDB/BINET.
- Change return value from list to single ggplot object showing all
  fields.
- Add common plot options (title, colors, linetype, show_legend,
  legend_position) to
  [`plotFRP_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotFRP_gg.md).
- For binary data: displays correct response rate (0-1).
- For polytomous data: displays expected score calculated using selected
  `stat` method.
- Add comprehensive test suite (develop/test_FRP_multivalue.R) covering
  binary/ordinal/nominal data.

## ggExametrika 0.0.21

- Add
  [`plotScoreField_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotScoreField_gg.md)
  for Score-Field heatmap visualization (exametrika v1.9.0 feature).
- [`plotScoreField_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotScoreField_gg.md)
  displays expected scores for each field across latent classes/ranks in
  polytomous biclustering models (nominalBiclustering,
  ordinalBiclustering).
- Expected score calculation: sum of (category × probability) for each
  field-class/rank combination.
- Support common plot options (title, colors, show_legend,
  legend_position).
- Add `show_values` parameter to toggle display of score values on
  heatmap cells.
- Add `text_size` parameter to control size of value labels.
- Uses colorblind-friendly yellow-orange-red gradient by default.

## ggExametrika 0.0.20

- Add
  [`plotFCBR_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotFCBR_gg.md)
  for Field Cumulative Boundary Reference (FCBR) visualization
  (ordinalBiclustering).
- FCBR shows cumulative probability curves for each category boundary
  across latent classes/ranks.
- Support common plot options (title, colors, linetype, show_legend,
  legend_position) in
  [`plotFCBR_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotFCBR_gg.md).
- FCBR displays ALL boundary probabilities including P(Q\>=1) (always
  1.0), P(Q\>=2), P(Q\>=3), etc.
- P(Q\>=1) appears as a horizontal line at the top (y=1.0) for
  reference.

## ggExametrika 0.0.19

- Add
  [`plotScoreRank_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotScoreRank_gg.md)
  for Score-Rank heatmap visualization (LRAordinal, LRArated).
- Support common plot options (title, colors, show_legend,
  legend_position) in
  [`plotScoreRank_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotScoreRank_gg.md).

## ggExametrika 0.0.18

- Add
  [`plotICBR_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotICBR_gg.md)
  for Item Category Boundary Response (ICBR) visualization (LRAordinal).
- Add
  [`plotICRP_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotICRP_gg.md)
  for Item Category Reference Profile (ICRP) visualization (LRAordinal,
  LRArated).
- Both functions support common plot options (title, colors, linetype,
  show_legend, legend_position).
- ICBR shows cumulative probability curves for each category boundary
  across latent ranks.
- ICRP shows response probability curves for each category across latent
  ranks (probabilities sum to 1.0).
- Add tidyr to Imports for data transformation in plotICBR_gg() and
  plotICRP_gg().

## ggExametrika 0.0.17

- Add
  [`plotIIC_overlay_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotIIC_overlay_gg.md)
  for overlaying all Item Information Curves (IIC) on a single plot
  (IRT/GRM).
- [`plotIIC_overlay_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotIIC_overlay_gg.md)
  supports both IRT and GRM models.
- [`plotIIC_overlay_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotIIC_overlay_gg.md)
  supports common plot options (title, colors, linetype, show_legend,
  legend_position).
- Similar to `plot(IRT_result, type = "IIF", overlay = TRUE)` in
  exametrika, but returns a ggplot2 object.

## ggExametrika 0.0.16

- Add
  [`plotICC_overlay_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotICC_overlay_gg.md)
  for overlaying all Item Characteristic Curves (ICC) on a single plot
  (IRT).
- [`plotICC_overlay_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotICC_overlay_gg.md)
  supports common plot options (title, colors, linetype, show_legend,
  legend_position).
- Similar to `plot(IRT_result, type = "IRF", overlay = TRUE)` in
  exametrika, but returns a ggplot2 object.

## ggExametrika 0.0.15

- Add
  [`plotScoreFreq_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotScoreFreq_gg.md)
  for Score Frequency Distribution (LRAordinal, LRArated).
- Common plot options (title, colors, linetype, show_legend,
  legend_position) supported.

## ggExametrika 0.0.14

- Add multi-valued data support to
  [`plotArray_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotArray_gg.md)
  for ordinal/nominal Biclustering.
- Add common plot options (title, colors, show_legend, legend_position)
  to
  [`plotArray_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotArray_gg.md).
- Add `Clusterd_lines_color` parameter to
  [`plotArray_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotArray_gg.md)
  for customizing boundary line colors (default: red for binary data,
  white for multi-valued data).
- [`plotArray_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotArray_gg.md)
  now automatically detects the number of categories and uses
  appropriate color palettes.
- For binary data (0/1), uses white/black colors. For multi-valued data
  (2+ categories), uses a colorblind-friendly palette.
- Add special handling for missing values (-1): displayed as “NA” in
  legend with black color.
- Fix plot margins and title spacing to prevent overlapping in
  side-by-side displays.
- Fix boundary lines to stay within plot area using proper coordinate
  limits.
- Fix boundary line positions in
  [`plotArray_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotArray_gg.md)
  to align exactly with class/field boundaries.
- **CRITICAL FIX**: Correct row sorting order in
  [`plotArray_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotArray_gg.md)
  to match exametrika’s original implementation. Now uses
  `order(ClassEstimated, decreasing = FALSE)` with reversed rown for
  proper visual alignment (higher class numbers at bottom).

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
