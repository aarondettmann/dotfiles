-- ===========================================================
-- LaTeX & VimTeX
-- Installs VimTeX and configures PDF preview method.
-- ===========================================================

return function(gh)
  vim.g.vimtex_view_method = "zathura"

  vim.pack.add({
    gh("lervag/vimtex"),
  })
end
