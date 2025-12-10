# ggExametrika 開発方針

## プロジェクト概要

exametrikaパッケージの出力をggplot2で可視化するためのパッケージ。
CRAN公開を目指す。

## 親パッケージ

- 場所: `../exametrika/`
- 参照: <https://kosugitti.github.io/Exametrika/>

## 開発方針

### コーディング規約

- roxygen2によるドキュメント生成
- testthatによるユニットテスト
- CRAN準拠のチェックをパスすること

### 関数命名規則

- plot関数: `plot_*()` または `gg*()` 形式を検討
- 内部関数: `.` prefix

### 依存パッケージ

- ggplot2 (必須)
- gridExtra (複数プロット配置)
- exametrikaはSuggestsに入れる（CRAN対応のため）

### CRANチェックリスト

R CMD check –as-cran でWARNING/ERRORなし

NEWS.mdの更新

DESCRIPTIONのバージョン更新

examplesの動作確認

ドキュメントの整備

## バージョン1.0に向けて

exametrikaの全プロット機能をggplot2で実装完了したらv1.0とする。

### exametrikaのプロットタイプ一覧と実装状況

| プロットタイプ | 対応モデル                                                 | ggExametrika関数 | 状況        |
|----------------|------------------------------------------------------------|------------------|-------------|
| IRF/ICC        | IRT, GRM                                                   | plotICC_gg       | 実装済(IRT) |
| TRF            | IRT                                                        | \-               | 未実装      |
| IIF/IIC        | IRT, GRM                                                   | plotIIC_gg       | 実装済(IRT) |
| TIF/TIC        | IRT, GRM                                                   | plotTIC_gg       | 実装済(IRT) |
| IRP            | LCA, LRA, LDLRA                                            | plotIRP_gg       | 実装済      |
| FRP            | LCA, LRA, Biclustering, IRM, LDB, BINET                    | plotFRP_gg       | 実装済      |
| TRP            | LCA, LRA, Biclustering, IRM, LDLRA, LDB, BINET             | plotTRP_gg       | 実装済      |
| LCD            | LCA, Biclustering                                          | plotLCD_gg       | 実装済      |
| LRD            | LRA, Biclustering, LDLRA, LDB, BINET                       | plotLRD_gg       | 実装済      |
| CMP            | LCA, Biclustering, BINET                                   | plotCMP_gg       | 実装済      |
| RMP            | LRA, Biclustering, LDLRA, LDB, BINET, LRAordinal, LRArated | plotRMP_gg       | 実装済      |
| CRV/RRV        | Biclustering                                               | \-               | 未実装      |
| Array          | Biclustering, IRM, LDB, BINET                              | plotArray_gg     | 実装済      |
| FieldPIRP      | LDB                                                        | plotFieldPIRP_gg | 実装済      |
| LDPSR          | BINET                                                      | \-               | 未実装      |
| ScoreFreq      | LRAordinal, LRArated                                       | \-               | 未実装      |
| ScoreRank      | LRAordinal, LRArated                                       | \-               | 未実装      |
| ICRP           | LRAordinal, LRArated                                       | \-               | 未実装      |
| ICBR           | LRAordinal                                                 | \-               | 未実装      |

### 未実装機能（v1.0までに実装予定）

1.  TRF (Test Response Function)
2.  CRV/RRV (Class/Rank Reference Vector)
3.  LDPSR (Latent Dependence Passing Student Rate)
4.  ScoreFreq (スコア頻度分布)
5.  ScoreRank (スコア-ランクヒートマップ)
6.  ICRP (Item Category Reference Profile)
7.  ICBR (Item Category Boundary Response)
8.  GRM対応 (IRF, IIF, TIF)

## 作業ログ

作業ログは `log.md` に記録する。
