---@diagnostic disable: undefined-global

-- Set <space> as leader key.
-- Set before plugins are loaded; otherwise wrong leader will be used.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Exit terminal mode
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]])

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Split navigation: CTRL+<hjkl> to switch between windows (`:help wincmd`)
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
