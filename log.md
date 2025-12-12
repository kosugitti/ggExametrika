# ggExametrika 開発ログ

## 2025-12-10

### 初期セットアップ

- claude.md（開発方針）とlog.md（作業ログ）を作成
- .Rbuildignoreにclaude.md、log.md、README.Rmdを追加
- DESCRIPTIONのSuggestsにExametrikaを追加

### exametrikaとの互換性調査

#### 致命的な問題: クラス名の大文字/小文字

ggExametrikaは `"Exametrika"` (大文字E)をチェックしているが、
現在のexametrikaは `"exametrika"` (小文字e)を使用。

**影響を受ける関数（全関数）:** - `plotICC_gg`:
`class(data) %in% c("Exametrika", "IRT")` → 動作しない - `plotIIC_gg`:
同上 - `plotTIC_gg`: 同上 - `plotIRP_gg`: `c("Exametrika", "LCA")`,
`c("Exametrika", "LRA")`, `c("Exametrika", "LDLRA")` → 動作しない -
`plotFRP_gg`: `c("Exametrika", "Biclustering")`, etc. → 動作しない -
`plotTRP_gg`: 同上 - `plotLCD_gg`: 同上 - `plotLRD_gg`: 同上 -
`plotCMP_gg`: 同上 - `plotRMP_gg`: 同上 - `plotArray_gg`: 同上 -
`plotFieldPIRP_gg`: 同上

#### 修正方針

全ての `"Exametrika"` を `"exametrika"` に変更する必要あり。

#### exametrikaの現在の出力構造（確認済み）

| クラス       | 主要フィールド                                                                                    |
|--------------|---------------------------------------------------------------------------------------------------|
| IRT          | params (slope, location, lowerAsym, upperAsym), itemPSD, ability                                  |
| LCA          | IRP, TRP, LCD, CMD, Students, Nclass                                                              |
| LRA          | IRP, IRPIndex, TRP, LRD, RMD, Students, Nrank                                                     |
| Biclustering | FRP, FRPIndex, TRP, LRD/LCD, CMD/RMD, Students, U, FieldEstimated, ClassEstimated, Nclass, Nfield |
| IRM          | FRP, TRP, LCD, LFD, FieldEstimated, ClassEstimated, Nclass, Nfield                                |
| LDLRA        | IRP, IRPIndex, TRP, LRD, RMD, Students, Nclass, CCRR_table                                        |
| LDB          | IRP, FRP, FRPIndex, TRP, LRD, RMD, Students, Nrank, Nfield, CCRR_table                            |
| BINET        | FRP, PSRP, LDPSR, TRP, LCD, CMD, Students, Nclass, Nfield                                         |

**注意**: 新しいexametrikaは一部で命名規則を変更中 - `Nclass` →
`n_class` (後方互換性のため両方存在) - `Nrank` → `n_rank` - `N_Cycle` →
`n_cycle`

ggExametrikaが使用している `Nclass`, `Nrank`
などは後方互換性フィールドとして残っているため、フィールドアクセス自体は問題なし。

### クラス名修正完了

全Rファイルで `"Exametrika"` → `"exametrika"` に修正: - `R/ICCtoTIC.R` -
`R/IRPtoCMPRMP.R` - `R/arraytoLDPSR.R`

### GitHub Pages (pkgdown) 設定

- `_pkgdown.yml` 作成（サイト設定、リファレンス構成）
- `.github/workflows/pkgdown.yaml` 作成（GitHub Actions自動デプロイ）
- `.Rbuildignore` に pkgdown関連を追加
- DESCRIPTIONのSuggests: `Exametrika` → `exametrika`
  (CRANパッケージ名は小文字)
- GitHub Pages有効化完了
- サイト公開: <https://kosugitti.github.io/ggExametrika/>

### コードスタイル整備

- `styler::style_pkg()` を適用
- `README.Rmd` の
  [`library(Exametrika)`](https://rdrr.io/r/base/library.html) →
  [`library(exametrika)`](https://kosugitti.github.io/exametrika/)
  に修正
- `README.md` を再生成

### ヘルプドキュメント拡充

- 全関数に `@return`, `@details`, `@examples`, `@seealso` を追加
- `@seealso` はパッケージ内の関数のみを参照（外部参照は削除）
- 対象ファイル:
  - `R/ICCtoTIC.R`: plotICC_gg, LogisticModel, ItemInformationFunc,
    plotIIC_gg, plotTIC_gg
  - `R/IRPtoCMPRMP.R`: plotIRP_gg, plotFRP_gg, plotTRP_gg, plotLCD_gg,
    plotLRD_gg, plotCMP_gg, plotRMP_gg
  - `R/arraytoLDPSR.R`: plotArray_gg, plotFieldPIRP_gg
  - `R/option.R`: combinePlots_gg
- `devtools::document()` で man/\*.Rd ファイル更新（15ファイル）
- `styler::style_pkg()` で再フォーマット

### 本日の作業サマリー

1.  開発環境整備（claude.md, log.md）
2.  exametrikaとの互換性修正（クラス名を小文字に統一）
3.  GitHub Pages自動デプロイ設定
4.  v1.0ロードマップ作成（8つの未実装機能を特定）
5.  コードスタイル整備（styler適用）
6.  全関数のヘルプドキュメント拡充

**次回の課題**: v1.0に向けた未実装プロット機能の実装

## 2025-12-12

### DAG可視化関数の開発開始

#### 調査結果: plot.exametrikaの全プロットタイプ

**実装済み（ggExametrika）:** - plotICC_gg, plotIIC_gg, plotTIC_gg
(IRT) - plotIRP_gg, plotFRP_gg, plotTRP_gg - plotLCD_gg, plotLRD_gg,
plotCMP_gg, plotRMP_gg - plotArray_gg, plotFieldPIRP_gg

**未実装（plot.exametrikaにある）:** 1. TRF (Test Response Function) -
IRT 2. CRV/RRV (Class/Rank Reference Vector) - Biclustering 3. LDPSR
(Latent Dependence Passing Student Rate) - BINET 4. ScoreFreq -
LRAordinal, LRArated 5. ScoreRank - LRAordinal, LRArated 6. ICRP (Item
Category Reference Profile) - LRAordinal, LRArated 7. ICBR (Item
Category Boundary Response) - LRAordinal

**未実装（print.exametrikaでigraph使用）:** 1. BNM - DAGの可視化 2.
LDLRA - ランク/クラスごとのDAG 3. LDB - ランクごとのDAG 4. BINET -
統合グラフ（edge label付き）

#### 実施した作業

1.  DESCRIPTIONに `ggraph`, `igraph` をImportsに追加
2.  `R/plotGraph_gg.R` を新規作成（BNM, LDLRA, LDB, BINET対応）
3.  ggraphパッケージをインストール

#### DAG可視化の開発方針（決定事項）

**2段階アプローチ:** 1. `plotGraph_interactive()` -
visNetworkでインタラクティブ編集版 - ノードをドラッグして位置調整可能 -
編集後の座標を取得可能 2. `plotGraph_gg()` -
ggraphで静的ggplotオブジェクト版 -
インタラクティブ版で決めた座標を渡して清書

**理由:** ユーザーがノードの配置を手動で調整したい場合があるため、
visNetworkで大体の配置を決めてから、ggraphで最終的な静的プロットを生成する流れ。

#### 次回の作業

1.  visNetworkを使った `plotGraph_interactive()` の実装
2.  座標取得→ggraphへの受け渡し機能
3.  plotGraph_gg関数のテスト
4.  ドキュメント整備
