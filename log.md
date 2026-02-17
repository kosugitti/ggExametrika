# ggExametrika 開発ログ

## 2026-02-17 (続き)

### plotIIC_overlay_gg() 実装 (Daichi)

**目的:** 全てのItem Information Curves (IIC)を1枚のグラフに重ねて表示する関数を実装

**実装内容:**
- `plotIIC_overlay_gg()` を R/ICCtoTIC.R に追加
- plotICC_overlay_gg() と同様の構造で実装
- IRT/GRM両モデルに対応
- ggplot2のgeom_lineを使って複数のアイテム曲線を色分けして表示

**機能:**
- 全アイテムまたは指定したアイテムのIICを1つのグラフにオーバーレイ
- 各アイテムに異なる色を自動割り当て（カラーバリアフリー対応）
- 共通オプションをサポート（title, colors, linetype, show_legend, legend_position）
- 2PL, 3PL, 4PLモデル + GRMに対応
- Y軸: information（情報量）を表示

**IICとは:**
- ICC（正答確率）とは異なり、各アイテムがどの能力範囲で最も精密に測定できるかを示す
- 情報量が高いほど、その能力範囲で精度よく測定可能
- 曲線のピーク = 最も情報を提供する能力範囲

**テスト:**
- develop/test_IIC_overlay.R を作成・更新
- 2PLと3PLモデルでテスト実施
- 全アイテム表示、一部アイテム表示、カスタムカラー、凡例のオン/オフをテスト
- すべてのテストが正常に動作することを確認

**ドキュメント:**
- roxygen2ドキュメント作成（@title, @description, @param, @return, @details, @examples, @seealso）
- NAMESPACEに自動エクスポート追加

**バージョン:**
- DESCRIPTION: 0.0.14 → 0.0.16
- NEWS.md に変更履歴を追加

**ブランチ:**
- feature/next-improvement

**次の課題:**
- プルリクエスト作成（ユーザーの指示待ち）

## 2025-12-10

### 初期セットアップ
- claude.md（開発方針）とlog.md（作業ログ）を作成
- .Rbuildignoreにclaude.md、log.md、README.Rmdを追加
- DESCRIPTIONのSuggestsにExametrikaを追加

### exametrikaとの互換性調査

#### 致命的な問題: クラス名の大文字/小文字

ggExametrikaは `"Exametrika"` (大文字E)をチェックしているが、
現在のexametrikaは `"exametrika"` (小文字e)を使用。

**影響を受ける関数（全関数）:**
- `plotICC_gg`: `class(data) %in% c("Exametrika", "IRT")` → 動作しない
- `plotIIC_gg`: 同上
- `plotTIC_gg`: 同上
- `plotIRP_gg`: `c("Exametrika", "LCA")`, `c("Exametrika", "LRA")`, `c("Exametrika", "LDLRA")` → 動作しない
- `plotFRP_gg`: `c("Exametrika", "Biclustering")`, etc. → 動作しない
- `plotTRP_gg`: 同上
- `plotLCD_gg`: 同上
- `plotLRD_gg`: 同上
- `plotCMP_gg`: 同上
- `plotRMP_gg`: 同上
- `plotArray_gg`: 同上
- `plotFieldPIRP_gg`: 同上

#### 修正方針
全ての `"Exametrika"` を `"exametrika"` に変更する必要あり。

#### exametrikaの現在の出力構造（確認済み）

| クラス | 主要フィールド |
|--------|----------------|
| IRT | params (slope, location, lowerAsym, upperAsym), itemPSD, ability |
| LCA | IRP, TRP, LCD, CMD, Students, Nclass |
| LRA | IRP, IRPIndex, TRP, LRD, RMD, Students, Nrank |
| Biclustering | FRP, FRPIndex, TRP, LRD/LCD, CMD/RMD, Students, U, FieldEstimated, ClassEstimated, Nclass, Nfield |
| IRM | FRP, TRP, LCD, LFD, FieldEstimated, ClassEstimated, Nclass, Nfield |
| LDLRA | IRP, IRPIndex, TRP, LRD, RMD, Students, Nclass, CCRR_table |
| LDB | IRP, FRP, FRPIndex, TRP, LRD, RMD, Students, Nrank, Nfield, CCRR_table |
| BINET | FRP, PSRP, LDPSR, TRP, LCD, CMD, Students, Nclass, Nfield |

**注意**: 新しいexametrikaは一部で命名規則を変更中
- `Nclass` → `n_class` (後方互換性のため両方存在)
- `Nrank` → `n_rank`
- `N_Cycle` → `n_cycle`

ggExametrikaが使用している `Nclass`, `Nrank` などは後方互換性フィールドとして残っているため、フィールドアクセス自体は問題なし。

### クラス名修正完了

全Rファイルで `"Exametrika"` → `"exametrika"` に修正:
- `R/ICCtoTIC.R`
- `R/IRPtoCMPRMP.R`
- `R/arraytoLDPSR.R`

### GitHub Pages (pkgdown) 設定

- `_pkgdown.yml` 作成（サイト設定、リファレンス構成）
- `.github/workflows/pkgdown.yaml` 作成（GitHub Actions自動デプロイ）
- `.Rbuildignore` に pkgdown関連を追加
- DESCRIPTIONのSuggests: `Exametrika` → `exametrika` (CRANパッケージ名は小文字)
- GitHub Pages有効化完了
- サイト公開: https://kosugitti.github.io/ggExametrika/

### コードスタイル整備
- `styler::style_pkg()` を適用
- `README.Rmd` の `library(Exametrika)` → `library(exametrika)` に修正
- `README.md` を再生成

### ヘルプドキュメント拡充
- 全関数に `@return`, `@details`, `@examples`, `@seealso` を追加
- `@seealso` はパッケージ内の関数のみを参照（外部参照は削除）
- 対象ファイル:
  - `R/ICCtoTIC.R`: plotICC_gg, LogisticModel, ItemInformationFunc, plotIIC_gg, plotTIC_gg
  - `R/IRPtoCMPRMP.R`: plotIRP_gg, plotFRP_gg, plotTRP_gg, plotLCD_gg, plotLRD_gg, plotCMP_gg, plotRMP_gg
  - `R/arraytoLDPSR.R`: plotArray_gg, plotFieldPIRP_gg
  - `R/option.R`: combinePlots_gg
- `devtools::document()` で man/*.Rd ファイル更新（15ファイル）
- `styler::style_pkg()` で再フォーマット

### 本日の作業サマリー
1. 開発環境整備（claude.md, log.md）
2. exametrikaとの互換性修正（クラス名を小文字に統一）
3. GitHub Pages自動デプロイ設定
4. v1.0ロードマップ作成（8つの未実装機能を特定）
5. コードスタイル整備（styler適用）
6. 全関数のヘルプドキュメント拡充

**次回の課題**: v1.0に向けた未実装プロット機能の実装

## 2026-02-17

### TRF関数の実装
- `plotTRF_gg()` を `R/ICCtoTIC.R` に追加
- 各アイテムのICC（LogisticModel）を合算し、期待得点曲線を描画
- plotTIC_ggと同じ構造で、情報関数の代わりに正答確率を合算
- roxygen2ドキュメント・NAMESPACE更新済み
- サンプル実行で動作確認済み（J15S500, 3PLモデル）

### バージョン更新
- DESCRIPTION: 0.0.9 → 0.0.10
- NEWS.md: 全バージョンの変更履歴を整理・充実化
- CLAUDE.md: v1.0.0方針（合宿中リリース目標）、3名体制の共同開発ルールを追記

### 次回の課題
- 未実装プロット機能の実装（CRV/RRV, LDPSR, ScoreFreq, ScoreRank, ICRP, ICBR, GRM対応）
- DAG可視化のテストと visNetwork版の実装

---

## 2025-12-12

### DAG可視化関数の開発開始

#### 調査結果: plot.exametrikaの全プロットタイプ

**実装済み（ggExametrika）:**
- plotICC_gg, plotIIC_gg, plotTIC_gg (IRT)
- plotIRP_gg, plotFRP_gg, plotTRP_gg
- plotLCD_gg, plotLRD_gg, plotCMP_gg, plotRMP_gg
- plotArray_gg, plotFieldPIRP_gg

**未実装（plot.exametrikaにある）:**
1. TRF (Test Response Function) - IRT
2. CRV/RRV (Class/Rank Reference Vector) - Biclustering
3. LDPSR (Latent Dependence Passing Student Rate) - BINET
4. ScoreFreq - LRAordinal, LRArated
5. ScoreRank - LRAordinal, LRArated
6. ICRP (Item Category Reference Profile) - LRAordinal, LRArated
7. ICBR (Item Category Boundary Response) - LRAordinal

**未実装（print.exametrikaでigraph使用）:**
1. BNM - DAGの可視化
2. LDLRA - ランク/クラスごとのDAG
3. LDB - ランクごとのDAG
4. BINET - 統合グラフ（edge label付き）

#### 実施した作業

1. DESCRIPTIONに `ggraph`, `igraph` をImportsに追加
2. `R/plotGraph_gg.R` を新規作成（BNM, LDLRA, LDB, BINET対応）
3. ggraphパッケージをインストール

#### DAG可視化の開発方針（決定事項）

**2段階アプローチ:**
1. `plotGraph_interactive()` - visNetworkでインタラクティブ編集版
   - ノードをドラッグして位置調整可能
   - 編集後の座標を取得可能
2. `plotGraph_gg()` - ggraphで静的ggplotオブジェクト版
   - インタラクティブ版で決めた座標を渡して清書

**理由:** ユーザーがノードの配置を手動で調整したい場合があるため、
visNetworkで大体の配置を決めてから、ggraphで最終的な静的プロットを生成する流れ。

#### 次回の作業

1. visNetworkを使った `plotGraph_interactive()` の実装
2. 座標取得→ggraphへの受け渡し機能
3. plotGraph_gg関数のテスト
4. ドキュメント整備

---

## 2026-02-17 (Daichi Kamimura)

### plotArray_ggの多値対応実装

#### 作業概要
Biclustering系のplotArray_gg関数を、2値データ（0/1）だけでなく、多値データ（ordinal/nominal Biclustering）にも対応させる実装を完了。

#### 実装内容

1. **親パッケージの調査**
   - exametrikaの `00_exametrikaPlot.R` 内の `array_plot()` 関数を調査
   - 既に多値対応の実装があることを確認
   - カテゴリ数の自動検出と色パレットの切り替えロジックを参考

2. **plotArray_gg関数の拡張**
   - カテゴリの自動検出: `sort(unique(as.vector(as.matrix(raw_data))))`
   - 2値データ: 白(#FFFFFF)と黒(#000000)を使用
   - 多値データ: カラーブラインドフレンドリーなパレット（最大20色）を使用
   - `scale_fill_gradient2` から `scale_fill_manual` に変更し、離散的な色を適用

3. **共通オプションの追加**
   - `title`: logical または character（TRUE=自動タイトル、FALSE=非表示、文字列=カスタムタイトル）
   - `colors`: カスタム色パレット（NULL=自動選択）
   - `show_legend`: 凡例の表示/非表示（NULL=自動、2値はFALSE、多値はTRUE）
   - `legend_position`: 凡例の位置（"right", "top", "bottom", "left", "none"）

4. **対応モデルの拡張**
   - Biclustering（既存）
   - **nominalBiclustering**（新規）
   - **ordinalBiclustering**（新規）
   - IRM, LDB, BINET（既存）

5. **ドキュメントの更新**
   - roxygen2コメントを更新し、多値対応を明記
   - 例とパラメータの説明を充実化
   - `@importFrom` 文を更新（`scale_fill_manual`, `element_text`, `element_blank`を追加）

6. **バージョン管理**
   - DESCRIPTION: 0.0.13 → 0.0.14
   - NEWS.md: 新バージョンのエントリを追加
   - log.md: 本エントリを追加

#### 技術的な変更点

**Before (2値専用):**
```r
bw <- c(!(data$U))  # 0/1を反転
scale_fill_gradient2(low = "black", high = "white", ...)
```

**After (多値対応):**
```r
response_val <- as.vector(as.matrix(raw_data))
all_values <- sort(unique(response_val))
n_categories <- length(all_values)
plot_data$value <- factor(response_val, levels = all_values)
scale_fill_manual(values = setNames(use_colors, all_values), ...)
```

#### 次回の課題

1. **動作確認**
   - Rセッションで実際にordinalBiclustering/nominalBiclusteringのデータでテスト
   - 視覚的な確認（色の配置、凡例の表示）
   - エッジケースのテスト（カテゴリ数が10を超える場合など）

2. **他の関数への共通オプション追加**
   - plotICC_gg, plotIIC_gg, plotTIC_gg, plotTRF_ggなど既存関数への共通オプション適用
   - CLAUDE.mdのTODOリストを参照

3. **多値版モデルの動作確認**
   - FRP, LCD, LRD, CMP, RMP, Arrayの各関数で多値データのテスト
   - nominalBiclustering, ordinalBiclusteringの全プロットタイプの動作確認

---

## 2026-02-17 (Daichi Kamimura) - 続き

### plotArray_ggの追加修正と検証

#### 視覚的な問題の修正

1. **タイトルの重なり問題**
   - フォントサイズを11pxに縮小
   - マージンを `margin(t = 5, b = 5)` に調整
   - 問題解決

2. **境界線のオーバーフロー**
   - `scale_x_continuous(expand = c(0, 0), limits = ...)` を追加
   - `scale_y_continuous(expand = c(0, 0), limits = ...)` を追加
   - プロット領域を厳密に制御し、線がはみ出さないように修正

3. **境界線の色のカスタマイズ**
   - `Clusterd_lines_color` パラメータを追加（デフォルト: 白）
   - ユーザーが任意の色を指定可能に

4. **境界線の位置ずれ**
   - 座標計算を `h + 0.5`, `v + 0.5` に修正
   - セルとセルの境界に正確に配置されるように調整

5. **境界線のデフォルト色を2値/多値で自動切り替え**
   - 2値データ（0/1）: 赤色（視認性向上）
   - 多値データ（3+カテゴリ）: 白色
   - `Clusterd_lines_color = NULL` の場合に自動判定

#### ソート順序の重大な修正（CRITICAL FIX）

exametrikaの元実装と比較した結果、行のソート順序が逆になっていることが判明。

**問題:**
- ggExametrika: `order(ClassEstimated, decreasing = TRUE)`
- exametrika: `order(ClassEstimated, decreasing = FALSE)`

**修正内容:**
```r
# Before
sorted <- sorted[order(data$ClassEstimated, decreasing = TRUE), ]
rown <- rep(1:nrow(sorted), ncol(sorted))

# After
case_order <- order(data$ClassEstimated, decreasing = FALSE)
field_order <- order(data$FieldEstimated, decreasing = FALSE)
sorted <- raw_data[case_order, field_order]
rown <- rep(nrow(sorted):1, ncol(sorted))  # 逆順で視覚的に正しい配置
```

**結果:**
- 高いクラス番号（高い能力）が下に表示される
- 低いクラス番号（低い能力）が上に表示される
- exametrikaの元実装と完全に一致

**境界線の計算も調整:**
```r
h_adjusted <- nrow(sorted) - h
geom_hline(yintercept = h_adjusted + 0.5, ...)
```

#### 欠測値（-1）の特別処理

exametrikaでは-1が欠測値として使用されることが判明。

**実装内容:**
1. -1を有効値と分離して検出
2. -1に黒色（#000000）を割り当て
3. 凡例では「NA」と表示
4. 他の値は通常のカラーパレットを適用

**コード:**
```r
has_missing <- -1 %in% all_values
valid_values <- all_values[all_values != -1]

# -1に黒色を割り当て
if (all_values[i] == -1) {
  use_colors[i] <- "#000000"
}

# 凡例のラベル
value_labels <- ifelse(all_values == -1, "NA", as.character(all_values))

# scale_fill_manualで適用
scale_fill_manual(
  values = setNames(use_colors, all_values),
  labels = value_labels,
  ...
)
```

#### テストスクリプトの整理

developディレクトリのスクリプトが増えすぎたため、整理を実施。

**削除したファイル（この会話で作成した一時ファイル）:**
- develop_compare_with_original.R
- develop_side_by_side_comparison.R
- develop_test_poly_biclustering.R
- develop_verify_sorting.R
- test_missing_values.R

**統合されたテストスクリプト（compare_simple.R）:**
```r
# Test 1: J15S3810（多値データ）
# Test 2: 欠測値（-1）を含むデータ
# 本家exametrikaとggExametrikaを比較
```

#### バージョン管理

- NEWS.md: 全ての修正内容を記録
  - 多値データ対応
  - 共通オプション追加
  - 境界線色のカスタマイズ
  - 欠測値の特別処理
  - **CRITICAL FIX**: ソート順序の修正
- DESCRIPTION: 0.0.14（変更なし）

#### 検証結果

1. **J15S3810データでの検証**
   - 本家とggExametrikaのプロットパターンが一致
   - 境界線の位置が正確
   - 多値の色パレットが正しく適用

2. **欠測値を含むデータでの検証**
   - -1が「NA」として凡例に表示
   - 黒色で視覚的に識別可能
   - 他の値のカラーパレットに影響なし

3. **ソート順序の検証**
   - 高いクラス番号が下、低いクラス番号が上に正しく配置
   - exametrikaの元実装と完全に一致

#### 次回の課題

1. **ユニットテストの充実**
   - testthatで欠測値処理のテストを追加
   - ソート順序の自動テスト

2. **他のプロット関数への共通オプション追加**
   - CLAUDE.mdのTODOリストを参照

3. **v1.0.0に向けた未実装機能**
   - CRV/RRV, LDPSR, ScoreFreq, ScoreRank, ICRP, ICBR
   - GRM対応（IIC, TIC）
   - DAG可視化
