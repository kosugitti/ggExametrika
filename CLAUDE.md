# ggExametrika 開発方針

## プロジェクト概要

exametrikaパッケージの出力をggplot2で可視化するためのパッケージ。

## 現在のバージョン

**v1.0.0（CRAN初回投稿 2026-03-20、審査待ち）**

- **親パッケージ**: exametrika v1.10.1（CRAN受理済み 2026-03-19）
- **GitHub**: https://github.com/kosugitti/ggExametrika
- **pkgdownサイト**: https://kosugitti.github.io/ggExametrika/

## 親パッケージ

- 場所: `../exametrika/`
- 参照: https://kosugitti.github.io/exametrika/

## 開発方針

### 変更記録ルール（恒久・厳守）

**軽微なバグ修正でも何でも、変更を加えたら必ずNEWS.mdに記録すること。**

これは殿（プロジェクトオーナー）からの全体指示であり、全ての作業に適用される恒久的なルールである。
コードの変更、ドキュメントの修正、リファクタリング、バグ修正など、種類や規模を問わず、
変更があればNEWS.mdに記録する。記録を省略してはならない。

### コーディング規約
- roxygen2によるドキュメント生成
- testthatによるユニットテスト
- CRAN準拠のチェックをパスすること

### 関数命名規則
- plot関数: `plot*_gg()` 形式
- 内部関数: `.` prefix

### 共通オプション（全plot関数に適用）

全てのplot関数は以下の共通引数を持つ。

| 引数 | 型 | デフォルト | 説明 |
|------|----|-----------|------|
| `title` | logical or character | `TRUE` | TRUE=自動タイトル、FALSE=非表示、文字列=カスタムタイトル |
| `colors` | character vector | `NULL` | NULL=デフォルトパレット、指定でカスタム色 |
| `linetype` | character or numeric | 関数依存 | 線の種類（"solid", "dashed"等） |
| `show_legend` | logical | 関数依存 | 凡例の表示/非表示 |
| `legend_position` | character | `"right"` | "top", "bottom", "left", "right", "none" |

### 依存パッケージ（DESCRIPTION準拠）
- **Depends**: R (>= 4.1.0), ggplot2
- **Imports**: ggraph, ggrepel, gridExtra, igraph, tidyr
- **Suggests**: exametrika, testthat (>= 3.0.0)

## 現在の全体ステータス（2026-03-20更新）

- **バージョン**: v1.0.0（CRAN初回投稿、審査待ち）
- **Rソースファイル**: 15ファイル（R/ディレクトリ）
- **Export関数**: 31関数（プロット27 + オーバーレイ2 + ユーティリティ4）
- **共通オプション**: 全プロット関数で対応済み
- **テスト**: 12ファイル、FAIL 0 / WARN 22（ggplot2 deprecation） / SKIP 0
- **R CMD check**: 0 errors | 0 warnings | 0 notes
- **win-builder**: 1 NOTE（New submission + スペルチェックのみ）
- **rhub**: linux / macos-arm64 / windows チェック実行済み
- **pkgdown**: GitHub Pages デプロイ済み、Plot Gallery記事あり
- **CI**: R-CMD-check.yaml + test-coverage.yaml + pkgdown.yaml + rhub.yaml 稼働中
- **DAG可視化**: BNM / LDLRA / LDB / BINET 全て実装・テスト済み

### Export関数一覧（31関数）

**プロット関数（25種）:**
plotICC_gg, plotICRF_gg, plotTRF_gg, plotIIC_gg, plotTIC_gg,
plotIRP_gg, plotFRP_gg, plotTRP_gg, plotLCD_gg, plotLRD_gg,
plotCMP_gg, plotRMP_gg, plotCRV_gg, plotRRV_gg, plotArray_gg,
plotFCRP_gg, plotFCBR_gg, plotScoreField_gg, plotFieldPIRP_gg,
plotLDPSR_gg, plotScoreFreq_gg, plotScoreRank_gg, plotICRP_gg,
plotICBR_gg, plotGraph_gg

**オーバーレイプロット関数（2種）:**
plotICC_overlay_gg, plotIIC_overlay_gg

**ユーティリティ関数（4種）:**
combinePlots_gg, LogisticModel, ItemInformationFunc, ItemInformationFunc_GRM

## CRAN投稿履歴

### v1.0.0（2026-03-20 初回投稿、審査待ち）
- exametrika v1.10.1 CRAN受理を受けて投稿
- win-builder: 1 NOTE（New submission + Biclustering/Shojima スペルチェック）→ 問題なし
- 非ASCII文字（×）をASCII（x）に置換
- 遅い examples に `\donttest{}` 追加（plotIIC_gg, plotTIC_gg, plotIIC_overlay_gg, plotICRF_gg, plotCMP_gg, plotRMP_gg, plotICBR_gg, plotICRP_gg）
- Amazon短縮URL（amzn.to）をISBNに置換

## 今後の予定

### v1.1.0以降
- **visNetwork版（plotGraph_interactive）** — インタラクティブDAG編集
- exametrika v1.11.0（Biclustering.rated + Rated IRM）対応のプロット追加

## 共同開発ルール（3名体制）

### Git運用（推奨ワークフロー）

#### 基本フロー
```bash
# 1. 作業前に最新を取得
git checkout main
git pull origin main

# 2. featureブランチを作成（機能ごと）
git checkout -b feature/機能名

# 3. 開発・コミット（1機能1コミット）
git add .
git commit -m "Add plotScoreFreq_gg for score frequency"

# 4. リモートにpush
git push origin feature/機能名

# 5. 作業完了後、mainにマージ
git checkout main
git merge feature/機能名
git push origin main

# 6. 不要なブランチを削除
git branch -d feature/機能名
```

### 作業ログ（log.md）
- 作業開始時に日付と担当者名を記録する
- 何を実装/修正したか、判断の理由を簡潔に書く
- 次回の課題・残作業を明記する
