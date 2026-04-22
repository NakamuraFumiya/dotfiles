---
name: opusplan-custom
description: Opus で合意した計画を Sonnet agent に委譲して実行する。Opus はプランニング、Sonnet は機械的な実装作業を担当することで、メインの Opus コンテキストを節約する。ユーザーが「opusplan」「委譲して」「Sonnet にやらせて」「/opusplan-custom」などと指示した時に発火する。
---

# 目的
Opus で設計・合意が済んだ後の機械的な実装フェーズを Sonnet サブエージェントに委譲する。
- メインの Opus コンテキストを節約
- 安価・高速な Sonnet で実装を遂行
- Opus はユーザーとの設計対話・レビューに専念

# 使うべきタイミング
- ユーザーと実装方針の合意が取れた後
- 作業の大半が機械的（ファイル編集、commit、PR作成など）
- ユーザーが「opusplan」「委譲して」「/opusplan-custom」などで指示した時

# 使うべきでないタイミング
- 数行の編集で済む小タスク（プロンプトを書く手間が勝つ）
- 設計判断が途中で発生しそうな作業（Sonnet が迷って往復が増える）
- 会話と強く結合した作業（プロンプトに情報を詰め込みにくい）

# 手順

## 1. 計画の抽出と整形
直近の会話から合意した計画を、Sonnet agent 用の自己完結したプロンプトに整形する。最低限:
- **ゴール**: 何を達成したいか
- **背景**: 関連チケット、PR、DesignDoc 等のリンク
- **影響ファイル・変更内容の具体**: 可能なら行レベル / field 単位で指定
- **注意点・判断ポイント**
- **PR 規約**（`~/.claude/CLAUDE.md`）:
  - `--draft` フラグ必須
  - PR body 先頭に関連チケットリンクを見出し付きで記載
  - worktree は必ず `origin/main` 起点
  - `Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>` フッター
- **戻してほしい情報**: PR URL、commit hash、判断した事項など

## 2. Agent ツール呼び出し
- `subagent_type="general-purpose"`
- `model="sonnet"`
- `description`: 短い要約（3-5語）
- `prompt`: 上で作成した自己完結プロンプト

## 3. 結果の検証（Trust but verify）
agent から返ってきたサマリを鵜呑みにしない:
- PR が作成されていれば URL から diff をざっと確認
- commit hash で追えるなら git log / gh で確認
- lint / build / test の結果が報告されているか確認
- agent が独自判断した箇所があればユーザーに共有

## 4. 結果の報告
ユーザーに簡潔に:
- PR URL（あれば）
- agent が下した判断ポイント
- 検証結果（OK なら簡潔に、懸念があれば明示）
