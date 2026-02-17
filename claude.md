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

| プロットタイプ | 対応モデル | ggExametrika関数 | 状況 |
|---------------|-----------|-----------------|------|
| IRF/ICC | IRT, GRM | plotICC_gg | 実装済(IRT) |
| TRF | IRT | plotTRF_gg | 実装済(IRT) |
| IIF/IIC | IRT, GRM | plotIIC_gg | 実装済(IRT) |
| TIF/TIC | IRT, GRM | plotTIC_gg | 実装済(IRT) |
| IRP | LCA, LRA, LDLRA | plotIRP_gg | 実装済 |
| FRP | LCA, LRA, Biclustering, IRM, LDB, BINET | plotFRP_gg | 実装済 |
| TRP | LCA, LRA, Biclustering, IRM, LDLRA, LDB, BINET | plotTRP_gg | 実装済 |
| LCD | LCA, Biclustering | plotLCD_gg | 実装済 |
| LRD | LRA, Biclustering, LDLRA, LDB, BINET | plotLRD_gg | 実装済 |
| CMP | LCA, Biclustering, BINET | plotCMP_gg | 実装済 |
| RMP | LRA, Biclustering, LDLRA, LDB, BINET, LRAordinal, LRArated | plotRMP_gg | 実装済 |
| CRV/RRV | Biclustering | - | 未実装 |
| Array | Biclustering, IRM, LDB, BINET | plotArray_gg | 実装済 |
| FieldPIRP | LDB | plotFieldPIRP_gg | 実装済 |
| LDPSR | BINET | - | 未実装 |
| ScoreFreq | LRAordinal, LRArated | - | 未実装 |
| ScoreRank | LRAordinal, LRArated | - | 未実装 |
| ICRP | LRAordinal, LRArated | - | 未実装 |
| ICBR | LRAordinal | - | 未実装 |

### 未実装機能（v1.0までに実装予定）

#### plot.exametrikaのプロットタイプ
1. CRV/RRV (Class/Rank Reference Vector)
2. LDPSR (Latent Dependence Passing Student Rate)
3. ScoreFreq (スコア頻度分布)
4. ScoreRank (スコア-ランクヒートマップ)
5. ICRP (Item Category Reference Profile)
6. ICBR (Item Category Boundary Response)
7. GRM対応 (IRF, IIF, TIF)

#### DAG可視化（print.exametrikaでigraph使用）
9. BNM - DAGの可視化
10. LDLRA - ランク/クラスごとのDAG
11. LDB - ランクごとのDAG
12. BINET - 統合グラフ（edge label付き）

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
