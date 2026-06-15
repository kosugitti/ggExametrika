## R CMD check results

0 errors | 0 warnings | 0 notes

## Test results

0 failures | 1 warning | 0 skips | 581 passes

The 1 warning is from exametrika's internal `stanine()` function when
processing small synthetic test data, not from ggExametrika code.

## Update (v1.1.0 -> v1.1.1)

This is an update to the CRAN-published v1.1.0. Changes in this version:

* `plotArray_gg()` gains opt-in `border` and `border_linewidth` arguments
  to draw a rectangular panel border around the original and clustered
  panels. The default (`border = FALSE`) preserves the v1.1.0 appearance.
* Rename the misspelled `Clusterd*` arguments and labels in
  `plotArray_gg()` to the correct `Clustered*` spelling
  (`Clusterd` -> `Clustered`, etc.). Code passing these by position is
  unaffected; code naming them must be updated.
* Fix a value/label ordering bug in `plotCRV_gg()` and `plotRRV_gg()`.

## Test environments

* local macOS Tahoe 26 (Apple Silicon, aarch64-apple-darwin25), R 4.6.0
* GitHub Actions: macOS-latest (release), windows-latest (release), ubuntu-latest (release, devel)
* R-hub: linux (R-devel), macos-arm64 (R-devel), windows (R-devel)

## Dependencies

* exametrika (in Suggests) is now published on CRAN at v1.14.0, so its
  binary is available on all R-hub / win-builder platforms. This resolves
  the Windows binary-availability note seen during the v1.1.0 submission.
* All Imports packages are available on CRAN.
