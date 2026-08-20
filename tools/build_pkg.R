# リリース手順。上から順に手で実行する(source() で一括実行しない)。
# 最後の release() / submit_cran() は提出日に本人が押す。
#
# == なぜ git archive を挟むか ==
# このリポジトリは Dropbox 同期下にあり，Dropbox はもう一台のマシンから
# 「git 上は削除済みのファイル」を働き木に復活させることがある。
# 2026-08-20 に exametrika 本体でこれを踏み，削除済みの旧テスト 5 本が
# tarball に混入して win-builder だけで 9 件の偽の失敗が出た。
# R CMD build はディスクにある物を全部拾うので，検査・提出に使う木は必ず
# git archive で Dropbox の外に書き出して作る。

pacman::p_load(styler, devtools, rhub)

## --- A. 開発側(働き木)。差分が出たらコミットしてから B へ進む ---
styler::style_pkg()
devtools::document()
# **build_readme() は呼ばない。**このリポジトリは README.md が正本で，
# README.Rmd は「参照用・knit するな」と自ら明記している残骸(.Rbuildignore 済み)。
# 2026-08-20 に誤って再生成し 296 行を消しかけた。README を直すときは
# README.md を直接編集する。
devtools::spell_check()

## --- B. 検査・提出側(コミット済みの木だけを使う) ---
dirty <- system2("git", c("status", "--porcelain"), stdout = TRUE)
if (length(dirty) > 0) {
  stop("働き木がクリーンではない(未追跡を含む):\n", paste(dirty, collapse = "\n"))
}
src <- file.path(path.expand("~/.local/tmp"), "ggExametrika-release")
unlink(src, recursive = TRUE)
dir.create(src, recursive = TRUE, showWarnings = FALSE)
system(sprintf("git archive HEAD | tar -x -C %s", shQuote(src)))

devtools::check(src, cran = TRUE)
# rhub は GitHub のコミットを検査するので働き木に依存しない
# Note: "macos" (Intel macos-13) removed because rhub resolves it to
# "macos-13-us-default" which is no longer available on GitHub Actions.
rhub::rhub_check(platforms = c("linux", "macos-arm64", "windows"))
devtools::check_win_devel(src, email = "kosugitti@gmail.com")

devtools::submit_cran(src)
