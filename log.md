# ggExametrika 開発ログ

## 2026-02-18

### plotFRP_gg() 多値対応実装 (Claude Sonnet 4.5)

**目的:** plotFRP_gg()に多値データ（ordinalBiclustering, nominalBiclustering）対応を追加

**実装内容:**
- 既存の2値データ対応を維持しつつ、多値データに完全対応
- `stat` パラメータ追加: "mean" (重み付き平均), "median" (中央値), "mode" (最頻値)
- 共通オプション完全対応: title, colors, linetype, show_legend, legend_position
- 返り値を変更: リスト → 単一のggplotオブジェクト（全フィールドを1つのグラフに）
- データ型の自動判定: dim(data$FRP)が2次元なら2値、3次元なら多値

**技術的詳細:**
- 2値データ: FRP[field, class] から正解率を直接プロット
- 多値データ: BCRM[field, class, category] から期待得点を計算
  - mean: sum(categories × probs) - カテゴリの重み付き平均
  - median: min(which(cumsum(probs) >= 0.5)) - 累積確率50%のカテゴリ
  - mode: which.max(probs) - 最も確率の高いカテゴリ

**対応モデル:**
- 2値: Biclustering, IRM, LDB, BINET
- 多値: ordinalBiclustering, nominalBiclustering

**テスト:**
- develop/test_FRP_multivalue.R を作成（232行の包括的テスト）
- Test 1: Binary Biclustering（4パターン）
- Test 2: Ordinal Biclustering（mean/median/mode + 比較）
- Test 3: Nominal Biclustering
- Test 5: エラーハンドリング（無効なパラメータ検証）
- Test 6: 共通オプション全組み合わせ
- 全テストパス確認済み

**ドキュメント:**
- roxygen2ドキュメント全面改訂
- 2値・多値両対応の詳細な説明追加
- statパラメータの使い分けを明記
- 実例コード追加（binary/ordinal両方）

**ブランチ:**
- feature/frp-multivalue (4コミット)
- e8b5bf9: 本体実装
- a747899: テスト追加
- f95152f: devtools::load_all追加
- 7c1f986: dataFormat修正

**次回の課題:**
- FCRP (Field Category Response Profile) 実装
- ScoreField (期待得点ヒートマップ) 実装
- RRVの多値対応（stat パラメータ追加）

---

### plotFCBR_gg() 実装 (kamimura)

**目的:** ordinalBiclustering モデル用のField Cumulative Boundary Reference (FCBR) を可視化する関数を実装

**実装内容:**
- `plotFCBR_gg()` を新規作成（R/plotFCBR_gg.R）
- フィールドごとの境界確率曲線（P(Q>=1), P(Q>=2), P(Q>=3), ...）を**全て**表示
- exametrika v1.9.0 の FCBR プロットタイプに対応
- exametrika-dev の `plot_poly_fcbr()` 関数を参考にしたが、P(Q>=1)も表示するよう改良
- **重要な変更**: 元のexametrika-devではP(Q>=1)を省略していたが、ggExametrikaでは全境界を表示

**機能:**
- 各フィールドの境界確率曲線を facet_wrap でサブプロット表示
- 境界確率の計算: P(Q >= q) = sum(BCRM[f, cc, q:maxQ])
- **P(Q>=1)は常に1.0** なので水平線（y=1.0）として表示される
- 共通オプション完全対応（title, colors, linetype, show_legend, legend_position）
- ordinalBiclustering 専用（境界確率は順序尺度でのみ意味を持つため）
- データソース: `data$FRP`（3次元配列: フィールド × クラス/ランク × カテゴリ）

**テスト:**
- test_fcbr.R を作成して動作確認
- J15S3810データを使用してordinalBiclusteringを実行（ncls=4, nfld=3）
- FRPデータの次元確認: [3フィールド, 4クラス, 3カテゴリ]
- プロット正常作成を確認

**ドキュメント:**
- roxygen2ドキュメント作成（@title, @description, @param, @return, @details, @examples, @seealso）
- NAMESPACEに自動エクスポート追加
- man/plotFCBR_gg.Rd 生成

**バージョン:**
- DESCRIPTION: 0.0.19 → 0.0.20
- NEWS.md に変更履歴を追加
- CLAUDE.md の実装状況表を更新（FCBR: 未実装 → 実装済）

**次回の課題:**
- 残りの多値バイクラスタリングプロット実装（FCRP, ScoreField）
- 多値版FRP/RRV対応（stat パラメータ: mean/median/mode）
- 既存関数の共通オプション対応継続

---

## 2026-02-17

### plotScoreFreq_gg() 実装 (arimune01)

**目的:** LRAordinal/LRArated モデル用のスコア頻度分布を可視化する関数を実装

**実装内容:**
- `plotScoreFreq_gg()` を新規作成（R/LRAordinal.R）
- スコアの密度分布曲線と潜在ランク間の閾値線（破線）を1枚のプロットで表示
- exametrika の ScoreFreq プロットタイプに対応

**機能:**
- スコアの密度分布（geom_density）と閾値の垂直線（geom_vline）を同時表示
- 閾値計算: ランク i の最大スコアとランク i+1 の最小スコアの中点
- 共通オプション完全対応（title, colors, linetype, show_legend, legend_position）
- LRAordinal, LRArated 専用（IRT, Biclustering等ではエラー）

**テスト:**
- develop/test_ScoreFreq.R を作成
- LRAordinal / LRArated 両方でテスト実施
- 全アイテム表示、共通オプション、エラーハンドリングをテスト

**ドキュメント:**
- roxygen2ドキュメント作成（@title, @description, @param, @return, @details, @examples, @seealso）
- NAMESPACEに自動エクスポート追加

**バージョン:**
- DESCRIPTION: 0.0.13 → 0.0.14 → 0.0.15（マージ調整）
- NEWS.md に変更履歴を追加
- claude.md の実装状況表を更新

---

### plotICC_overlay_gg() 実装 (castella3)

**目的:** 全てのItem Characteristic Curves (ICC)を1枚のグラフに重ねて表示する関数を実装

**実装内容:**
- `plotICC_overlay_gg()` を R/ICCtoTIC.R に追加
- 本家exametrika の `plot(IRT_result, type = "IRF", overlay = TRUE)` の動作を参考に実装
- exametrikaのplot.exametrika関数（R/00_exametrikaPlot.R:655-683行目）のplotIRTCurve関数を参照
- ggplot2のgeom_lineを使って複数のアイテム曲線を色分けして表示

**機能:**
- 全アイテムまたは指定したアイテムのICCを1つのグラフにオーバーレイ
- 各アイテムに異なる色を自動割り当て（カラーバリアフリー対応）
- 共通オプションをサポート（title, colors, linetype, show_legend, legend_position）
- 2PL, 3PL, 4PLモデルに対応（IRT専用）

**ICC vs IIC の違い:**
- **ICC**: 正答確率を示す曲線（y軸: 0〜1の確率）
- **IIC**: 情報量を示す曲線（y軸: 情報量）

**テスト:**
- develop/test_ICC_overlay.R を作成
- 2PLと3PLモデルでテスト実施
- 全アイテム表示、一部アイテム表示、カスタムカラー、凡例のオン/オフをテスト
- すべてのテストが正常に動作することを確認

**ドキュメント:**
- roxygen2ドキュメント作成（@title, @description, @param, @return, @details, @examples, @seealso）
- NAMESPACEに自動エクスポート追加

**バージョン:**
- DESCRIPTION: 0.0.14 → 0.0.15 → 0.0.16（マージ調整）
- NEWS.md に変更履歴を追加
- claude.md の実装状況表を更新

---

### plotIIC_overlay_gg() 実装 (castella3)

**目的:** 全てのItem Information Curves (IIC)を1枚のグラフに重ねて表示する関数を実装

**実装内容:**
- `plotIIC_overlay_gg()` を R/ICCtoTIC.R に追加
- plotICC_overlay_gg() と同様の構造で実装
- IRT（2PL, 3PL, 4PL）と GRM の両モデルに対応
- 本家exametrika の `plot(IRT_result, type = "IIF", overlay = TRUE)` 相当

**機能:**
- 全アイテムまたは指定したアイテムのIICを1つのグラフにオーバーレイ
- 各アイテムに異なる色を自動割り当て（カラーバリアフリー対応）
- 共通オプションをサポート（title, colors, linetype, show_legend, legend_position）
- IRT + GRM 両対応（既存のplotIIC_ggと同じ設計）
- Y軸: information（情報量）を表示

**IICの意味:**
- ICC（正答確率）とは異なり、各アイテムがどの能力範囲で最も精密に測定できるかを示す
- 情報量が高いほど、その能力範囲で精度よく測定可能
- 曲線のピーク = 最も情報を提供する能力範囲

**IRT vs GRM の情報関数:**
- **IRT**: `I(θ) = [a²(P-c)(d-P)(Pd-c)] / [(d-c)²P(1-P)]`
- **GRM**: `I(θ) = a² Σ P*ₖ(1-P*ₖ)` （ItemInformationFunc_GRM使用）

**テスト:**
- develop/test_IIC_overlay.R を作成
- 2PLと3PLモデル（IRT）でテスト実施
- GRMモデルでもテスト可能
- 全アイテム表示、一部アイテム表示、カスタムカラー、凡例のオン/オフをテスト
- すべてのテストが正常に動作することを確認

**ドキュメント:**
- roxygen2ドキュメント作成（@title, @description, @param, @return, @details, @examples, @seealso）
- IICの説明（情報量曲線 vs 確率曲線）を明記
- NAMESPACEに自動エクスポート追加

**バージョン:**
- DESCRIPTION: 0.0.14 → 0.0.16 → 0.0.17（マージ調整）
- NEWS.md に変更履歴を追加
- claude.md の実装状況表を更新

**設計の妥当性:**
- plotICC_overlay_gg: IRT専用（正しい - ICCは二値データ用）
- plotIIC_overlay_gg: IRT + GRM両対応（正しい - 情報量は統一概念）
- plotICRF_overlay_gg: 未実装（GRM専用のICRF overlay版は将来的に検討可能）

---

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

---

## 2026-02-17 (Feature: ICBR)

### plotICBR_ggの実装完了

#### 作業概要
LRAordinal専用のICBR（Item Category Boundary Response）プロット関数を実装。
カテゴリ境界を超える累積確率曲線をランクごとに可視化する機能を追加。

#### 実装内容

1. **新規ファイル作成**
   - `R/LRAordinal.R` - plotICBR_gg() 関数（183行）
   - `develop/explore_ICBR.R` - データ構造調査スクリプト
   - `develop/test_ICBR.R` - 包括的なテストスクリプト

2. **データ構造の調査と理解**
   - exametrikaのICBRデータ: ItemLabel, CategoryLabel, rank1, rank2, ...
   - Wide形式からLong形式への変換（tidyr::pivot_longer使用）
   - CategoryLabelから項目名プレフィックスを除去して色パレット問題を解決

3. **ランク順序の調整（重要な修正）**
   - **問題**: exametrikaのデータではrank1が低能力、rank4が高能力
   - **期待**: X軸1→4で能力上昇、確率も上昇（右肩上がり）
   - **解決**: ランクを逆順に変換（`n_ranks - Rank + 1`）
   - **結果**: 右肩上がりのプロット実現

4. **スタイルの統一**
   - Y軸: `scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.25))`
   - テーマ: ggplot2デフォルトテーマ（他の関数と一貫性）
   - `theme_minimal()` を削除、`facet_wrap(scales = "free_y")` から固定Y軸に変更

5. **共通オプション対応**
   - `title`: TRUE/FALSE/カスタム文字列
   - `colors`: NULL=デフォルトパレット、指定でカスタム
   - `linetype`: NULL=自動、指定でカスタム
   - `show_legend`: TRUE/FALSE
   - `legend_position`: "right", "top", "bottom", "left", "none"

6. **依存関係の追加**
   - DESCRIPTIONのImportsに `tidyr` を追加（pivot_longer用）

#### 技術的な課題と解決

**課題1: 色パレット不足エラー**
```
Error: Insufficient values in manual scale. 16 needed but only 4 provided.
```
- **原因**: CategoryLabelが項目ごとに異なる（V1-Cat1, V2-Cat1, ...）
- **解決**: CategoryLabelから項目名を除去（"V1-Cat1" → "Cat1"）
- **結果**: 全項目で同じカテゴリラベルを共有、4色で対応可能

**課題2: プロットの向き（右肩下がり vs 右肩上がり）**
- **原因**: exametrikaのランク番号と能力の関係
- **解決**: ランクを逆順に変換
- **検証**: ユーザー確認により、ランクは大きいほど高能力と判明

#### バージョン管理

- DESCRIPTION: 0.0.14 → 0.0.15
- NEWS.md: v0.0.15エントリ追加
- claude.md: 実装状況表を更新（ICBR: 未実装 → 実装済み）

#### Git管理

- ブランチ: `feature/icbr`
- コミット: 50e5d03 "Add plotICBR_gg for Item Category Boundary Response visualization"
- リモート: https://github.com/kosugitti/ggExametrika/pull/new/feature/icbr

#### 動作確認

- 基本動作: ✓ 複数項目の表示、右肩上がりの曲線
- 共通オプション: ✓ title, colors, linetype, show_legend, legend_position
- スタイル統一: ✓ Y軸0〜1、0.25刻み、デフォルトテーマ
- エラーハンドリング: ✓ LRArated, IRT, Biclusteringで適切にエラー

#### 次回の課題

1. **未実装プロットタイプ**
   - ScoreRank（スコア-ランクヒートマップ）- LRAordinal, LRArated
   - ICRP（Item Category Reference Profile）- LRAordinal, LRArated
   - LDPSR（Latent Dependence Passing Student Rate）- BINET

2. **既存関数への共通オプション追加**
   - CLAUDE.mdのTODOリスト参照（16関数）

3. **多値版モデルの動作確認**
   - nominalBiclustering, ordinalBiclustering

---

## 2026-02-17

### ICRP (Item Category Reference Profile) 実装 - plotICRP_gg

担当: Claude

#### 実装概要

exametrika の `LRAordinal` および `LRArated` モデルの ICRP データを可視化する関数を実装しました。ICRPは各カテゴリの応答確率を表示し、各ランクで確率の合計が1.0になります。これは累積確率を表示するICBRとは対照的です。

#### 実装内容

1. **新規関数: plotICRP_gg**
   - ファイル: `R/LRAordinal.R`（plotICBR_ggと同じファイル）
   - 対応モデル: LRAordinal, LRArated
   - 返り値: ggplotオブジェクト（facet_wrapによる複数項目表示）

2. **関数の特徴**
   - ICBRとの違い: 応答確率（P(response = k | rank)）を表示
   - 各ランクで全カテゴリの確率合計が1.0
   - LRAordinalとLRArated両方に対応
   - 完全な共通オプション対応（title, colors, linetype, show_legend, legend_position）

3. **データ構造**
   - `data$ICRP`: ItemLabel, CategoryLabel, rank1, rank2, ...
   - ICBRと同じ形式だが、意味が異なる（累積 vs 応答）
   - カテゴリラベルの正規化（"V1-Cat1" → "Cat1"）でパレット問題を解決

4. **開発ファイル**
   - `develop/explore_ICRP.R`: ICRPデータ構造の調査、ICBRとの比較
   - `develop/test_ICRP.R`: 包括的テストスクリプト（10セクション）

#### Y軸自動スケーリング対応

ユーザーフィードバックに基づき、plotICBR_ggとplotICRP_gg両方のY軸を修正：

- **変更前**: `scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.25))`
- **変更後**: `scale_y_continuous(breaks = seq(0, 1, 0.25))`
- **理由**: データ範囲に応じた自動調整で、柔軟な可視化を実現

#### バージョン管理

- DESCRIPTION: 0.0.15 → 0.0.16
- NEWS.md: v0.0.16エントリ追加（ICRP実装 + Y軸自動スケーリング）
- claude.md: 実装状況表を更新（ICRP: 未実装 → 実装済み）

#### Git管理

- ブランチ: `feature/icrp`（feature/icbrから派生）
- 理由: ICBRの実装を含む必要があったため

#### 動作確認（予定）

テストスクリプト `develop/test_ICRP.R` で以下を確認予定：
1. 基本動作（LRAordinal, LRArated両対応）
2. 共通オプション（title, colors, linetype, show_legend, legend_position）
3. Y軸自動スケーリング
4. ICRPとICBRの比較（同じ項目で累積vs応答の違い）
5. エラーハンドリング（IRT, Biclustering等）

#### ICBRとICRPの関係

数学的関係:
```
ICBR(Cat_i) = Σ ICRP(Cat_j) for j >= i
```

視覚的違い:
- **ICBR**: 累積確率、単調減少、カテゴリ0は常に1.0
- **ICRP**: 応答確率、ピークを持つ山型、合計1.0

#### 次回の課題

1. **未実装プロットタイプ（残り3つ）**
   - ScoreRank（スコア-ランクヒートマップ）- LRAordinal, LRArated
   - LDPSR（Latent Dependence Passing Student Rate）- BINET

2. **既存関数への共通オプション追加**
   - CLAUDE.mdのTODOリスト参照（16関数）

3. **多値版モデルの動作確認**
   - nominalBiclustering, ordinalBiclustering

---

## 2026-02-18

### 多値バイクラスタリングの新サンプルデータ対応検証

担当: Claude

#### 作業概要

親パッケージexametrikaに追加された新しい多値バイクラスタリングサンプルデータ（J35S500, J20S600）に対するggExametrikaの互換性を検証。plotArray_gg関数が新データで正しく動作することを確認。

#### 背景

exametrika v1.9.0で多値データ用のサンプルデータセットが追加された：
- **J35S500**: ordinal Biclustering（ランククラスタリング）、35項目、500受験者、5カテゴリ
- **J20S600**: nominal Biclustering、20項目、600受験者、4カテゴリ

#### 実施した作業

1. **exametrikaパッケージの更新**
   - GitHub経由で最新版（v1.9.0）をインストール
   - 新データセットJ35S500, J20S600の存在を確認

2. **テストスクリプトの作成**
   - `develop/test_multivalue_biclustering.R` を新規作成
   - ordinalとnominal両方のBiclusteringをテスト
   - 親パッケージの `tests/testthat/test-polytomous-biclustering.R` を参考

3. **動作検証**
   - Test 1: J35S500（ordinal Biclustering）
     - データ構造: 500×35行列、カテゴリ0-5（-1は欠測値）
     - FRP dimensions: 5×5×5（5フィールド×5クラス×5カテゴリ）
     - 収束: TRUE ✓
     - plotArray_gg: 正常動作 ✓

   - Test 2: J20S600（nominal Biclustering）
     - データ構造: 600×20行列、カテゴリ0-4（-1は欠測値）
     - FRP dimensions: 4×5×4（4フィールド×5クラス×4カテゴリ）
     - 収束: TRUE ✓
     - plotArray_gg: 正常動作 ✓

4. **既存機能の確認**
   - plotICC_overlay_gg: 正常動作 ✓
   - plotIIC_overlay_gg: 正常動作 ✓

#### 検証結果

✅ **plotArray_ggは既に多値データに完全対応している**

現在の実装（2026-02-17の修正版）は以下の機能を持つ：

1. **自動カテゴリ検出**
   - `sort(unique(as.vector(as.matrix(raw_data))))`
   - -1（欠測値）と有効値を分離

2. **自動色パレット選択**
   - 2値データ: 白/黒
   - 3+値データ: カラーブラインドフレンドリーパレット（最大20色）
   - 欠測値（-1）: 黒色、凡例に「NA」表示

3. **境界線色の自動切り替え**
   - 2値データ: 赤色（視認性向上）
   - 多値データ: 白色

4. **凡例の自動表示制御**
   - 2値データ: 凡例なし（デフォルト）
   - 多値データ: 凡例あり（デフォルト）

5. **共通オプション完全対応**
   - title, colors, show_legend, legend_position, Clusterd_lines_color

#### コード変更

**なし** - 既存の実装で新データに対応できることを確認

#### テストファイル

- `develop/test_multivalue_biclustering.R` - 83行
  - J35S500（ordinal、5カテゴリ）とJ20S600（nominal、4カテゴリ）の両方をテスト
  - 元のexametrikaプロットとggExametrikaプロットを比較
  - カスタムカラー、凡例オプションのテスト含む

#### ブランチ管理

- ブランチ: `feature/multivalue-data-update`
- 状態: テスト完了、コミット/プッシュなし（ユーザー指示により）

#### 次回の課題

1. **動作確認完了した項目**
   - plotArray_gg（ordinalBiclustering, nominalBiclustering） ✓

2. **未確認の多値版関数（CLAUDE.md参照）**
   - plotFRP_gg（nominalBiclustering, ordinalBiclustering）
   - plotLCD_gg（nominalBiclustering, nominalBiclustering）
   - plotLRD_gg（nominalBiclustering, ordinalBiclustering）
   - plotCMP_gg（nominalBiclustering, ordinalBiclustering）
   - plotRMP_gg（ordinalBiclustering）

3. **既存関数への共通オプション追加**
   - 16関数が未対応（CLAUDE.mdのTODOリスト参照）

---
