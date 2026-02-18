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

## Claude Code MCP

### Prerequisites
- [Claude Code](https://claude.ai/claude-code) installed
- Docker running (required for Kibela MCP)

### Setup

**1. Create secrets file**

```bash
mkdir -p ~/.secrets
cp templates/claude-mcp.env.example ~/.secrets/claude-mcp.env
chmod 600 ~/.secrets/claude-mcp.env
```

Fill in `~/.secrets/claude-mcp.env`:

| Variable | Value | Token |
|---|---|---|
| `JIRA_URL` | `https://your-company.atlassian.net` | - |
| `JIRA_USERNAME` | Your Atlassian account email | - |
| `JIRA_API_TOKEN` | Jira API token | https://id.atlassian.com/manage-profile/security/api-tokens |
| `KIBELA_ORIGIN` | `https://your-subdomain.kibe.la` | - |
| `KIBELA_ACCESS_TOKEN` | Kibela access token | `https://your-subdomain.kibe.la/settings/access_tokens` |

**2. Register MCP servers** (exit Claude Code first)

```bash
source ~/.secrets/claude-mcp.env && bash scripts/setup-mcp.sh
```

**3. Restart Claude Code**
