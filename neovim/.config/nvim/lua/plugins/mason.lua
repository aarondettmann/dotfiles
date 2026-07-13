-- ===========================================================
-- Mason
-- Installs and manages external tools used by the Neovim config.
-- ===========================================================

return function(gh)
  vim.pack.add({
    gh("mason-org/mason.nvim"),
    gh("WhoIsSethDaniel/mason-tool-installer.nvim"),
  })

  local ensure_installed = {
    "lua-language-server",
    "stylua",
  }

  table.sort(ensure_installed)

  require("mason").setup()

  require("mason-tool-installer").setup({
    ensure_installed = ensure_installed,
  })
end
