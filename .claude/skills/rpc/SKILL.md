---
name: rpc
description: Connect RPC の動作確認を行う（proto 読み取り・自動補完対応）
---

# Connect RPC 動作確認

## 概要

Connect RPC エンドポイントに curl でリクエストを送り、動作確認を行うスキル。
`.proto` ファイルを読み取ってサービス/メソッド一覧を自動補完する。

## 実行手順

### 1. proto ファイルの検索と解析

- プロジェクト内の `.proto` ファイルを Glob で検索する（`**/*.proto`）
- 各 proto ファイルから以下を抽出する:
  - `package` 名
  - `service` 定義とその中の `rpc` メソッド一覧
  - 各メソッドのリクエスト型（`message` 定義）のフィールド構造
- 引数でメソッド名が指定されていればそれを使う
- 指定がなければサービス/メソッド一覧を表示し、ユーザーに選んでもらう

### 2. 接続先の決定

- 引数やユーザー指示でホストが指定されていればそれを使用する
- 指定がなければ「接続先はどこですか？（デフォルト: localhost:8080）」と確認する

### 3. トークンの取得

**セキュリティルール（厳守）:**
- トークンをファイルに書き出してはいけない
- トークンを echo や cat でターミナルに出力してはいけない
- curl コマンドの実行時のみ使用する

**取得の優先順位:**
1. 環境変数 `RPC_TOKEN` が設定されていればそれを使う（`echo` せず curl 内で `$RPC_TOKEN` として参照）
2. 設定されていなければ「JWT トークンを貼り付けてください」とユーザーに入力を求める

### 4. リクエストボディの構築

- proto のメッセージ定義を読んで、リクエストボディの JSON 構造を提示する
- 引数でボディが指定されていればそれを使う
- 指定がなければフィールドを確認してユーザーに値を入力してもらう

### 5. curl の実行

以下の形式で curl を実行する:

```
curl -s --location 'HOST/PACKAGE.SERVICE/METHOD' \
  --header 'Content-Type: application/json' \
  --header 'Authorization: TOKEN' \
  --data 'REQUEST_BODY'
```

- Connect RPC の URL 形式: `{host}/{package}.{service}/{method}`
- package 名はドット区切り（例: `handyvoc.school_staff.v1`）

### 6. レスポンスの表示

- JSON レスポンスを整形して表示する
- エラーレスポンスの場合は HTTP ステータスとエラー内容を解説する
- 必要に応じて proto のレスポンス型と照らし合わせて説明する

## 引数の形式

```
/rpc                              → 対話的にサービス・メソッドを選択
/rpc GetIncompleteJob             → メソッド名だけ指定（サービスは自動検索）
/rpc JobService/GetIncompleteJob  → サービス/メソッドを指定
/rpc GetIncompleteJob '{"id":"xxx"}'  → メソッドとボディを指定
```

## 注意事項

- 引数なしで呼ばれた場合は proto を読んでサービス一覧を出すところから始める
- proto ファイルが見つからない場合はユーザーにパスを聞く
- トークンの有効期限切れエラー（401）が返った場合は「トークンが期限切れです。新しいトークンを貼ってください」と案内する
