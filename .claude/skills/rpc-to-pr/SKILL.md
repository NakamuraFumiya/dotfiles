---
name: rpc-to-pr
description: Connect RPC をローカルで叩き、curl コマンドとレスポンスを現在ブランチの PR ディスクリプション末尾に追記する。OpeRPC 等の動作確認エビデンスを PR に残したい時に使う。
---

# Connect RPC 動作確認 → PR 追記

## 概要

ローカルで Connect RPC エンドポイントを curl で叩き、結果（curl コマンド + レスポンス JSON）を現在ブランチに紐づく PR の body 末尾に追記するスキル。

`/rpc` の動作確認機能に「PR ディスクリプションへの貼り付け」を足したもの。RPC 単体で叩きたいだけなら `/rpc` を使う。

## 前提

- 現在ブランチが GitHub にプッシュ済みで、紐づく PR が存在すること
- `gh` CLI が認証済みであること
- proto ファイルがプロジェクト内にあること（`/rpc` と同様）

## 実行手順

### 1. proto ファイルの検索とメソッド選択

`/rpc` のステップ 1 と同じ手順で `.proto` を Glob 検索し、サービス/メソッドを決定する。引数があれば優先。

### 2. 接続先の決定

デフォルト `http://localhost:8080`。引数で指定があればそれを使う。

### 3. トークンの取得

`/rpc` と同じセキュリティルールを守る:

- 環境変数 `RPC_TOKEN` があればそれを使う（curl 内で `$RPC_TOKEN` として参照）
- なければユーザーに JWT トークンの入力を求める
- **トークンをファイルに書かない。echo / cat で出さない。**

### 4. リクエストボディの構築

proto のメッセージ定義からフィールドを抽出し、JSON を提示。引数で `'{"key":"value"}'` 形式があればそれを使う。不足はユーザーに聞く。

### 5. curl の実行

```bash
curl -s --location 'HOST/PACKAGE.SERVICE/METHOD' \
  --header 'Content-Type: application/json' \
  --header "Authorization: $RPC_TOKEN" \
  --data 'REQUEST_BODY'
```

レスポンスを `jq` で整形して保存（実行はするが、トークンは表に出さない）。

### 6. 現在ブランチの PR を検出

```bash
BRANCH=$(git branch --show-current)
gh pr list --head "$BRANCH" --json number,url,title --limit 5
```

- 0 件: 「現在ブランチ `$BRANCH` に紐づく PR が見つかりません。PR 番号を指定してください」とユーザーに確認
- 1 件: そのまま採用、番号を表示して確認
- 複数件: 一覧表示して選択させる

### 7. 既存 body の取得

```bash
gh pr view <number> --json body --jq .body > /tmp/pr-body.md
```

### 8. body 末尾に追記して更新

追記フォーマット（**Authorization ヘッダのトークンは `<TOKEN>` でマスク**）:

````markdown

## RPC 動作確認

```bash
curl -s --location 'http://localhost:8080/handyvocope.v1.SchoolStaffService/ListSchoolStaffs' \
  --header 'Content-Type: application/json' \
  --header 'Authorization: <TOKEN>' \
  --data '{"schoolId":"xxx"}'
```

<details>
<summary>レスポンス</summary>

```json
{
  ...
}
```

</details>
````

更新:

```bash
gh pr edit <number> --body-file /tmp/pr-body-updated.md
```

更新後、PR URL を表示する。

### 9. 複数メソッドを連続で確認する場合

2 回目以降は **追記方式**（既存セクションは消さずに `## RPC 動作確認 (2)` のように連番を振る）。複数 RPC を 1 PR で確認するケースを想定。

## 引数の形式

```
/rpc-to-pr                                  → 対話的に選択
/rpc-to-pr ListSchoolStaffs                 → メソッド指定
/rpc-to-pr ListSchoolStaffs '{"schoolId":"xxx"}'  → メソッド + ボディ
/rpc-to-pr --pr 714 ListSchoolStaffs        → PR 番号を明示
```

## 注意事項

- **トークン漏洩防止**: PR body にトークン実値が混入しないこと。`Authorization: <TOKEN>` で必ずマスク。レスポンス JSON にトークン相当のフィールド（access_token 等）が含まれる場合もマスクするか、ユーザーに確認する
- レスポンスに個人情報（メールアドレス、氏名、ID）が含まれる場合、PR の公開範囲を踏まえてユーザーに「このまま貼って良いか」確認する
- `gh pr edit` は body 全置換なので、必ず `gh pr view --json body` で取得した既存 body の末尾に追記する形にすること
- 既に同じセクションが末尾にある場合（再実行など）は連番化（`(2)`, `(3)` ...）して残す
- PR が draft かどうかに関係なく動作する
