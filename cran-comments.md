## R CMD check results

0 errors | 0 warnings | 0 notes

## Test results

0 failures | 1 warning | 0 skips | 581 passes

The 1 warning is from exametrika's internal `stanine()` function when
processing small synthetic test data, not from ggExametrika code.

## Update (v1.0.0 -> v1.1.0)

This is an update to the CRAN-published v1.0.0. Changes in this version:

* New exported function `plotDistractor_gg()` for Distractor Analysis
  visualization, corresponding to exametrika v1.11.0's
  `DistractorAnalysis()` output. Creates stacked bar charts showing
  response category proportions by rank/class, with the correct answer
  highlighted.
* Add support for `ratedBiclustering` class (exametrika v1.11.0) in 11
  existing plot functions.
* Fix deprecated `sec_axis(trans = ...)` to `sec_axis(transform = ...)`
  for ggplot2 >= 3.5.0.

## Test environments

* local macOS Tahoe 26.4.0 (Apple Silicon, aarch64-apple-darwin25.4.0), R 4.5.3
* GitHub Actions: macOS-latest (release), windows-latest (release), ubuntu-latest (release, devel)
* R-hub: linux (R-devel) OK, macos-arm64 (R-devel) OK
* R-hub windows (R-devel): exametrika v1.11.0 binary for R 4.7 not yet
  available on CRAN mirror (R 4.5 binary is available). The example using
  `J21S300` (new dataset in exametrika v1.11.0) fails only in this
  environment. All other platforms pass.

## Dependencies

* exametrika (>= 1.11.0) is listed in Suggests (not required for installation)
* All Imports packages are available on CRAN
