---
name: done-today
description: Jira で自分が今日完了にしたタスクを一覧表示する
allowed-tools: Bash
---

# 今日完了にした Jira タスク一覧

## 実行指示

Jira MCP の検索ツール (`mcp__mcp-atlassian__jira_search`) を使い、**自分が今日「Done」ステータスに変更したタスク** を取得して一覧表示してください。

### JQL

```
assignee = currentUser() AND status changed to "Done" ON "{today}"
```

- `{today}` は実行日の日付（YYYY-MM-DD 形式）に置換する
- currentDate コンテキストまたはシステム日付から取得する

### 取得フィールド

`summary,status,issuetype,updated`

### 出力形式

```
## 今日完了にしたタスク（YYYY-MM-DD）

| チケット | 種別 | サマリー |
|---------|------|---------|
| **VOC-123** | ストーリー | タスクのサマリー |
| **VOC-456** | サブタスク | 別のタスクのサマリー |

合計: N 件
```

### 結果が 0 件の場合

「今日完了にしたタスクはありませんでした。」と返してください。
