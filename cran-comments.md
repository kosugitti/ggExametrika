## R CMD check results

0 errors | 0 warnings | 0 notes

## Test environments

* local macOS (aarch64-apple-darwin25.0.0), R 4.6.1: 0 errors, 0 warnings,
  0 notes
* R-hub v2: linux, macos-arm64, windows (R-devel)
* win-builder: R-devel

## Update (v1.1.2 -> v1.2.0)

`plotArray_gg()` changes what it draws by default, so the version is raised
rather than treated as a patch. No exported function signature changes.

### Bug fix

* `plotArray_gg()` misassigned colours when `colors` was supplied and the data
  contained missing responses: the missing level took the first colour and the
  last category wrapped back to the start. A supplied vector is now read by its
  length, so one colour per valid category leaves the missing level at its
  default.

### Changes to the default plot

* Ordered categories are drawn with a sequential ramp instead of a qualitative
  palette, missing responses in grey, and cluster boundary lines in dark red.
* A single shared legend is drawn below the panels instead of one per panel.

## Dependencies

`exametrika` is in Suggests. Version 2.1.0 of it was accepted on CRAN on
2026-09-25, and the suite passes against it. All Imports packages are
available on CRAN.

## Test results

0 failures | 0 skips | 655 passes

One warning is emitted during the tests by exametrika's `BINET()` when it
reports that an edge exceeds the maximum number of fields on the small
synthetic test data. It is a model-side caution from the suggested
package, not a condition raised by ggExametrika.
