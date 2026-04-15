# dotfiles

## setup
```
bash dotfile_link.sh
```

## mason.nvim
### Require Install
- biome
- goimports
- gopls
- helm-ls
- kube-linter
- typescript-language-server
- vtsls

## Claude Code / Codex MCP

### Prerequisites
- [Claude Code](https://claude.ai/claude-code) installed
- [Codex CLI](https://developers.openai.com/codex/cli/) installed
- Docker running (required for Kibela and GitHub MCP)

### Setup

**1. Create secrets file**

```bash
mkdir -p ~/.secrets
cp templates/mcp.env.example ~/.secrets/mcp.env
chmod 600 ~/.secrets/mcp.env
```

Fill in `~/.secrets/mcp.env`:

| Variable | Value | Token |
|---|---|---|
| `JIRA_URL` | `https://your-company.atlassian.net` | - |
| `JIRA_USERNAME` | Your Atlassian account email | - |
| `JIRA_API_TOKEN` | Jira API token | https://id.atlassian.com/manage-profile/security/api-tokens |
| `KIBELA_ORIGIN` | `https://your-subdomain.kibe.la` | - |
| `KIBELA_ACCESS_TOKEN` | Kibela access token | `https://your-subdomain.kibe.la/settings/access_tokens` |
| `LINEAR_API_KEY` | Linear Personal API Key | `https://linear.app/settings/api` |
| `GITHUB_PERSONAL_ACCESS_TOKEN` | GitHub Personal Access Token | `https://github.com/settings/personal-access-tokens` |

**2. Register MCP servers** (exit Claude Code / Codex first)

```bash
source ~/.secrets/mcp.env && bash scripts/setup-mcp.sh
```

This script registers the same MCP servers to both Claude Code and Codex when each CLI is installed.

**3. Restart Claude Code / Codex**

### Notes

- `figma` and `notion` are registered as HTTP MCP servers in Codex. If the server requires OAuth, run `codex mcp login <server-name>` afterwards.
- Codex stores MCP settings in `~/.codex/config.toml`.
