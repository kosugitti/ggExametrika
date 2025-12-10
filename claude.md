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
- exametrikaはSuggestsに入れる（CRAN対応のため）

### CRANチェックリスト
- [ ] R CMD check --as-cran でWARNING/ERRORなし
- [ ] NEWS.mdの更新
- [ ] DESCRIPTIONのバージョン更新
- [ ] examplesの動作確認
- [ ] ドキュメントの整備

## 作業ログ

作業ログは `log.md` に記録する。
