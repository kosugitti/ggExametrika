## R CMD check results

0 errors | 0 warnings | 1 note

The NOTE is about a non-standard top-level file (`WORKLOG.md`), which is
listed in `.Rbuildignore` and will not be included in the package tarball.

## Update (v1.0.0 -> v1.1.0)

This is an update to the CRAN-published v1.0.0. Changes in this version:

* New exported function `plotDistractor_gg()` for Distractor Analysis
  visualization, corresponding to exametrika v1.11.0's
  `DistractorAnalysis()` output. Creates stacked bar charts showing
  response category proportions by rank/class, with the correct answer
  highlighted.
* Add support for `ratedBiclustering` class (exametrika v1.11.0) in 11
  existing plot functions.

## Test environments

* local macOS Tahoe 26.4.0 (Apple Silicon, aarch64-apple-darwin25.4.0), R 4.5.3
* GitHub Actions: macOS-latest (release), windows-latest (release), ubuntu-latest (release, devel)

## Dependencies

* exametrika is listed in Suggests (not required for installation)
* All Imports packages are available on CRAN
