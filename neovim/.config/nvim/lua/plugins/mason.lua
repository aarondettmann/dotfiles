-- ===========================================================
-- Mason
-- Installs and manages external tools used by the Neovim config.
-- ===========================================================

local gh = require("plugins.util").gh

vim.pack.add({
  gh("mason-org/mason.nvim"),
  gh("WhoIsSethDaniel/mason-tool-installer.nvim"),
})

require("mason").setup()

require("mason-tool-installer").setup({
  ensure_installed = {
    "basedpyright",
    "clang-format",
    "clangd",
    "gofumpt",
    "goimports",
    "gopls",
    "lua-language-server",
    "ruff",
    "stylua",
  },
})
