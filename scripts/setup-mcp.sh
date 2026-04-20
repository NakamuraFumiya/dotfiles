#!/bin/bash
# Claude Code / Codex 用 MCP サーバーのセットアップスクリプト
# 新しいマシンでのセットアップ時や、MCP を再設定する際に実行する
#
# 実行前に ~/.secrets/mcp.env を作成して source してください:
#   source ~/.secrets/mcp.env && bash scripts/setup-mcp.sh

set -e

required_vars=(JIRA_URL JIRA_USERNAME JIRA_API_TOKEN KIBELA_ORIGIN KIBELA_ACCESS_TOKEN LINEAR_API_KEY GITHUB_PERSONAL_ACCESS_TOKEN METABASE_URL METABASE_USERNAME METABASE_PASSWORD)
missing=()

for var in "${required_vars[@]}"; do
  if [ -z "${!var}" ]; then
    missing+=("$var")
  fi
done

if [ ${#missing[@]} -ne 0 ]; then
  echo "Error: 以下の環境変数が設定されていません:"
  for var in "${missing[@]}"; do
    echo "  - $var"
  done
  echo ""
  echo "~/.secrets/mcp.env を作成して source してください"
  echo "  cp ~/dotfiles/templates/mcp.env.example ~/.secrets/mcp.env"
  exit 1
fi

setup_claude() {
  echo "==> Claude Code に MCP を登録..."

  echo "  - Atlassian"
  claude mcp add mcp-atlassian \
    --scope user \
    -e JIRA_URL="$JIRA_URL" \
    -e JIRA_USERNAME="$JIRA_USERNAME" \
    -e JIRA_API_TOKEN="$JIRA_API_TOKEN" \
    -- uvx --python 3.13 mcp-atlassian \
    || echo "    (スキップ: 既に登録済み)"

  echo "  - Kibela"
  claude mcp add kibela \
    --scope user \
    -e KIBELA_ORIGIN="$KIBELA_ORIGIN" \
    -e KIBELA_ACCESS_TOKEN="$KIBELA_ACCESS_TOKEN" \
    -- docker run -i \
      -e KIBELA_ORIGIN \
      -e KIBELA_ACCESS_TOKEN \
      ghcr.io/kibela/kibela-mcp-server \
    || echo "    (スキップ: 既に登録済み)"

  echo "  - Figma"
  claude mcp add figma \
    --scope user \
    --transport http \
    https://mcp.figma.com/mcp \
    || echo "    (スキップ: 既に登録済み)"

  echo "  - Notion"
  claude mcp add notion \
    --scope user \
    --transport http \
    https://mcp.notion.com/mcp \
    || echo "    (スキップ: 既に登録済み)"

  echo "  - Linear"
  claude mcp add linear \
    --scope user \
    -e LINEAR_API_KEY="$LINEAR_API_KEY" \
    -- npx -y @hatcloud/linear-mcp \
    || echo "    (スキップ: 既に登録済み)"

  echo "  - GitHub"
  claude mcp add github \
    --scope user \
    -e GITHUB_PERSONAL_ACCESS_TOKEN="$GITHUB_PERSONAL_ACCESS_TOKEN" \
    -- docker run -i --rm \
      -e GITHUB_PERSONAL_ACCESS_TOKEN \
      ghcr.io/github/github-mcp-server \
    || echo "    (スキップ: 既に登録済み)"

  echo "  - Playwright"
  claude mcp add playwright \
    --scope user \
    -- npx @playwright/mcp@latest \
    || echo "    (スキップ: 既に登録済み)"

  echo "  - Metabase"
  claude mcp add metabase \
    --scope user \
    -e METABASE_URL="$METABASE_URL" \
    -e METABASE_USERNAME="$METABASE_USERNAME" \
    -e METABASE_PASSWORD="$METABASE_PASSWORD" \
    -- npx -y @cognitionai/metabase-mcp-server --read \
    || echo "    (スキップ: 既に登録済み)"

  echo ""
  echo "==> Claude Code の登録済み MCP サーバー:"
  claude mcp list
}

setup_codex() {
  echo "==> Codex に MCP を登録..."

  echo "  - Atlassian"
  codex mcp add mcp-atlassian \
    --env JIRA_URL="$JIRA_URL" \
    --env JIRA_USERNAME="$JIRA_USERNAME" \
    --env JIRA_API_TOKEN="$JIRA_API_TOKEN" \
    -- uvx --python 3.13 mcp-atlassian \
    || echo "    (スキップ: 既に登録済み)"

  echo "  - Kibela"
  codex mcp add kibela \
    --env KIBELA_ORIGIN="$KIBELA_ORIGIN" \
    --env KIBELA_ACCESS_TOKEN="$KIBELA_ACCESS_TOKEN" \
    -- docker run -i \
      -e KIBELA_ORIGIN \
      -e KIBELA_ACCESS_TOKEN \
      ghcr.io/kibela/kibela-mcp-server \
    || echo "    (スキップ: 既に登録済み)"

  echo "  - Figma"
  codex mcp add figma \
    --url https://mcp.figma.com/mcp \
    || echo "    (スキップ: 既に登録済み)"

  echo "  - Notion"
  codex mcp add notion \
    --url https://mcp.notion.com/mcp \
    || echo "    (スキップ: 既に登録済み)"

  echo "  - Linear"
  codex mcp add linear \
    --env LINEAR_API_KEY="$LINEAR_API_KEY" \
    -- npx -y @hatcloud/linear-mcp \
    || echo "    (スキップ: 既に登録済み)"

  echo "  - GitHub"
  codex mcp add github \
    --env GITHUB_PERSONAL_ACCESS_TOKEN="$GITHUB_PERSONAL_ACCESS_TOKEN" \
    -- docker run -i --rm \
      -e GITHUB_PERSONAL_ACCESS_TOKEN \
      ghcr.io/github/github-mcp-server \
    || echo "    (スキップ: 既に登録済み)"

  echo "  - Playwright"
  codex mcp add playwright \
    -- npx @playwright/mcp@latest \
    || echo "    (スキップ: 既に登録済み)"

  echo "  - Metabase"
  codex mcp add metabase \
    --env METABASE_URL="$METABASE_URL" \
    --env METABASE_USERNAME="$METABASE_USERNAME" \
    --env METABASE_PASSWORD="$METABASE_PASSWORD" \
    -- npx -y @cognitionai/metabase-mcp-server --read \
    || echo "    (スキップ: 既に登録済み)"

  echo ""
  echo "==> Codex の登録済み MCP サーバー:"
  codex mcp list
}

if command -v claude >/dev/null 2>&1; then
  setup_claude
else
  echo "==> Claude Code は見つからないためスキップします"
fi

echo ""

if command -v codex >/dev/null 2>&1; then
  setup_codex
else
  echo "==> Codex は見つからないためスキップします"
fi

echo ""
echo "完了! Claude Code / Codex を再起動してください。"
