# GRM IIC/TIC テストガイド

## 実行方法

### 1. RStudioでプロジェクトを開く
```r
# ggExametrika.Rprojをダブルクリック
```

### 2. ミニマルテスト（まずこれを実行）
```r
source("develop/minimal_test.R")
```

**期待される結果:**
- Item 1のIICプロットが表示される
- Test Information Curveが表示される
- エラーが出なければ成功

### 3. フルテスト（詳細な動作確認）
```r
source("develop/test_GRM_IIC_TIC.R")
```

**テスト内容:**
1. GRM IIC - 単一アイテム
2. GRM IIC - 複数アイテム (1-3)
3. GRM IIC - カスタムオプション（タイトル、色、線種）
4. GRM IIC - タイトルなし
5. GRM TIC - デフォルト
6. GRM TIC - カスタムオプション
7. IRT IIC - 比較用
8. IRT TIC - 比較用
9. グリッド表示 (2x2)

## トラブルシューティング

### エラー: 関数が見つからない
```r
devtools::load_all()  # パッケージを再読み込み
```

### エラー: データが見つからない
```r
library(exametrika)   # exametrikaパッケージを読み込み
data(J5S1000)         # データを読み込み
```

### ドキュメントを更新
```r
devtools::document()  # roxygen2でドキュメント生成
```

## 実装済み機能

- ✅ `ItemInformationFunc_GRM()` - GRM情報量関数
- ✅ `plotIIC_gg()` - IRT/GRM両対応のIIC
- ✅ `plotTIC_gg()` - IRT/GRM両対応のTIC
- ✅ 共通オプション (title, colors, linetype, show_legend, legend_position)

## 次のステップ

実装完了後は:
1. `devtools::check()` でパッケージチェック
2. `NEWS.md` の確認
3. Git commit & push
