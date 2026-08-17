-- ===========================================================
-- LaTeX & VimTeX
-- Installs VimTeX and configures PDF preview method.
-- ===========================================================

local gh = require("plugins.util").gh

vim.g.vimtex_view_method = "zathura"

vim.pack.add({
  gh("lervag/vimtex"),
})
