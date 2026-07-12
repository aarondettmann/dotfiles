-- Set <space> as leader key.
-- Set before plugins are loaded; otherwise wrong leader will be used.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Exit terminal mode
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]])

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Navigate display lines (visible wrapped lines) with jk and <Up>/<Down>
vim.keymap.set({ "n", "x" }, "j", "gj")
vim.keymap.set({ "n", "x" }, "k", "gk")
vim.keymap.set({ "n", "x" }, "<Down>", "gj")
vim.keymap.set({ "n", "x" }, "<Up>", "gk")

-- Split navigation: CTRL+<hjkl> to switch between windows (`:help wincmd`)
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Buffer navigation
vim.keymap.set("n", "<C-Right>", vim.cmd.bnext, { silent = true })
vim.keymap.set("n", "<C-Left>", vim.cmd.bprevious, { silent = true })

-- Buffer management: delete current buffer (normal / force)
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", {
  silent = true,
  desc = "Delete buffer",
})

vim.keymap.set("n", "<leader>bD", "<cmd>bdelete!<CR>", {
  silent = true,
  desc = "Force delete buffer",
})

-- Copy & paste selection to system clipboard
vim.keymap.set("v", "<C-c>", '"+y', { silent = true })
vim.keymap.set("i", "<C-v>", "<C-r>+", { silent = true })

-- Run current line through shell and replace it with output
vim.keymap.set("n", "<leader>!", function()
  local line = vim.api.nvim_get_current_line()
  local output = vim.fn.system(line)

  local lines = vim.split(output, "\n", { trimempty = true })
  vim.api.nvim_buf_set_lines(0, vim.fn.line(".") - 1, vim.fn.line("."), false, lines)
end, {
  silent = true,
  desc = "Run current line as shell command",
})

-- Open main Neovim config file
vim.keymap.set("n", "<leader>ev", function() vim.cmd("edit " .. vim.fn.stdpath("config") .. "/init.lua") end, {
  desc = "Edit init.lua",
})
--
-- Open ~/.bashrc
vim.keymap.set("n", "<leader>eb", function() vim.cmd.edit(vim.fn.expand("~/.bashrc")) end, {
  desc = "Edit .bashrc",
})

-- Toggle display of invisible characters
vim.keymap.set("n", "<leader>l", function() vim.o.list = not vim.o.list end, {
  desc = "Toggle invisible characters",
})

-- ROT13 the entire buffer
vim.keymap.set("n", "<leader>c", "ggg?G", { desc = "ROT13 buffer" })

-- Floating terminal
local terminal = require("core.floating_terminal")
vim.api.nvim_create_user_command("Floaterminal", terminal.toggle, {})
vim.keymap.set({ "n", "t" }, "<leader>tt", terminal.toggle, {
  desc = "Toggle floating terminal",
})

-- Spell checking convenience mappings
vim.keymap.set(
  "n",
  "<leader>ss",
  function() vim.opt_local.spell = not vim.opt_local.spell:get() end,
  { desc = "Toggle spell checking" }
)

vim.keymap.set(
  "n",
  "<leader>sle",
  function() vim.opt_local.spelllang = { "en_us" } end,
  { desc = "Spell language: English (US)" }
)

vim.keymap.set(
  "n",
  "<leader>slg",
  function() vim.opt_local.spelllang = { "de" } end,
  { desc = "Spell language: German" }
)

vim.keymap.set(
  "n",
  "<leader>sls",
  function() vim.opt_local.spelllang = { "sv" } end,
  { desc = "Spell language: Swedish" }
)
