# ggExametrika 開発方針

## プロジェクト概要

exametrikaパッケージの出力をggplot2で可視化するためのパッケージ。
CRAN公開を目指す。

## 親パッケージ

- 場所: `../exametrika/`
- 参照: https://kosugitti.github.io/Exametrika/

## 開発方針

### 変更記録ルール（恒久・厳守）

**軽微なバグ修正でも何でも、変更を加えたら必ずNEWS.mdに記録すること。**

これは殿（プロジェクトオーナー）からの全体指示であり、全ての作業に適用される恒久的なルールである。
コードの変更、ドキュメントの修正、リファクタリング、バグ修正など、種類や規模を問わず、
変更があればNEWS.mdに記録する。記録を省略してはならない。

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

### 依存パッケージ（DESCRIPTION準拠、v0.0.33時点）
- **Depends**: ggplot2, gridExtra
- **Imports**: ggraph, ggrepel, igraph, tidyr
- **Suggests**: exametrika, testthat (>= 3.0.0)

補足:
- ggrepel: plotCRV_gg/plotRRV_ggのshow_labelsで使用（v0.0.24追加）
- tidyr: plotICBR_gg/plotICRP_ggのpivot_longerで使用（v0.0.18追加）
- visNetwork: インタラクティブDAG編集用として予定（未導入）
- exametrikaはSuggestsに入れる（CRAN対応のため）

### CRANチェックリスト
- [ ] R CMD check --as-cran でWARNING/ERRORなし
- [ ] NEWS.mdの更新
- [ ] DESCRIPTIONのバージョン更新
- [ ] examplesの動作確認
- [ ] ドキュメントの整備

## バージョン1.0.0に向けて

**現在のバージョン: v0.0.33**（2026-02-25時点、mainブランチ）

exametrikaの全プロット機能をggplot2で実装完了したらv1.0.0とする。
合宿期間中（2026年2月）に v1.0.0 リリースを目指す。
3名体制で並行開発を進める。

### 現在の全体ステータス（2026-02-25更新）

- **プロット関数**: 27種実装済み + ユーティリティ4種 = 31 export関数
- **共通オプション**: 全プロット関数で対応済み（一部DAG等はlinetype除外）
- **テスト**: 12ファイル、166テストブロック、489アサーション、FAIL 0 / SKIP 0
- **R CMD check**: WARNING/ERROR なし（v0.0.33で解消済み）
- **pkgdown**: Phase 3完了（Plot Gallery記事作成済み）
- **CI**: R-CMD-check.yaml + test-coverage.yaml + pkgdown.yaml 稼働中
- **残タスク**: DAG可視化（LDB, BINET）、visNetwork版（plotGraph_interactive）

### exametrikaのプロットタイプ一覧と実装状況（exametrika v1.9.0 準拠）

※ 対応モデル欄はexametrikaのplot.exametrika内valid_typesに基づく（注: 一部不正確な宣言あり、下記注釈参照）

| プロットタイプ | 対応モデル | ggExametrika関数 | 状況 |
|---------------|-----------|-----------------|------|
| IRF/ICC (IRT) | IRT | plotICC_gg | 実装済 |
| ICRF (GRM) | GRM | plotICRF_gg | 実装済 |
| TRF | IRT | plotTRF_gg | 実装済(IRT) |
| IIF/IIC | IRT, GRM | plotIIC_gg | 実装済 |
| TIF/TIC | IRT, GRM | plotTIC_gg | 実装済 |
| IRP | LCA, LRA, LDLRA | plotIRP_gg | 実装済 |
| FRP | ~~LCA, LRA~~(*1), Biclustering, nominalBiclustering, ordinalBiclustering, IRM, LDB, BINET | plotFRP_gg | **実装済（2値・多値対応、stat対応、共通オプション対応済み）** |
| TRP | LCA, LRA, Biclustering, IRM, LDLRA, LDB, BINET | plotTRP_gg | 実装済 |
| LCD | LCA, Biclustering, nominalBiclustering, ordinalBiclustering | plotLCD_gg | 実装済（多値対応確認済み） |
| LRD | LRA, Biclustering, nominalBiclustering, ordinalBiclustering, LDLRA, LDB, BINET | plotLRD_gg | 実装済（多値対応確認済み） |
| CMP | LCA, Biclustering, nominalBiclustering, ordinalBiclustering, BINET | plotCMP_gg | 実装済（多値対応確認済み） |
| RMP | LRA, Biclustering, ordinalBiclustering, LDLRA, LDB, BINET, LRAordinal, LRArated | plotRMP_gg | 実装済（多値対応確認済み） |
| CRV | Biclustering, nominalBiclustering, ordinalBiclustering | plotCRV_gg | 実装済（多値対応済み、stat対応済み、共通オプション対応済み） |
| RRV | Biclustering, nominalBiclustering, ordinalBiclustering | plotRRV_gg | 実装済（多値対応済み、stat対応済み、共通オプション対応済み） |
| Array | Biclustering, nominalBiclustering, ordinalBiclustering, IRM, LDB, BINET | plotArray_gg | 実装済（多値対応済み、共通オプション対応済み） |
| **FCRP** | nominalBiclustering, ordinalBiclustering | plotFCRP_gg | **実装済（v1.9.0新規、style対応、共通オプション対応済み）** |
| **FCBR** | ordinalBiclustering | plotFCBR_gg | **実装済（v1.9.0新規、ordinal専用、共通オプション対応済み）** |
| **ScoreField** | nominalBiclustering, ordinalBiclustering | plotScoreField_gg | **実装済（v1.9.0新規、共通オプション対応済み）** |
| FieldPIRP | LDB | plotFieldPIRP_gg | 実装済 |
| LDPSR | BINET | plotLDPSR_gg | **実装済（共通オプション対応済み）** |
| ScoreFreq | LRAordinal, LRArated | plotScoreFreq_gg | 実装済（共通オプション対応済み） |
| ScoreRank | LRAordinal, LRArated | plotScoreRank_gg | 実装済（共通オプション対応済み） |
| ICRP | LRAordinal, LRArated | plotICRP_gg | 実装済（共通オプション対応済み） |
| ICBR | LRAordinal | plotICBR_gg | 実装済（共通オプション対応済み） |

### exametrikaのモデル一覧とプロット対応（plot.exametrika valid_types準拠、v1.9.0）

| モデル | 対応プロットタイプ |
|--------|-------------------|
| IRT | IRF/ICC, TRF, IIF/IIC, TIF/TIC |
| GRM | IRF/ICC, IIF/IIC, TIF/TIC |
| LCA | IRP, ~~FRP~~(*1), TRP, LCD, CMP |
| LRA | IRP, ~~FRP~~(*1), TRP, LRD, RMP |
| LRAordinal | ScoreFreq, ScoreRank, ICRP, ICBR, RMP |
| LRArated | ScoreFreq, ScoreRank, ICRP, RMP |
| Biclustering | FRP, TRP, LCD, LRD, CMP, RMP, CRV, RRV, Array |
| **nominalBiclustering** | FRP, **FCRP**, LCD, LRD, CMP, Array, **ScoreField**, CRV, RRV |
| **ordinalBiclustering** | FRP, **FCRP**, **FCBR**, LCD, LRD, CMP, RMP, Array, **ScoreField**, CRV, RRV |
| IRM (Biclustering_IRM) | FRP, TRP, Array |
| LDLRA | IRP, TRP, LRD, RMP |
| LDB | FRP, TRP, LRD, RMP, Array, FieldPIRP |
| BINET | FRP, TRP, LRD, RMP, Array, LDPSR |

**太字** = v1.9.0で追加された多値バイクラスタリング向けプロット

**注釈:**
- (*1) **FRPのLCA/LRA対応について（2026-02-23調査）**: exametrikaのplot.exametrika valid_typesではLCA/LRAに対しFRPが有効と宣言されているが、実際にはLCA()もLRA()も出力に$FRPフィールドを含まない。exametrikaのplot関数は`x$FRP`に直接アクセスするため、LCA/LRAでFRPを描画しようとするとエラーになる。これはexametrika側のvalid_types宣言の誤りであり、ggExametrikaでは正しくLCA/LRAを拒否している。長男（exametrika）への修正提案事項。

### DAG可視化（print.exametrikaでigraph使用）

| モデル | 内容 |
|--------|------|
| BNM | DAGの可視化 |
| LDLRA | ランク/クラスごとのDAG |
| LDB | ランクごとのDAG |
| BINET | 統合グラフ（edge label付き） |

### 追加機能（exametrikaにはないggExametrika独自の機能）

#### オーバーレイプロット関数
exametrikaでは`overlay = TRUE`パラメータで複数の曲線を1つのグラフに重ねて表示できるが、
ggExametrikaでは別関数として実装し、より明示的に使い分けられるようにした。

- [x] `plotICC_overlay_gg()` — IRT全アイテムのICCを1枚のグラフに重ねて表示（実装済み）
- [x] `plotIIC_overlay_gg()` — IRT/GRM全アイテムのIICを1枚のグラフに重ねて表示（実装済み）

### 未実装機能（v1.0.0までに実装予定）

#### v1.9.0で追加された多値バイクラスタリングプロット（新規実装）
1. ~~**FCRP** (Field Category Response Profile)~~ — カテゴリ確率プロット、style パラメータ（line/bar）対応 → `plotFCRP_gg()` として実装済み ✅
   - 対応モデル: nominalBiclustering, ordinalBiclustering
   - 共通オプション完全対応（title, colors, linetype, show_legend, legend_position）
2. ~~**FCBR** (Field Cumulative Boundary Reference)~~ — 境界確率プロット（ordinal専用） → `plotFCBR_gg()` として実装済み ✅
3. ~~**ScoreField**~~ — 期待得点ヒートマップ（フィールド×クラス/ランク） → `plotScoreField_gg()` として実装済み ✅

#### 多値版対応（既存関数の拡張）
4. ~~**FRP**~~ — 多値版で stat パラメータ（mean/median/mode）対応 → 実装完了 ✅
   - 2値・多値両対応、stat パラメータ（mean/median/mode）実装済み
   - 共通オプション完全対応（title, colors, linetype, show_legend, legend_position）
5. ~~**RRV/CRV**~~ — 多値版で stat パラメータ（mean/median/mode）対応 → 実装完了 ✅
   - 2値・多値両対応、stat パラメータ（mean/median/mode）実装済み
   - show_labels パラメータ追加（ggrepel使用）
   - Y軸自動調整（2値: 0-1、多値: 1-maxQ）

#### その他の未実装プロット
5. ~~LDPSR (Latent Dependence Passing Student Rate)~~ — BINET専用 → `plotLDPSR_gg()` として実装済み

#### DAG可視化（print.exametrikaでigraph使用 → ggraph化）

**開発順序は厳守すること。BNM → LDLRA → LDB → BINET の順に実装する。**
前のモデルが完成するまで次のモデルに着手してはならない。
各モデルは前段の構造を土台にしており、順番を飛ばすと設計が破綻する。

6. ~~**BNM（Bayesian Network Model）**~~ — 項目同士のベイジアンネットワーク → **実装済み・テスト済み** ✅
   - 項目（Item）ノード間の有向グラフ（DAG）を描画する
   - 最も基本的なDAG可視化であり、他の全モデルの土台となる
   - ノードは項目、エッジは項目間の依存関係を表す
   - sugiyamaレイアウト、direction="LR"対応、共通オプション対応済み

7. **LDLRA（Latent Rank Analysis with Local Dependence）** — ランクごとの項目DAG → **基本実装済み（テスト未整備）**
    - ランクごとに独立した項目同士のネットワークを描くグラフ
    - BNMの拡張：同じ項目ノード間のDAGが、ランクごとに異なる構造を持つ
    - 参考図: `develop/TDE_figures/LDLRA_TDE02.png`（ランクごとに区切られた項目DAG）
    - 実装済み機能: 全ランク対応、孤立ノード除外、show_prob/prob_digitsパラメータ
    - 残課題: testthatテストの正式整備、developスクリプトでの動作確認のみ

8. **LDB（Local Dependence Biclustering）** — ランクごとのフィールドDAG → **未実装**
    - ランクごとに独立したバイクラスタリングで、ランクごとにフィールド（Field）同士のネットワークを描くグラフ
    - LDLRAとの違い：ノードが項目ではなくフィールド（Latent Field、緑ダイヤ）
    - ランクごとにフィールドの依存構造が異なる
    - 参考図: `develop/TDE_figures/LDB_TDE01.png`（ランクごとのフィールドDAG横並び）
    - 参考図: `develop/TDE_figures/LDB_TDE02.png`（パラメータ推定値重ね表示版）

9. **BINET（Bicluster Network Model）** — 統合ネットワーク（最も複雑） → **未実装**
    - 項目全体を通じて、ランク（Latent Class）のつながりとフィールド（Latent Field）のつながりをネットワークで表す統合グラフ
    - **あるランクの人間が次のランクに行くために、どのフィールドを経由するかを表現するモデル**
    - Latent Class（青四角）とLatent Field（緑ダイヤ）の2種類のノードを同時にプロットしなければならない
    - クラス間のエッジ上にフィールドが配置される構造
    - 参考図: `develop/TDE_figures/BINET_TDE01.png`（クラス+フィールドの統合ネットワーク）
    - 参考図: `develop/TDE_figures/BINET_TDE02.png`（Local Dependence PSRs重ね表示版）
    - 参考図: `develop/TDE_figures/BINET_CMP_TDE.png`（グラフ上にCMP/LCDを表示した版）
    - BNM, LDLRA, LDBの全てを理解した上で初めて実装できる。絶対に先にやるな

#### 既存関数の共通オプション対応（TODO）
以下の関数に共通オプション（title, colors, linetype, show_legend, legend_position）を追加する。

- [x] plotICC_gg — 共通オプション対応済み (v0.0.27)
- [x] plotIIC_gg — 共通オプション対応済み (IRT/GRM両対応)
- [x] plotTIC_gg — 共通オプション対応済み (IRT/GRM両対応、v0.0.27でcolor→colors改名)
- [x] plotTRF_gg — 共通オプション対応済み (v0.0.27)
- [x] plotIRP_gg — 共通オプション対応済み (v0.0.27)
- [x] plotFRP_gg — 共通オプション対応済み（2値・多値両対応、stat パラメータ含む）
- [x] plotTRP_gg — 共通オプション対応済み (v0.0.27、colors[1]=bar fill, colors[2]=line color)
- [x] plotLCD_gg — 共通オプション対応済み (v0.0.27、colors[1]=bar fill, colors[2]=line color)
- [x] plotLRD_gg — 共通オプション対応済み (v0.0.27、colors[1]=bar fill, colors[2]=line color)
- [x] plotCMP_gg — 共通オプション対応済み (v0.0.27)
- [x] plotRMP_gg — 共通オプション対応済み (v0.0.27)
- [x] plotArray_gg — 共通オプション対応済み（多値データ対応含む）
- [x] plotFieldPIRP_gg — 共通オプション対応済み (v0.0.27)
- [x] plotGraph_gg — 共通オプション対応済み (v0.0.27、title/colors/show_legend/legend_position。linetypeはDAGには不適合のため除外)
- [x] plotScoreFreq_gg — 共通オプション対応済み (v0.0.15)
- [x] plotScoreRank_gg — 共通オプション対応済み (v0.0.19)
- [x] plotICRP_gg — 共通オプション対応済み (v0.0.18)
- [x] plotICBR_gg — 共通オプション対応済み (v0.0.18)
- [x] plotICC_overlay_gg — 共通オプション対応済み (v0.0.16)
- [x] plotIIC_overlay_gg — 共通オプション対応済み (v0.0.17)

#### 新規実装予定関数（v1.9.0対応、共通オプションは実装時に検討）
- [x] plotFCRP_gg — v1.9.0新規（style パラメータ: line/bar）実装済み
- [x] plotFCBR_gg — v1.9.0新規（ordinal専用）実装済み
- [x] plotScoreField_gg — v1.9.0新規（ヒートマップ）実装済み
- [x] plotLDPSR_gg — BINET専用（v0.0.32で実装）

### DAG可視化の開発方針

**開発順序（厳守）: BNM → LDLRA → LDB → BINET**

各モデルの構造的な積み上げ関係：
```
BNM:    項目ノード間の単純DAG（基礎）
  ↓
LDLRA:  BNMをランクごとに分割（項目ノード × ランク区切り）
  ↓
LDB:    ノードがフィールドに変わる（フィールドノード × ランク区切り）
  ↓
BINET:  クラスノード + フィールドノードの統合グラフ（最終形）
```

**参考画像**: `develop/TDE_figures/` にTest Data Engineeringからの出力例がある。
これらの図に近づけることが目的。

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

**現在の状態 (2026-02-25更新):**
- `R/plotGraph_gg.R` 実装済み（434行）
- **BNM**: 実装・テスト済み（test-DAG-plots.R: 5テスト、共通オプション対応済み）
- **LDLRA**: plotGraph_gg内にLDLRA処理ブロック追加済み（2026-02-18、log.md参照）。全ランク対応、孤立ノード除外、show_prob/prob_digitsパラメータ対応。ただしtestthat正式テストは未整備
- **LDB**: 未実装
- **BINET**: 未実装
- visNetwork版（plotGraph_interactive）: 未着手
- 次回: LDLRAのtestthatテスト整備 → LDB実装 → BINET実装

## 共同開発ルール（3名体制）

### Git運用（推奨ワークフロー）

#### 基本フロー
```bash
# 1. 作業前に最新を取得
git checkout main
git pull origin main

# 2. featureブランチを作成（機能ごと）
git checkout -b feature/機能名
# 例: feature/score-freq, feature/dag-viz, fix/legend-bug

# 3. 開発・コミット（1機能1コミット）
git add .
git commit -m "Add plotScoreFreq_gg for score frequency"

# 4. リモートにpush
git push origin feature/機能名

# 5. 作業完了後、mainにマージ
git checkout main
git merge feature/機能名
git push origin main

# 6. 不要なブランチを削除
git branch -d feature/機能名
```

#### ブランチ命名規則
- **feature/機能名**: 新機能開発（例: `feature/score-freq`, `feature/icrp`）
- **fix/修正内容**: バグ修正（例: `fix/legend-position`, `fix/sort-order`）
- **refactor/対象**: リファクタリング（例: `refactor/common-options`）

#### 重要なポイント
- 作業前に必ず `git pull` で最新を取得する
- 機能単位でこまめにコミットする（1機能1コミット）
- コミットメッセージは変更内容がわかるように書く（例: `Add plotTRF_gg for TRF visualization`）
- 作業が一段落したら `git push` して他のメンバーと共有する
- 同じファイルの同時編集はなるべく避ける。担当を分けること
- mainブランチへの直接commitは避け、featureブランチ経由でマージする

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
