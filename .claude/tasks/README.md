# 作業中タスクをステータスラインに常時表示する

Claude Code のセッションが長くなると、進捗の報告がスクロールで流れて現在地を見失う。
ccstatusline の 2 行目に現在地を出して、常に画面下部に残るようにする。

## 構成

| パス | 実体 | 内容 |
|---|---|---|
| `~/.config/ccstatusline/settings.json` | このリポジトリ | 1 行目はモデル・コンテキスト・ブランチ・差分、2 行目が下のスクリプトを呼ぶ `custom-command` |
| `~/.claude/tasks/statusline.sh` | このリポジトリ | `current.txt` の 1 行目をそのまま出す。ファイルが無ければ何も出さず、2 行目ごと消える |
| `~/.claude/tasks/current.txt` | ローカルのみ | ステータスラインに出す 1 行 |
| `~/.claude/tasks/<任意>.md` | ローカルのみ | タスクの詳細。ステータスラインには出さず、必要なときに開く |

`~/.claude/tasks` をディレクトリごと symlink しないこと。
このリポジトリは public で、`current.txt` には業務のチケット ID・PR 番号・リポジトリ名が入る。
ディレクトリを向けると作業ツリーの中に業務情報が落ち、`git add` で公開される。
`dotfile_link.sh` はスクリプト 1 ファイルだけを張り、`.gitignore` でも二重に弾いている。

## 使い方

`current.txt` に 1 行書く。Claude Code なら作業の区切りで書き換えてもらう。

```
📋 [2/4] VOCSCH-349 #1153 作り替え中 → 次 #1150
```

表示をやめたいときは `current.txt` を消す。widget ごと消える。
