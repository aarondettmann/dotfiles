-- ===========================================================
-- Mason
-- Installs and manages external tools used by the Neovim config.
-- ===========================================================

local gh = require("plugins.util").gh

vim.pack.add({
  gh("mason-org/mason.nvim"),
  gh("WhoIsSethDaniel/mason-tool-installer.nvim"),
})

local ensure_installed = {
  "basedpyright",
  "clang-format",
  "clangd",
  "gofumpt",
  "goimports",
  "gopls",
  "lua-language-server",
  "ruff",
  "stylua",
}

table.sort(ensure_installed)

require("mason").setup()

require("mason-tool-installer").setup({
  ensure_installed = ensure_installed,
})
