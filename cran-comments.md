## R CMD check results

0 errors | 0 warnings | 0 notes

## Test environments

* local macOS (aarch64-apple-darwin25.0.0), R 4.6.1: 0 errors, 0 warnings,
  1 NOTE (HTML manual validation skipped, an artifact of the local HTML
  Tidy version; not reported by win-builder, R-hub or CI)
* GitHub Actions: ubuntu-latest (R-devel, R-release), macOS-latest
  (R-release), windows-latest (R-release)
* R-hub v2: linux, macos-arm64, windows (R-devel)
* win-builder: R-devel

## Update (v1.1.1 -> v1.1.2)

A package-wide audit release. No exported function signature changes.

### Bug fixes (high severity)

* `plotICC_gg()` / `plotIIC_gg()` silently dropped the `lowerAsym`
  parameter for 4PL models, so a 4PL curve was drawn with a lower
  asymptote of 0. The `plot*_overlay_gg()` variants were already correct,
  so the single and overlay versions of the same item disagreed.
* The GRM item information formula in `ItemInformationFunc_GRM()` did not
  match Samejima (1969); it is corrected and cross-checked against
  numerical differentiation of the category response functions.

The remaining changes are robustness fixes, argument validation made
consistent across the plotting functions, and internal refactoring, all
listed in NEWS.md.

## Dependencies

`exametrika` is in Suggests. This release drops the PascalCase field-name
fallbacks (`Nclass`, `Nfield`, `Nrank`) that exametrika deprecated in
1.8.0 and removed in 2.0.0. The package declares `exametrika (>= 1.11.0)`,
so every supported version reports the snake_case names and the removed
path was unreachable. The suite passes against both the CRAN version and
2.0.0.

All Imports packages are available on CRAN.

## Check time

The first win-builder run of this release came in at 686 s, over CRAN's
600 s Windows limit, and raised a NOTE for a 28 s example. Both were
fixture size rather than test count: two plotting functions emit one
ggplot per respondent and their fixtures were fitted on all 3,810
respondents of `J15S3810`. The fixtures now use row subsets and the
affected examples fit `J5S1000`; the assertions are structural and
unchanged. Locally the suite runs in 39 s and the examples in 26 s.

## Test results

0 failures | 0 skips | 648 passes

One warning is emitted during the tests by exametrika's `BINET()` when it
reports that an edge exceeds the maximum number of fields on the small
synthetic test data. It is a model-side caution from the suggested
package, not a condition raised by ggExametrika.
