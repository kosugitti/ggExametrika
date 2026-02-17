# ggExametrika 開発方針

## プロジェクト概要

exametrikaパッケージの出力をggplot2で可視化するためのパッケージ。
CRAN公開を目指す。

## 親パッケージ

- 場所: `../exametrika/`
- 参照: https://kosugitti.github.io/Exametrika/

## 開発方針

### コーディング規約
- roxygen2によるドキュメント生成
- testthatによるユニットテスト
- CRAN準拠のチェックをパスすること

### 関数命名規則
- plot関数: `plot_*()` または `gg*()` 形式を検討
- 内部関数: `.` prefix

### 共通オプション（全plot関数に適用）

全てのplot関数は以下の共通引数を持つこと。新規実装時は必ず含める。既存関数は段階的に対応する。

| 引数 | 型 | デフォルト | 説明 |
|------|----|-----------|------|
| `title` | logical or character | `TRUE` | TRUE=自動タイトル、FALSE=非表示、文字列=カスタムタイトル |
| `colors` | character vector | `NULL` | NULL=デフォルトパレット、指定でカスタム色 |
| `linetype` | character or numeric | 関数依存 | 線の種類（"solid", "dashed"等） |
| `show_legend` | logical | 関数依存 | 凡例の表示/非表示 |
| `legend_position` | character | `"right"` | "top", "bottom", "left", "right", "none" |

**注意:**
- `colors` が `NULL` の場合、カラーバリアフリーに配慮したデフォルトパレットを使用する
- 凡例が不要なプロット（単一曲線のみ等）は `show_legend = FALSE` をデフォルトとする
- 返り値はggplotオブジェクトなので、ユーザーが `+ theme()` 等で後から変更することも可能

### 依存パッケージ
- ggplot2 (必須)
- gridExtra (複数プロット配置)
- ggraph, igraph (DAG可視化用)
- visNetwork (インタラクティブDAG編集用、予定)
- exametrikaはSuggestsに入れる（CRAN対応のため）

### CRANチェックリスト
- [ ] R CMD check --as-cran でWARNING/ERRORなし
- [ ] NEWS.mdの更新
- [ ] DESCRIPTIONのバージョン更新
- [ ] examplesの動作確認
- [ ] ドキュメントの整備

## バージョン1.0.0に向けて

exametrikaの全プロット機能をggplot2で実装完了したらv1.0.0とする。
合宿期間中（2026年2月）に v1.0.0 リリースを目指す。
3名体制で並行開発を進める。

### exametrikaのプロットタイプ一覧と実装状況

※ 対応モデル欄はexametrikaのplot.exametrika内valid_typesに基づく

| プロットタイプ | 対応モデル | ggExametrika関数 | 状況 |
|---------------|-----------|-----------------|------|
| IRF/ICC (IRT) | IRT | plotICC_gg | 実装済 |
| ICRF (GRM) | GRM | plotICRF_gg | 実装済 |
| TRF | IRT | plotTRF_gg | 実装済(IRT) |
| IIF/IIC | IRT, GRM | plotIIC_gg | 実装済 |
| TIF/TIC | IRT, GRM | plotTIC_gg | 実装済 |
| IRP | LCA, LRA, LDLRA | plotIRP_gg | 実装済 |
| FRP | LCA, LRA, Biclustering, nominalBiclustering, ordinalBiclustering, IRM, LDB, BINET | plotFRP_gg | 実装済 ※多値版の動作未確認 |
| TRP | LCA, LRA, Biclustering, IRM, LDLRA, LDB, BINET | plotTRP_gg | 実装済 |
| LCD | LCA, Biclustering, nominalBiclustering, ordinalBiclustering | plotLCD_gg | 実装済 ※多値版の動作未確認 |
| LRD | LRA, Biclustering, nominalBiclustering, ordinalBiclustering, LDLRA, LDB, BINET | plotLRD_gg | 実装済 ※多値版の動作未確認 |
| CMP | LCA, Biclustering, nominalBiclustering, ordinalBiclustering, BINET | plotCMP_gg | 実装済 ※多値版の動作未確認 |
| RMP | LRA, Biclustering, ordinalBiclustering, LDLRA, LDB, BINET, LRAordinal, LRArated | plotRMP_gg | 実装済 ※多値版の動作未確認 |
| CRV | Biclustering | plotCRV_gg | 実装済（共通オプション対応済み） |
| RRV | Biclustering | plotRRV_gg | 実装済（共通オプション対応済み） |
| Array | Biclustering, nominalBiclustering, ordinalBiclustering, IRM, LDB, BINET | plotArray_gg | 実装済（多値対応済み、共通オプション対応済み） |
| FieldPIRP | LDB | plotFieldPIRP_gg | 実装済 |
| LDPSR | BINET | - | 未実装 |
| ScoreFreq | LRAordinal, LRArated | - | 未実装 |
| ScoreRank | LRAordinal, LRArated | - | 未実装 |
| ICRP | LRAordinal, LRArated | - | 未実装 |
| ICBR | LRAordinal | - | 未実装 |

### exametrikaのモデル一覧とプロット対応（plot.exametrika valid_types準拠）

| モデル | 対応プロットタイプ |
|--------|-------------------|
| IRT | IRF/ICC, TRF, IIF/IIC, TIF/TIC |
| GRM | IRF/ICC, IIF/IIC, TIF/TIC |
| LCA | IRP, FRP, TRP, LCD, CMP |
| LRA | IRP, FRP, TRP, LRD, RMP |
| LRAordinal | ScoreFreq, ScoreRank, ICRP, ICBR, RMP |
| LRArated | ScoreFreq, ScoreRank, ICRP, RMP |
| Biclustering | FRP, TRP, LCD, LRD, CMP, RMP, CRV, RRV, Array |
| nominalBiclustering | FRP, LCD, LRD, CMP, Array |
| ordinalBiclustering | FRP, LCD, LRD, CMP, RMP, Array |
| IRM (Biclustering_IRM) | FRP, TRP, Array |
| LDLRA | IRP, TRP, LRD, RMP |
| LDB | FRP, TRP, LRD, RMP, Array, FieldPIRP |
| BINET | FRP, TRP, LRD, RMP, Array, LDPSR |

### DAG可視化（print.exametrikaでigraph使用）

| モデル | 内容 |
|--------|------|
| BNM | DAGの可視化 |
| LDLRA | ランク/クラスごとのDAG |
| LDB | ランクごとのDAG |
| BINET | 統合グラフ（edge label付き） |

### 未実装機能（v1.0.0までに実装予定）

#### plot.exametrikaのプロットタイプ（新規実装）
1. ~~CRV/RRV (Class/Rank Reference Vector)~~ → plotCRV_gg, plotRRV_gg として実装済み
2. LDPSR (Latent Dependence Passing Student Rate) — BINET
3. ScoreFreq (スコア頻度分布) — LRAordinal, LRArated
4. ScoreRank (スコア-ランクヒートマップ) — LRAordinal, LRArated
5. ICRP (Item Category Reference Profile) — LRAordinal, LRArated
6. ICBR (Item Category Boundary Response) — LRAordinal

#### GRM対応（既存関数の拡張）
7. ~~IRF/ICC — GRMモデル対応~~ → plotICRF_gg として実装済み
8. ~~IIF/IIC — GRMモデル対応~~ → plotIIC_gg に GRM 対応追加済み
9. ~~TIF/TIC — GRMモデル対応~~ → plotTIC_gg に GRM 対応追加済み

#### 多値版モデル対応（動作確認・必要に応じて修正）
10. ~~Array — nominalBiclustering, ordinalBiclustering 対応完了~~
11. nominalBiclustering — FRP, LCD, LRD, CMP（動作未確認）
12. ordinalBiclustering — FRP, LCD, LRD, CMP, RMP（動作未確認）

#### DAG可視化（print.exametrikaでigraph使用 → ggraph化）
12. BNM - DAGの可視化
13. LDLRA - ランク/クラスごとのDAG
14. LDB - ランクごとのDAG
15. BINET - 統合グラフ（edge label付き）

#### 既存関数の共通オプション対応（TODO）
以下の関数に共通オプション（title, colors, linetype, show_legend, legend_position）を追加する。

- [ ] plotICC_gg — title(ハードコード), colors/linetype/legend なし
- [x] plotIIC_gg — 共通オプション対応済み (IRT/GRM両対応)
- [x] plotTIC_gg — 共通オプション対応済み (IRT/GRM両対応)
- [ ] plotTRF_gg — title(ハードコード), colors/linetype/legend なし
- [ ] plotIRP_gg — title(ハードコード), linetype(dashed固定), colors/legend なし
- [ ] plotFRP_gg — title(ハードコード), linetype(dashed固定), colors/legend なし
- [ ] plotTRP_gg — title(logical対応済み), colors/linetype/legend 未対応
- [ ] plotLCD_gg — title(logical対応済み), colors/linetype/legend 未対応
- [ ] plotLRD_gg — title(logical対応済み), colors/linetype/legend 未対応
- [ ] plotCMP_gg — title(ハードコード), linetype(dashed固定), colors/legend なし
- [ ] plotRMP_gg — title(ハードコード), linetype(dashed固定), colors/legend なし
- [x] plotArray_gg — 共通オプション対応済み（多値データ対応含む）
- [ ] plotFieldPIRP_gg — title(ハードコード), colors/linetype/legend なし
- [ ] plotGraph_gg — 独自オプション多数、共通オプションとの整合性を検討

### DAG可視化の開発方針

**2段階アプローチを採用:**

1. **plotGraph_interactive()** - visNetworkでインタラクティブ編集版
   - ノードをドラッグして位置調整可能
   - 編集後の座標を取得可能
   - レイアウトの試行錯誤用

2. **plotGraph_gg()** - ggraphで静的ggplotオブジェクト版
   - インタラクティブ版で決めた座標を引数で渡せる
   - 論文・レポート用の清書版

**ワークフロー:**
```
visNetwork(インタラクティブ編集) → 座標取得 → ggraph(静的プロット生成)
```

**現在の状態 (2025-12-12):**
- `R/plotGraph_gg.R` 作成済み（未テスト）
- DESCRIPTIONにggraph, igraph追加済み
- 次回: visNetwork版の実装、テスト

## 共同開発ルール（3名体制）

### Git運用
- 作業前に必ず `git pull` で最新を取得する
- 機能単位でこまめにコミットする（1機能1コミット）
- コミットメッセージは変更内容がわかるように書く（例: `Add plotTRF_gg for TRF visualization`）
- 作業が一段落したら `git push` して他のメンバーと共有する
- 同じファイルの同時編集はなるべく避ける。担当を分けること

### 作業ログ（log.md）
- 作業開始時に日付と担当者名を記録する
- 何を実装/修正したか、判断の理由を簡潔に書く
- 次回の課題・残作業を明記する
- 他のメンバーが読んでも状況がわかるように書く

### 作業の進め方
- 実装前にCLAUDE.mdの未実装リストで担当を確認する
- 実装後は `devtools::document()` でドキュメント更新する
- 実装状況表（上記）を更新する
- NEWS.md に変更を追記する
