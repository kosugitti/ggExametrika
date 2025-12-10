# ggExametrika 開発ログ

## 2025-12-10

### 初期セットアップ

- claude.md（開発方針）とlog.md（作業ログ）を作成
- .Rbuildignoreにclaude.md、log.md、README.Rmdを追加
- DESCRIPTIONのSuggestsにExametrikaを追加

### exametrikaとの互換性調査

#### 致命的な問題: クラス名の大文字/小文字

ggExametrikaは `"Exametrika"` (大文字E)をチェックしているが、
現在のexametrikaは `"exametrika"` (小文字e)を使用。

**影響を受ける関数（全関数）:** - `plotICC_gg`:
`class(data) %in% c("Exametrika", "IRT")` → 動作しない - `plotIIC_gg`:
同上 - `plotTIC_gg`: 同上 - `plotIRP_gg`: `c("Exametrika", "LCA")`,
`c("Exametrika", "LRA")`, `c("Exametrika", "LDLRA")` → 動作しない -
`plotFRP_gg`: `c("Exametrika", "Biclustering")`, etc. → 動作しない -
`plotTRP_gg`: 同上 - `plotLCD_gg`: 同上 - `plotLRD_gg`: 同上 -
`plotCMP_gg`: 同上 - `plotRMP_gg`: 同上 - `plotArray_gg`: 同上 -
`plotFieldPIRP_gg`: 同上

#### 修正方針

全ての `"Exametrika"` を `"exametrika"` に変更する必要あり。

#### exametrikaの現在の出力構造（確認済み）

| クラス       | 主要フィールド                                                                                    |
|--------------|---------------------------------------------------------------------------------------------------|
| IRT          | params (slope, location, lowerAsym, upperAsym), itemPSD, ability                                  |
| LCA          | IRP, TRP, LCD, CMD, Students, Nclass                                                              |
| LRA          | IRP, IRPIndex, TRP, LRD, RMD, Students, Nrank                                                     |
| Biclustering | FRP, FRPIndex, TRP, LRD/LCD, CMD/RMD, Students, U, FieldEstimated, ClassEstimated, Nclass, Nfield |
| IRM          | FRP, TRP, LCD, LFD, FieldEstimated, ClassEstimated, Nclass, Nfield                                |
| LDLRA        | IRP, IRPIndex, TRP, LRD, RMD, Students, Nclass, CCRR_table                                        |
| LDB          | IRP, FRP, FRPIndex, TRP, LRD, RMD, Students, Nrank, Nfield, CCRR_table                            |
| BINET        | FRP, PSRP, LDPSR, TRP, LCD, CMD, Students, Nclass, Nfield                                         |

**注意**: 新しいexametrikaは一部で命名規則を変更中 - `Nclass` →
`n_class` (後方互換性のため両方存在) - `Nrank` → `n_rank` - `N_Cycle` →
`n_cycle`

ggExametrikaが使用している `Nclass`, `Nrank`
などは後方互換性フィールドとして残っているため、フィールドアクセス自体は問題なし。

### クラス名修正完了

全Rファイルで `"Exametrika"` → `"exametrika"` に修正: - `R/ICCtoTIC.R` -
`R/IRPtoCMPRMP.R` - `R/arraytoLDPSR.R`

### GitHub Pages (pkgdown) 設定

- `_pkgdown.yml` 作成（サイト設定、リファレンス構成）
- `.github/workflows/pkgdown.yaml` 作成（GitHub Actions自動デプロイ）
- `.Rbuildignore` に pkgdown関連を追加
- DESCRIPTIONのSuggests: `Exametrika` → `exametrika`
  (CRANパッケージ名は小文字)
- GitHub Pages有効化完了
- サイト公開: <https://kosugitti.github.io/ggExametrika/>
