# User Preferences

- PRは常に `--draft` フラグ付きで作成する（`gh pr create --draft`）
- PR の body 先頭に関連チケットのリンクを見出し付きで記載する（例: `## Ticket\n[PROJ-123](https://example.com/PROJ-123)`）。チケット URL はコンテキストから判断する
- PR レビューコメントへの返信には対応コミットハッシュのリンクを含める（例: `[537c3c7e](https://github.com/{owner}/{repo}/commit/537c3c7e) で対応しました。`）。owner/repo は対象リポジトリから判断する
- worktree 作成時は必ず `origin/main` を起点にする（`git worktree add <path> -b <branch> origin/main`）

# Testing

- テストを書くとき、最短でパスさせることより「何を保証するか」を重視する
- テスト手法（fixture/mock/stub）の選択理由を聞かれたら説明できるようにする
- モックで逃げずに、既存のテストパターンに倣う
- 更新系テストでは、リクエスト値を factory のデフォルト値と異なる値にして、「値が実際に更新された」ことを保証する（factory のデフォルトと同じ値だと、更新されたのか元の値が残っただけか区別できない）
- controller にエラーを返しうる外部呼び出し（repository, service 等）を追加したら、その呼び出しが失敗するケースのテストも必ず追加する

# Architecture

- Repository は集約（Aggregate）を常に完全な状態で返すこと。パフォーマンスのために部分取得が必要な場合は QueryService パターンを使う

