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

## クイックスタート

``` r
library(exametrika)
library(ggExametrika)
```

### IRT: 項目特性曲線 (ICC)

``` r
# 2PLモデルの実行
result_irt <- IRT(J15S500, model = 2)

# 全項目のICCをプロット
plots <- plotICC_gg(result_irt)
plots[[1]]  # 1番目の項目を表示

# 複数プロットをグリッド配置
combinePlots_gg(plots, selectPlots = 1:6, ncol = 3)
```

### IRT: 項目情報曲線・テスト情報曲線

``` r
# 項目情報曲線
iic_plots <- plotIIC_gg(result_irt)
combinePlots_gg(iic_plots, selectPlots = 1:6, ncol = 3)

# テスト情報曲線
tic_plot <- plotTIC_gg(result_irt)
tic_plot

# テスト応答関数
trf_plot <- plotTRF_gg(result_irt)
trf_plot
```

### GRM: 項目カテゴリ応答関数 (ICRF)

``` r
# 段階反応モデルの実行
result_grm <- GRM(J5S1000)

# 全項目のICRFをプロット
icrf_plots <- plotICRF_gg(result_grm)
icrf_plots[[1]]

# GRMでもIIC・TICが利用可能
iic_grm <- plotIIC_gg(result_grm)
tic_grm <- plotTIC_gg(result_grm)
```

### 潜在クラス分析 (LCA)

``` r
result_lca <- LCA(J15S500, ncls = 3)

# 項目参照プロファイル
irp_plots <- plotIRP_gg(result_lca)
combinePlots_gg(irp_plots)

# フィールド参照プロファイル
frp_plot <- plotFRP_gg(result_lca)
frp_plot

# テスト参照プロファイル
trp_plot <- plotTRP_gg(result_lca)
trp_plot

# 潜在クラス分布
lcd_plot <- plotLCD_gg(result_lca)
lcd_plot

# クラスメンバーシッププロファイル
cmp_plot <- plotCMP_gg(result_lca)
cmp_plot
```

### 潜在ランク分析 (LRA)

``` r
result_lra <- LRA(J15S500, nrank = 4)

# 項目・フィールド・テスト参照プロファイル
irp_plots <- plotIRP_gg(result_lra)
frp_plot <- plotFRP_gg(result_lra)
trp_plot <- plotTRP_gg(result_lra)

# 潜在ランク分布
lrd_plot <- plotLRD_gg(result_lra)
lrd_plot

# ランクメンバーシッププロファイル
rmp_plot <- plotRMP_gg(result_lra)
rmp_plot
```

### バイクラスタリング

``` r
result_bic <- Biclustering(J15S500, nfld = 3, nrank = 4)

# クラス・ランク参照ベクトル
crv_plot <- plotCRV_gg(result_bic)
crv_plot

rrv_plot <- plotRRV_gg(result_bic)
rrv_plot

# 配列プロット（ソート済みデータ行列）
array_plot <- plotArray_gg(result_bic)
array_plot
```

### ベイジアンネットワークモデル (BNM) - DAG可視化

``` r
result_bnm <- BNM(J15S500)

# DAG可視化
dag_plot <- plotGraph_gg(result_bnm)
dag_plot
```

## 共通プロットオプション

多くのプロット関数で以下のオプションが利用可能です：

| パラメータ        | 説明                                                | デフォルト             |
|-------------------|-----------------------------------------------------|------------------------|
| `title`           | `TRUE`（自動生成）、`FALSE`（非表示）、または文字列 | `TRUE`                 |
| `colors`          | 線や棒グラフの色ベクトル                            | 色覚多様性対応パレット |
| `linetype`        | 線の種類（`"solid"`、`"dashed"` 等）                | `"solid"`              |
| `show_legend`     | 凡例の表示                                          | `TRUE`                 |
| `legend_position` | `"right"`、`"top"`、`"bottom"`、`"left"`、`"none"`  | `"right"`              |

使用例：

``` r
plotICC_gg(result_irt,
  title = "カスタムタイトル",
  colors = c("red", "blue"),
  linetype = "dashed",
  show_legend = FALSE
)
```

## 関数一覧

### IRT (2PL, 3PL, 4PL)

| 関数                                                                               | 説明                                     |
|------------------------------------------------------------------------------------|------------------------------------------|
| [`plotICC_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotICC_gg.md) | 項目特性曲線 (Item Characteristic Curve) |
| [`plotIIC_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotIIC_gg.md) | 項目情報曲線 (Item Information Curve)    |
| [`plotTIC_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotTIC_gg.md) | テスト情報曲線 (Test Information Curve)  |
| [`plotTRF_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotTRF_gg.md) | テスト応答関数 (Test Response Function)  |

### GRM (段階反応モデル)

| 関数                                                                                 | 説明                                                   |
|--------------------------------------------------------------------------------------|--------------------------------------------------------|
| [`plotICRF_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotICRF_gg.md) | 項目カテゴリ応答関数 (Item Category Response Function) |
| [`plotIIC_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotIIC_gg.md)   | 項目情報曲線（GRM版）                                  |
| [`plotTIC_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotTIC_gg.md)   | テスト情報曲線（GRM版）                                |

### 潜在クラス・ランクモデル

| 関数                                                                               | 説明                                                        |
|------------------------------------------------------------------------------------|-------------------------------------------------------------|
| [`plotIRP_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotIRP_gg.md) | 項目参照プロファイル (Item Reference Profile)               |
| [`plotFRP_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotFRP_gg.md) | フィールド参照プロファイル (Field Reference Profile)        |
| [`plotTRP_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotTRP_gg.md) | テスト参照プロファイル (Test Reference Profile)             |
| [`plotLCD_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotLCD_gg.md) | 潜在クラス分布 (Latent Class Distribution)                  |
| [`plotLRD_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotLRD_gg.md) | 潜在ランク分布 (Latent Rank Distribution)                   |
| [`plotCMP_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotCMP_gg.md) | クラスメンバーシッププロファイル (Class Membership Profile) |
| [`plotRMP_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotRMP_gg.md) | ランクメンバーシッププロファイル (Rank Membership Profile)  |

### バイクラスタリング

| 関数                                                                                           | 説明                                        |
|------------------------------------------------------------------------------------------------|---------------------------------------------|
| [`plotCRV_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotCRV_gg.md)             | クラス参照ベクトル (Class Reference Vector) |
| [`plotRRV_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotRRV_gg.md)             | ランク参照ベクトル (Rank Reference Vector)  |
| [`plotArray_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotArray_gg.md)         | 配列プロット (Array Plot)                   |
| [`plotFieldPIRP_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotFieldPIRP_gg.md) | フィールドPIRPプロット (Field PIRP Plot)    |

### DAG可視化

| 関数                                                                                   | 説明                                      |
|----------------------------------------------------------------------------------------|-------------------------------------------|
| [`plotGraph_gg()`](https://kosugitti.github.io/ggExametrika/reference/plotGraph_gg.md) | 有向非巡回グラフ (Directed Acyclic Graph) |

### ユーティリティ

| 関数                                                                                                         | 説明                            |
|--------------------------------------------------------------------------------------------------------------|---------------------------------|
| [`combinePlots_gg()`](https://kosugitti.github.io/ggExametrika/reference/combinePlots_gg.md)                 | 複数プロットのグリッド配置      |
| [`LogisticModel()`](https://kosugitti.github.io/ggExametrika/reference/LogisticModel.md)                     | 4パラメータロジスティックモデル |
| [`ItemInformationFunc()`](https://kosugitti.github.io/ggExametrika/reference/ItemInformationFunc.md)         | IRT項目情報関数                 |
| [`ItemInformationFunc_GRM()`](https://kosugitti.github.io/ggExametrika/reference/ItemInformationFunc_GRM.md) | GRM項目情報関数                 |
