# User Preferences

- PRは常に `--draft` フラグ付きで作成する（`gh pr create --draft`）
- PR の body 先頭に関連チケットのリンクを見出し付きで記載する（例: `## Ticket\n[PROJ-123](https://example.com/PROJ-123)`）。チケット URL はコンテキストから判断する
- PR レビューコメントへの返信には対応コミットハッシュのリンクを含める（例: `[537c3c7e](https://github.com/{owner}/{repo}/commit/537c3c7e) で対応しました。`）。owner/repo は対象リポジトリから判断する

# Testing

- テストを書くとき、最短でパスさせることより「何を保証するか」を重視する
- テスト手法（fixture/mock/stub）の選択理由を聞かれたら説明できるようにする
- モックで逃げずに、既存のテストパターンに倣う
- 更新系テストでは、リクエスト値を factory のデフォルト値と異なる値にして、「値が実際に更新された」ことを保証する（factory のデフォルトと同じ値だと、更新されたのか元の値が残っただけか区別できない）

