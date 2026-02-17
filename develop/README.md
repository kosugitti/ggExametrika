# Development Test Scripts

このディレクトリには、ggExametrikaパッケージの開発・テスト用スクリプトが含まれています。

## パッケージのロード

開発版のパッケージをロードするには：

```r
# パッケージディレクトリに移動
setwd("c:/Users/kamim/OneDrive/ドキュメント/ggExametrika")

# 自動ロードスクリプトを使用
source("develop/develop_load_package.R")

# または手動で
devtools::document()
devtools::load_all()
```

## テストスクリプト

### 1. `develop_test_all.R` - 総合テスト（推奨）

plotArray_ggの全機能を包括的にテストするスクリプト。

```r
source("develop/develop_test_all.R")
```

**テスト内容:**
- Test 1: 2値データのBiclustering（既存機能）
- Test 2: 多値データのBiclustering（新機能）
- Test 3: Ranklustering（順序構造）
- Test 4: カスタムオプション（色、タイトル等）
- Test 5: エッジケース（5カテゴリ等）

### 2. `develop_test_array_simple.R` - シンプルテスト

基本的な動作確認用の軽量テスト。

```r
source("develop/develop_test_array_simple.R")
```

**生成されるプロット:**
- `plot_binary` - 2値データ
- `plot_multi` - 多値データ（凡例なし）
- `plot_multi_legend` - 多値データ（凡例あり）
- `plot_custom` - カスタムタイトル

### 3. `develop_test_ranklustering.R` - Ranklustering専用

Ranklusteringモデルの詳細テスト。

```r
source("develop/develop_test_ranklustering.R")
```

**生成されるプロット:**
- `plot_rank_binary` - 2値データでのRanklustering
- `plot_rank_multi` - 多値データでのRanklustering
- `plot_rank_legend` - 凡例付きRanklustering
- `plot_bi_multi` - 比較用Biclustering

### 4. `develop_test_array_multivalue.R` - 旧バージョン

初期テストスクリプト（参考用）。

## プロットの表示

テスト実行後、プロットを表示するには変数名を入力：

```r
# 単一プロットの表示
plot_multi_legend

# 複数プロットの並列表示
gridExtra::grid.arrange(plot_binary, plot_multi_legend, ncol = 2)
```

## 注意事項

- このディレクトリの内容は `.Rbuildignore` で除外されており、パッケージビルド時には含まれません
- テストスクリプトは開発・デバッグ専用です
- 本番用のユニットテストは `tests/testthat/` ディレクトリに配置してください

## ファイル一覧

- `develop_load_package.R` - パッケージロード用ヘルパー
- `develop_test_all.R` - 総合テストスイート
- `develop_test_array_simple.R` - シンプルテスト
- `develop_test_ranklustering.R` - Ranklustering専用テスト
- `develop_test_array_multivalue.R` - 旧テストスクリプト
- その他の `*.R` ファイル - 過去の開発用スクリプト
- `README.md` - このファイル
