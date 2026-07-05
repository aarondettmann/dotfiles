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

-- Buffer navigation
vim.keymap.set("n", "<C-Right>", vim.cmd.bnext, { silent = true })
vim.keymap.set("n", "<C-Left>", vim.cmd.bprevious, { silent = true })

-- Close buffer (normal / force)
vim.keymap.set("n", "<C-Del>", vim.cmd.bdelete, { silent = true })
vim.keymap.set("n", "<C-S-Del>", function() vim.cmd.bdelete { bang = true } end, { silent = true })

-- Copy & paste selection to system clipboard
vim.keymap.set("v", "<C-c>", '"+y', { silent = true })
vim.keymap.set("i", "<C-v>", "<C-r>+", { silent = true })

-- Bubble single & multiple lines
vim.keymap.set("n", "<C-Up>", "m-2==", { silent = true })
vim.keymap.set("n", "<C-Down>", "m+==", { silent = true })
vim.keymap.set("v", "<C-Up>", ":move '<-2<CR>gv=gv", { silent = true })
vim.keymap.set("v", "<C-Down>", ":move '>+1<CR>gv=gv", { silent = true })

-- Run current line through shell and replace it with output
vim.keymap.set("n", "<leader>!", function()
  local line = vim.api.nvim_get_current_line()
  local output = vim.fn.system(line)

  local lines = vim.split(output, "\n", { trimempty = true })
  vim.api.nvim_buf_set_lines(0, vim.fn.line "." - 1, vim.fn.line ".", false, lines)
end, {
  silent = true,
  desc = "Run current line as shell command",
})

-- Open main Neovim config file
vim.keymap.set("n", "<leader>ev", function() vim.cmd("edit " .. vim.fn.stdpath "config" .. "/init.lua") end, {
  desc = "Edit init.lua",
})
--
-- Open ~/.bashrc
vim.keymap.set("n", "<leader>eb", function() vim.cmd.edit(vim.fn.expand "~/.bashrc") end, {
  desc = "Edit .bashrc",
})

-- Toggle display of invisible characters
vim.keymap.set("n", "<leader>l", function() vim.o.list = not vim.o.list end, {
  desc = "Toggle invisible characters",
})

-- ROT13 the entire buffer
vim.keymap.set("n", "<leader>c", "ggg?G", { desc = "ROT13 buffer" })
