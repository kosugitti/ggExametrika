# ggExametrika 入門ガイド

## 概要

**ggExametrika**
は、[exametrika](https://kosugitti.github.io/Exametrika/)
パッケージの出力をggplot2で可視化するためのパッケージです。
IRT、GRM、潜在クラス・ランク分析、バイクラスタリング、ベイジアンネットワークモデルなど、
幅広い心理測定モデルに対応しています。

## インストール

``` r
# GitHubからインストール
devtools::install_github("kosugitti/ggExametrika")
```

## 準備

``` r
library(exametrika)
library(ggExametrika)
```

------------------------------------------------------------------------

## 1. IRT（項目反応理論）

IRT（2PL, 3PL,
4PL）モデルは、2値応答データから項目パラメータを推定します。

``` r
result_irt <- IRT(J15S500, model = 2)
```

### plotICC_gg: 項目特性曲線（ICC）

能力（theta）の関数として正答確率を表示します。

``` r
# 項目ごとにプロットのリストを返す
icc_plots <- plotICC_gg(result_irt)
icc_plots[[1]]  # 1番目の項目を表示
```

[`combinePlots_gg()`](https://kosugitti.github.io/ggExametrika/reference/combinePlots_gg.md)
で複数項目を一度に表示:

``` r
combinePlots_gg(icc_plots, selectPlots = 1:6)
```

能力の範囲をカスタマイズ:

``` r
icc_plots <- plotICC_gg(result_irt, xvariable = c(-3, 3))
```

### plotIIC_gg: 項目情報曲線（IIC）

各項目がどの能力レベルでどの程度の測定精度を持つかを表示します。

``` r
iic_plots <- plotIIC_gg(result_irt)
iic_plots[[1]]
combinePlots_gg(iic_plots, selectPlots = 1:6)
```

特定の項目を選択:

``` r
iic_plots <- plotIIC_gg(result_irt, items = c(1, 3, 5))
```

### plotTIC_gg: テスト情報曲線（TIC）

全項目の情報量の合計（テスト情報関数）を表示します。

``` r
tic_plot <- plotTIC_gg(result_irt)
tic_plot
```

外観のカスタマイズ:

``` r
plotTIC_gg(result_irt,
  title = "カスタムタイトル",
  color = "darkred",
  linetype = "dashed"
)
```

### plotTRF_gg: テスト応答関数（TRF）

能力の関数として期待総得点を表示します。

``` r
trf_plot <- plotTRF_gg(result_irt)
trf_plot
```

### LogisticModel / ItemInformationFunc: 補助関数

IRTモデルの低レベル計算関数です。

``` r
# 4パラメータロジスティックモデル: P(theta)
LogisticModel(x = 0, a = 1.5, b = 0.5, c = 0.2, d = 1.0)

# 指定したthetaでの項目情報量
ItemInformationFunc(x = 0, a = 1.5, b = 0.5, c = 0.2, d = 1.0)
```

------------------------------------------------------------------------

## 2. GRM（段階反応モデル）

GRMは順序付き多値応答データ（例: リッカート尺度）を扱います。

``` r
result_grm <- GRM(J5S1000)
```

### plotICRF_gg: 項目カテゴリ応答関数（ICRF）

能力の関数として各応答カテゴリの選択確率を表示します。

``` r
icrf_plots <- plotICRF_gg(result_grm)
icrf_plots[[1]]
combinePlots_gg(icrf_plots, selectPlots = 1:5)
```

特定の項目を選択してカスタマイズ:

``` r
plotICRF_gg(result_grm,
  items = c(1, 2),
  title = "項目1-2のICRF",
  colors = c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3", "#FF7F00"),
  linetype = "solid",
  show_legend = TRUE,
  legend_position = "bottom"
)
```

### plotIIC_gg（GRM版）: 項目情報曲線

GRMデータにも対応しています:

``` r
iic_grm <- plotIIC_gg(result_grm)
iic_grm[[1]]
combinePlots_gg(iic_grm, selectPlots = 1:5)
```

### plotTIC_gg（GRM版）: テスト情報曲線

``` r
tic_grm <- plotTIC_gg(result_grm)
tic_grm
```

### ItemInformationFunc_GRM: 補助関数

``` r
# 5カテゴリ項目の theta = 0 での情報量
ItemInformationFunc_GRM(theta = 0, a = 1.5, b = c(-1.5, -0.5, 0.5, 1.5))
```

------------------------------------------------------------------------

## 3. LCA（潜在クラス分析）

LCAは2値応答データから潜在クラス（離散的グループ）を識別します。

``` r
result_lca <- LCA(J15S500, ncls = 3)
```

### plotIRP_gg: 項目参照プロファイル（IRP）

各潜在クラスにおける各項目の正答確率を表示します。

``` r
irp_plots <- plotIRP_gg(result_lca)
irp_plots[[1]]
combinePlots_gg(irp_plots, selectPlots = 1:6)
```

### plotFRP_gg: フィールド参照プロファイル（FRP）

クラスごとのフィールド（項目クラスタ）正答率を表示します。

``` r
frp_plot <- plotFRP_gg(result_lca)
frp_plot
```

### plotTRP_gg: テスト参照プロファイル（TRP）

クラスごとの学生数と期待テスト得点を表示します。

``` r
trp_plot <- plotTRP_gg(result_lca)
trp_plot
```

学生数ラベルやタイトルを非表示にする:

``` r
plotTRP_gg(result_lca, Num_Students = FALSE, title = FALSE)
```

### plotLCD_gg: 潜在クラス分布（LCD）

クラス帰属度の分布を表示します。

``` r
lcd_plot <- plotLCD_gg(result_lca)
lcd_plot
```

### plotCMP_gg: クラスメンバーシッププロファイル（CMP）

各学生の全クラスに対する帰属確率プロファイルを表示します。

``` r
# 学生ごとにプロットのリストを返す
cmp_plots <- plotCMP_gg(result_lca)
cmp_plots[[1]]  # 1人目の学生
combinePlots_gg(cmp_plots, selectPlots = 1:6)
```

------------------------------------------------------------------------

## 4. LRA（潜在ランク分析）

LRAは2値応答データから順序付きの潜在ランクを識別します。

``` r
result_lra <- LRA(J15S500, nrank = 4)
```

### plotIRP_gg: 項目参照プロファイル

``` r
irp_plots <- plotIRP_gg(result_lra)
combinePlots_gg(irp_plots, selectPlots = 1:6)
```

### plotFRP_gg: フィールド参照プロファイル

``` r
frp_plot <- plotFRP_gg(result_lra)
frp_plot
```

### plotTRP_gg: テスト参照プロファイル

``` r
trp_plot <- plotTRP_gg(result_lra)
trp_plot
```

### plotLRD_gg: 潜在ランク分布（LRD）

ランク帰属度の分布を表示します。

``` r
lrd_plot <- plotLRD_gg(result_lra)
lrd_plot
```

### plotRMP_gg: ランクメンバーシッププロファイル（RMP）

各学生の全ランクに対する帰属確率プロファイルを表示します。

``` r
rmp_plots <- plotRMP_gg(result_lra)
rmp_plots[[1]]
combinePlots_gg(rmp_plots, selectPlots = 1:6)
```

------------------------------------------------------------------------

## 5. バイクラスタリング

バイクラスタリングは、項目（フィールドへ）と学生（ランクへ）を同時にクラスタリングします。

``` r
result_bic <- Biclustering(J35S515, nfld = 5, nrank = 6)
```

### plotFRP_gg: フィールド参照プロファイル

``` r
frp_plots <- plotFRP_gg(result_bic)
frp_plots[[1]]
combinePlots_gg(frp_plots, selectPlots = 1:5)
```

### plotTRP_gg: テスト参照プロファイル

``` r
trp_plot <- plotTRP_gg(result_bic)
trp_plot
```

### plotLRD_gg: 潜在ランク分布

``` r
lrd_plot <- plotLRD_gg(result_bic)
lrd_plot
```

### plotRMP_gg: ランクメンバーシッププロファイル

``` r
rmp_plots <- plotRMP_gg(result_bic)
combinePlots_gg(rmp_plots, selectPlots = 1:6)
```

### plotCRV_gg: クラス参照ベクトル（CRV）

全クラスのプロファイルを1つのプロットにまとめて表示します（クラスごとに異なる線）。

``` r
crv_plot <- plotCRV_gg(result_bic)
crv_plot
```

カスタマイズ:

``` r
plotCRV_gg(result_bic,
  title = "クラス参照ベクトル",
  linetype = "dashed",
  legend_position = "bottom"
)
```

### plotRRV_gg: ランク参照ベクトル（RRV）

全ランクのプロファイルを1つのプロットにまとめて表示します（ランクごとに異なる線）。

``` r
rrv_plot <- plotRRV_gg(result_bic)
rrv_plot
```

### plotArray_gg: 配列プロット

2値データ行列をヒートマップとして可視化し、バイクラスタリング後のブロック対角構造を示します。

``` r
# 元データとクラスタリング済みデータの両方を表示
array_plot <- plotArray_gg(result_bic)
array_plot
```

クラスタリング済みデータのみ表示:

``` r
plotArray_gg(result_bic, Original = FALSE, Clusterd = TRUE)
```

クラスタ境界線を非表示:

``` r
plotArray_gg(result_bic, Clusterd_lines = FALSE)
```

------------------------------------------------------------------------

## 6. BNM（ベイジアンネットワークモデル）

BNMはベイジアンネットワークを用いて項目間の依存構造を発見します。

``` r
result_bnm <- BNM(J15S500)
```

### plotGraph_gg: DAG可視化

モデルが発見した有向非巡回グラフ（DAG）を可視化します。

``` r
dag_plots <- plotGraph_gg(result_bnm)
dag_plots[[1]]
```

レイアウトと外観のカスタマイズ:

``` r
plotGraph_gg(result_bnm,
  layout = "sugiyama",
  rankdir = "LR",
  node_size = 10,
  node_color = "coral",
  label_size = 4,
  edge_color = "gray60",
  title = "BNM DAG"
)
```

利用可能なレイアウト:
`"sugiyama"`（階層型）、`"fr"`（Fruchterman-Reingold）、
`"kk"`（Kamada-Kawai）、`"tree"`、`"circle"`、`"grid"`、`"stress"`

------------------------------------------------------------------------

## 7. LDLRA（局所依存潜在ランク分析）

LDLRAは各ランク内に局所的な依存構造を追加します。

``` r
result_ldlra <- LDLRA(J15S500, ncls = 5)
```

### plotIRP_gg: 項目参照プロファイル

``` r
irp_plots <- plotIRP_gg(result_ldlra)
combinePlots_gg(irp_plots, selectPlots = 1:6)
```

### plotLRD_gg: 潜在ランク分布

``` r
lrd_plot <- plotLRD_gg(result_ldlra)
lrd_plot
```

### plotRMP_gg: ランクメンバーシッププロファイル

``` r
rmp_plots <- plotRMP_gg(result_ldlra)
combinePlots_gg(rmp_plots, selectPlots = 1:6)
```

### plotGraph_gg: ランクごとのDAG

ランクごとに1つのDAGを返します。ランク間で依存関係がどう変化するかを確認できます。

``` r
dag_plots <- plotGraph_gg(result_ldlra)
dag_plots[[1]]  # ランク1のDAG
combinePlots_gg(dag_plots)
```

------------------------------------------------------------------------

## 8. LDB（局所依存バイクラスタリング）

LDBはバイクラスタリングの枠組みに局所的な依存構造を追加します。

``` r
result_ldb <- LDB(J35S515, ncls = 6, nfld = 5)
```

### plotFRP_gg: フィールド参照プロファイル

``` r
frp_plots <- plotFRP_gg(result_ldb)
combinePlots_gg(frp_plots, selectPlots = 1:5)
```

### plotTRP_gg: テスト参照プロファイル

``` r
trp_plot <- plotTRP_gg(result_ldb)
trp_plot
```

### plotLRD_gg: 潜在ランク分布

``` r
lrd_plot <- plotLRD_gg(result_ldb)
lrd_plot
```

### plotRMP_gg: ランクメンバーシッププロファイル

``` r
rmp_plots <- plotRMP_gg(result_ldb)
combinePlots_gg(rmp_plots, selectPlots = 1:6)
```

### plotArray_gg: 配列プロット

``` r
array_plot <- plotArray_gg(result_ldb)
array_plot
```

### plotFieldPIRP_gg: フィールド親項目参照プロファイル

親フィールドの得点に基づくフィールド正答率の変化を、ランクごとに表示します。

``` r
fpirp_plots <- plotFieldPIRP_gg(result_ldb)
fpirp_plots[[1]]  # ランク1
combinePlots_gg(fpirp_plots)
```

### plotGraph_gg: ランクごとのDAG

``` r
dag_plots <- plotGraph_gg(result_ldb)
dag_plots[[1]]
combinePlots_gg(dag_plots)
```

------------------------------------------------------------------------

## 9. BINET（ベイジアンネットワーク＆テスト）

BINETはベイジアンネットワーク構造とバイクラスタリングの枠組みを統合します。

``` r
result_binet <- BINET(J35S515, ncls = 6, nfld = 5)
```

### plotFRP_gg: フィールド参照プロファイル

``` r
frp_plots <- plotFRP_gg(result_binet)
combinePlots_gg(frp_plots, selectPlots = 1:5)
```

### plotTRP_gg: テスト参照プロファイル

``` r
trp_plot <- plotTRP_gg(result_binet)
trp_plot
```

### plotLCD_gg: 潜在クラス分布

``` r
lcd_plot <- plotLCD_gg(result_binet)
lcd_plot
```

### plotCMP_gg: クラスメンバーシッププロファイル

``` r
cmp_plots <- plotCMP_gg(result_binet)
combinePlots_gg(cmp_plots, selectPlots = 1:6)
```

### plotArray_gg: 配列プロット

``` r
array_plot <- plotArray_gg(result_binet)
array_plot
```

### plotGraph_gg: DAG可視化

BINETではエッジラベル（依存性の重み）を表示できます:

``` r
dag_plots <- plotGraph_gg(result_binet, show_edge_label = TRUE)
dag_plots[[1]]
```

------------------------------------------------------------------------

## 10. 共通プロットオプション

多くの関数で以下のオプションが利用可能です:

| パラメータ        | 説明                                                | デフォルト             |
|-------------------|-----------------------------------------------------|------------------------|
| `title`           | `TRUE`（自動生成）、`FALSE`（非表示）、または文字列 | `TRUE`                 |
| `colors`          | 線や棒グラフの色ベクトル                            | 色覚多様性対応パレット |
| `linetype`        | 線の種類（`"solid"`, `"dashed"`, `"dotted"` 等）    | `"solid"`              |
| `show_legend`     | 凡例の表示/非表示                                   | `TRUE`                 |
| `legend_position` | `"right"`, `"top"`, `"bottom"`, `"left"`, `"none"`  | `"right"`              |

### 例: plotICRF_gg のカスタマイズ

``` r
plotICRF_gg(result_grm,
  items = 1,
  title = "ICRFのカスタム表示",
  colors = c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3", "#FF7F00"),
  linetype = "dashed",
  show_legend = TRUE,
  legend_position = "bottom"
)
```

### 例: plotCRV_gg のカスタマイズ

``` r
plotCRV_gg(result_bic,
  title = FALSE,
  linetype = "dotdash",
  show_legend = TRUE,
  legend_position = "top"
)
```

------------------------------------------------------------------------

## 11. combinePlots_gg: 複数プロットの配置

[`combinePlots_gg()`](https://kosugitti.github.io/ggExametrika/reference/combinePlots_gg.md)
は複数のggplotオブジェクトをグリッドレイアウトで配置します。

``` r
# デフォルト: 最初の6つのプロット
plots <- plotICC_gg(result_irt)
combinePlots_gg(plots)

# 特定のプロットを選択
combinePlots_gg(plots, selectPlots = c(1, 3, 5, 7))

# 全15項目
combinePlots_gg(plots, selectPlots = 1:15)
```

------------------------------------------------------------------------

## 関数-モデル対応表

| 関数             | IRT | GRM | LCA | LRA | Biclustering | IRM | LDLRA | LDB | BINET | BNM |
|------------------|:---:|:---:|:---:|:---:|:------------:|:---:|:-----:|:---:|:-----:|:---:|
| plotICC_gg       |  x  |     |     |     |              |     |       |     |       |     |
| plotIIC_gg       |  x  |  x  |     |     |              |     |       |     |       |     |
| plotTIC_gg       |  x  |  x  |     |     |              |     |       |     |       |     |
| plotTRF_gg       |  x  |     |     |     |              |     |       |     |       |     |
| plotICRF_gg      |     |  x  |     |     |              |     |       |     |       |     |
| plotIRP_gg       |     |     |  x  |  x  |              |     |   x   |     |       |     |
| plotFRP_gg       |     |     |     |     |      x       |  x  |       |  x  |   x   |     |
| plotTRP_gg       |     |     |  x  |  x  |      x       |  x  |       |  x  |   x   |     |
| plotLCD_gg       |     |     |  x  |     |              |     |       |     |   x   |     |
| plotLRD_gg       |     |     |     |  x  |      x       |     |   x   |  x  |       |     |
| plotCMP_gg       |     |     |  x  |     |              |     |       |     |   x   |     |
| plotRMP_gg       |     |     |     |  x  |      x       |     |   x   |  x  |       |     |
| plotCRV_gg       |     |     |     |     |      x       |     |       |     |       |     |
| plotRRV_gg       |     |     |     |     |      x       |     |       |     |       |     |
| plotArray_gg     |     |     |     |     |      x       |  x  |       |  x  |   x   |     |
| plotFieldPIRP_gg |     |     |     |     |              |     |       |  x  |       |     |
| plotGraph_gg     |     |     |     |     |              |     |   x   |  x  |   x   |  x  |
