---
name: nippo-sessions
description: Claude Codeの本日のセッション履歴を分析し、日報の作業ログに追記する
allowed-tools: Bash, Read, Edit, Glob, mcp__linear__get_issue, mcp__mcp-atlassian__jira_get_issue
---

# Claude Codeセッション履歴 → 日報追記

## 概要
本日のClaude Codeセッション履歴（JSONL）を解析し、プロジェクトごとの作業内容を要約して日報ファイルに追記する。

## 対象ファイル
- セッション履歴: `~/.claude/projects/*/` 配下の本日更新された `.jsonl` ファイル（subagents配下は除外）
- 日報ファイル: `$HOME/nippo/$(date +%Y)/$(date +%m)/nippo.$(date +%Y-%m-%d).md`

## 実行手順

### 1. 本日のセッションファイルを収集

```bash
find ~/.claude/projects -name "*.jsonl" -not -path "*/subagents/*" -mtime 0
```

### 2. 各セッションからユーザー発言とアシスタントの要約を抽出

以下のPythonスクリプトで、各セッションのユーザー発言を抽出する:

```bash
python3 -c "
import sys, json, os

for filepath in sys.argv[1:]:
    project = filepath.split('projects/')[1].split('/')[0]
    project = project.replace('-Users-fumiyanakamura-', '').replace('-Users-fumiyanakamura', '(home)')
    messages = []
    with open(filepath) as f:
        for line in f:
            d = json.loads(line)
            if d.get('type') == 'user':
                msg = d.get('message', {})
                if isinstance(msg, dict):
                    content = msg.get('content', '')
                    if isinstance(content, str) and len(content.strip()) > 0:
                        text = content.strip()
                        # skip command messages and very short messages
                        if not text.startswith('<command-') and not text.startswith('<local-command') and len(text) > 5:
                            messages.append(text[:200])
                    elif isinstance(content, list):
                        for c in content:
                            if isinstance(c, dict) and c.get('type') == 'text':
                                text = c.get('text', '').strip()
                                if not text.startswith('<command-') and not text.startswith('<local-command') and len(text) > 5:
                                    messages.append(text[:200])
    if messages:
        print(f'=== Project: {project} ===')
        for m in messages:
            print(f'  - {m}')
        print()
" $(find ~/.claude/projects -name "*.jsonl" -not -path "*/subagents/*" -mtime 0)
```

### 3. チケット・PRの内容を把握する

セッション内容から、チケット番号（VOC-XXX等）とGitHub PR番号を抽出し、それぞれ何の作業かを調べる。

#### チケット
会話中に登場する `VOC-XXX` 等のチケット番号に対して Linear MCP の `get_issue` を使う。
Linear で見つからない場合のみ Jira MCP の `jira_get_issue` にフォールバックする。

#### GitHub PR
会話中に登場する PR番号に対して以下で取得する:
```bash
gh pr view {PR番号} --repo {org/repo} --json title --jq '.title'
```

リポジトリは会話の文脈から判断する（例: `owner/repo`）。

取得したタイトルは**そのまま日報へ貼らず**、何をしたかを自分の言葉に直して書く。

### 4. セッション内容を分析して要約を作成

抽出した会話から、以下の観点で作業内容を整理する:

- **プロジェクト別の作業内容**: どのリポジトリで何をしたか
- **主なタスク**: PR作成、レビュー対応、バグ修正、新機能実装など
- **議論・意思決定**: 技術的な議論や設計判断
- **学び・気づき**: セッション中に得た知見

### 5. 日報ファイルに追記

日報の `## 📝 作業ログ` セクションの末尾に、以下の形式で追記する。
チケット番号・PR番号には何の作業かが分かる説明を必ず添え、後から見返しても内容が分かるようにする。

```markdown
### HH:MM - Claude Codeセッションサマリー
#### [プロジェクト名]
- **VOC-XXX**（何の作業か）: 作業内容の要約
- **PR #YYY**（何の作業か）: 作業内容の要約

#### [プロジェクト名2]
- 作業内容の要約
```

### 6. 注意事項

- **記載してよい情報の範囲は `/nippo` の「記載してよい情報の範囲」に従う。**
  セッション履歴には認証情報・実データ・同僚の氏名がそのまま残っていることがあるので、
  日報へ写すときに落とす
- 既存の作業ログの内容と重複しないようにする
- セッション中のノイズ（中断、リトライ、コマンド実行など）は除外する
- PRのURLやJiraチケット番号など、具体的なリファレンスは残す
- 手動で追記した作業ログは上書きしない
- 会話の流れから作業の文脈を読み取り、単なる発言の羅列ではなく意味のある要約にする
