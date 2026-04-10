# User Preferences

- PRは常に `--draft` フラグ付きで作成する（`gh pr create --draft`）
- PR の body 先頭に関連チケットのリンクを見出し付きで記載する（例: `## Ticket\n[PROJ-123](https://example.com/PROJ-123)`）。チケット URL はコンテキストから判断する
- PR レビューコメントへの返信には対応コミットハッシュのリンクを含める（例: `[537c3c7e](https://github.com/{owner}/{repo}/commit/537c3c7e) で対応しました。`）。owner/repo は対象リポジトリから判断する
- worktree 作成時は必ず `origin/main` を起点にする（`git worktree add <path> -b <branch> origin/main`）

# Code Style

- 1回しか使わない値を中間変数に入れない。関数の引数に直接渡す
- 値をポインタ化するときは `new()` を使う（Go 1.26）。中間変数 + `&` を使わない。関数の戻り値も `new(f())` でポインタ化できる

# Go Project Rules

以下は Go プロジェクト固有のルール。プロジェクト側の CLAUDE.md に移行予定。

## Testing

- テストを書くとき、最短でパスさせることより「何を保証するか」を重視する
- テスト手法（fixture/mock/stub）の選択理由を聞かれたら説明できるようにする
- モックで逃げずに、既存のテストパターンに倣う
- 更新系テストでは、リクエスト値を factory のデフォルト値と異なる値にして、「値が実際に更新された」ことを保証する（factory のデフォルトと同じ値だと、更新されたのか元の値が残っただけか区別できない）
- controller にエラーを返しうる外部呼び出し（repository, service 等）を追加したら、その呼び出しが失敗するケースのテストも必ず追加する
- mock の EXPECT 設定で `gomock.Any()` を使う場合、引数の検証が不要な明確な理由があること。具体的な値が分かっている場合はその値を指定する
- テストのアサーションでは個別フィールド比較（`if got.X != want.X`）より `cmp.Diff` を使う。

## Architecture

- Repository は集約（Aggregate）を常に完全な状態で返すこと。パフォーマンスのために部分取得が必要な場合は QueryService パターンを使う
- エラーは発生場所でアプリケーションエラー（`errors.NewError`）にラップする。呼び出し元でのラップ忘れを防ぐため、ヘルパー関数・mapper 等でも標準エラーをそのまま返さない
