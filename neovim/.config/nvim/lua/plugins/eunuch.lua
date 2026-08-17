-- ===========================================================
-- Vim-Eunuch
-- ===========================================================

local gh = require("plugins.util").gh

-- Do not let Eunuch remap insert-mode `<CR>` (shebang auto-completion):
-- it leaves a stray `=EunuchNewLine()` in the command line on every
-- newline. Auto-`chmod +x` for shebang files is unaffected.
vim.g.eunuch_no_maps = 1

vim.pack.add({
  gh("tpope/vim-eunuch"),
})
