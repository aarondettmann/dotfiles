-- ===========================================================
-- Formatting (Conform)
-- Installs the Conform formatter plugin.
-- ===========================================================

return function(gh)
  vim.pack.add({
    gh("stevearc/conform.nvim"),
  })
end
