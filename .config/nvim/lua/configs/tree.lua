local ok, treesitter = pcall(require, 'nvim-treesitter.configs')
if ok then
  treesitter.setup {
    highlight = {
      enable = true,
      disable = {
      },
    },
    indent = {
      enable = true
    },
    ensure_installed = { 
      "go",
      "html",
      "json",
      "markdown",
      "markdown_inline",
      "scala",
      "scss",
      "sql",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "yaml",
      "javascript",
      "ruby",
      "lua"
    },
  }
end

require("nvim-tree").setup {
  view = {
    width = 50,
  },
  -- https://mogulla3.tech/articles/2024-01-02-configure-nvim-tree-lua-to-show-files-listed-in-gitignore/
  filters = {
    git_ignored = false, -- デフォルトはtrue
    custom = {
      -- "^\\.git",
      "^node_modules",
    },
  },
}

