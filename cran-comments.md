## R CMD check results

0 errors | 0 warnings | 0 notes

## Test environments

* local macOS (aarch64-apple-darwin), R 4.6.2
* R-hub v2: linux, macos-arm64, windows (R-devel)
* win-builder: R-devel

## Update (v1.2.0 -> v1.3.0)

New plotting functions and changed defaults of `plotGraph_gg()`, so the minor
version is raised. No exported function signature loses an argument.

### New features

* `plotGridSearch_gg()` draws the fit index recorded by
  `exametrika::GridSearch()`.
* `plotRankUpShift_gg()` and `plotRankOdds_gg()` for the ordinal
  Ranklustering, the ggplot2 versions of the plot types added in
  exametrika 2.3.0.
* `combinePlots_gg()` gains `nr` and `nc`.
* `plotGraph_gg()` shades BNM item nodes by correct response rate, draws
  hierarchical layouts top-to-bottom by default and lists isolated items
  (`fill_by`, `direction`, `show_isolated`).

### Bug fixes

* `plotGraph_gg()` labelled items numbered 10 and above with their last digit
  only.
* The class/rank plots now read from the fit whether a biclustering has
  classes or ranks.
* The examples and test fixtures no longer pass a non-existent `dataType`
  argument to exametrika, which exametrika 2.3.0 now reports.

### Preparing for exametrika 3.0.0

`plotGraph_gg()` builds the graphs from the adjacency matrices exametrika
returns instead of its igraph objects, which exametrika 3.0.0 will drop. The
plots are unchanged.

## Dependencies

`exametrika` is in Suggests. Version 2.3.0 of it was accepted on CRAN on
2026-11-25, and the suite passes against it. Functions that use output added
in exametrika 2.3.0 fall back to computing it themselves with an older
version. All Imports packages are available on CRAN.

## Test results

0 failures | 0 skips | 755 passes
