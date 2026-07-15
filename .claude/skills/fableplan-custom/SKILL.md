---
name: fableplan-custom
description: Fable で合意した計画を Opus agent に委譲して実行する。Fable はプランニング・レビュー、Opus は実装作業を担当することで、メインの Fable コンテキストを節約する。ユーザーが「fableplan」「Opus に委譲して」「Opus にやらせて」「/fableplan-custom」などと指示した時に発火する。
---

# 目的
Fable で設計・合意が済んだ後の実装フェーズを Opus サブエージェントに委譲する。
- メインの Fable コンテキストを節約
- 実装力の高い Opus で、定型〜中程度の複雑さの実装を遂行
- Fable はユーザーとの設計対話・成果物レビューに専念

# opusplan-custom との使い分け
- `opusplan-custom`: 実装が機械的（ファイル編集・commit・PR作成が中心）→ Sonnet に委譲
- `fableplan-custom`: 実装に一定の判断力が要る（既存パターンの読み取り、UI の状態管理、複数ファイルにまたがる整合性など）→ Opus に委譲

# 使うべきタイミング
- ユーザーと実装方針の合意が取れた後
- 仕様・API 契約・デザインは固まっているが、実装中に小さな判断（既存コードへの倣い方、命名、分割）が発生しうる作業
- ユーザーが「fableplan」「Opus に委譲して」「/fableplan-custom」などで指示した時

# 使うべきでないタイミング
- 数行の編集で済む小タスク（プロンプトを書く手間が勝つ）
- 完全に機械的な作業（Sonnet で十分 → `opusplan-custom`）
- 設計そのものが未合意で、実装中に方針レベルの判断が発生しそうな作業（Fable 本体でやる）
- 会話と強く結合した作業（プロンプトに情報を詰め込みにくい）

# 手順

## 1. 計画の抽出と整形
直近の会話から合意した計画を、Opus agent 用の自己完結したプロンプトに整形する。最低限:
- **ゴール**: 何を達成したいか
- **背景**: 関連チケット、PR、DesignDoc、Figma 等のリンク
- **影響ファイル・変更内容の具体**: 可能なら行レベル / field 単位で指定
- **注意点・判断ポイント**: 委譲先に任せる判断と、勝手に決めずに報告してほしい判断を区別して書く
- **PR 規約**（`~/.claude/CLAUDE.md`）:
  - `--draft` フラグ必須
  - PR タイトルは `[repo名] feat: 要約 (VOC-XXX)` 形式
  - PR body 先頭に関連チケットリンクを見出し付きで記載
  - worktree は必ず `origin/main` 起点
  - `Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>` フッター
- **戻してほしい情報**: PR URL、commit hash、独自判断した事項、lint / build / test の結果

## 2. Agent ツール呼び出し
- `subagent_type="general-purpose"`
- `model="opus"`
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
