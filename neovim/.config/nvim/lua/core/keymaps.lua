-- Set <space> as leader key.
-- Set before plugins are loaded; otherwise wrong leader will be used.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local function set_spell_language(language)
  return function()
    vim.opt_local.spelllang = { language }
  end
end

local function edit_file(path)
  vim.cmd.edit(vim.fn.fnameescape(path))
end

local function toggle_terminal()
  Snacks.terminal.toggle()
end

-- Exit terminal mode
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]])

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Navigate display lines (visible wrapped lines) with jk and <Up>/<Down>
local wrapped_line_mappings = {
  { "j", "gj" },
  { "k", "gk" },
  { "<Down>", "gj" },
  { "<Up>", "gk" },
}

for _, mapping in ipairs(wrapped_line_mappings) do
  vim.keymap.set({ "n", "x" }, mapping[1], mapping[2])
end

-- Split navigation: CTRL+<hjkl> to switch between windows (`:help wincmd`)
local window_navigation_mappings = {
  { "<C-h>", "<C-w><C-h>", "Move focus to the left window" },
  { "<C-l>", "<C-w><C-l>", "Move focus to the right window" },
  { "<C-j>", "<C-w><C-j>", "Move focus to the lower window" },
  { "<C-k>", "<C-w><C-k>", "Move focus to the upper window" },
}

for _, mapping in ipairs(window_navigation_mappings) do
  vim.keymap.set("n", mapping[1], mapping[2], { desc = mapping[3] })
end

-- Buffer navigation
vim.keymap.set("n", "<C-Right>", vim.cmd.bnext, { silent = true })
vim.keymap.set("n", "<C-Left>", vim.cmd.bprevious, { silent = true })

-- Buffer management: delete current buffer (normal / force)
vim.keymap.set("n", "<leader>bn", "<cmd>enew<CR>", {
  silent = true,
  desc = "New buffer",
})

vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", {
  silent = true,
  desc = "Delete buffer",
})

vim.keymap.set("n", "<leader>bD", "<cmd>bdelete!<CR>", {
  silent = true,
  desc = "Force delete buffer",
})

-- System clipboard
vim.keymap.set({ "n", "x" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", '"+yy', { desc = "Yank line to system clipboard" })
vim.keymap.set({ "n", "x" }, "<leader>p", '"+p', { desc = "Paste from system clipboard" })
-- vim.keymap.set("v", "<C-c>", '"+y', { silent = true })
-- vim.keymap.set("i", "<C-v>", "<C-r>+", { silent = true })

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
vim.keymap.set("n", "<leader>ev", function()
  edit_file(vim.fn.stdpath("config") .. "/init.lua")
end, {
  desc = "Edit init.lua",
})
-- Open ~/.bashrc
vim.keymap.set("n", "<leader>eb", function()
  edit_file(vim.fn.expand("~/.bashrc"))
end, {
  desc = "Edit .bashrc",
})

-- Toggle display of invisible characters
vim.keymap.set("n", "<leader>tl", function()
  vim.o.list = not vim.o.list
end, {
  desc = "Toggle invisible characters",
})

-- ROT13 the entire buffer
vim.keymap.set("n", "<leader>c", "ggg?G", { desc = "ROT13 buffer" })

-- Floating terminal
vim.api.nvim_create_user_command("Floaterminal", toggle_terminal, {
  desc = "Toggle floating terminal",
})
vim.keymap.set({ "n", "t" }, "<leader>tt", toggle_terminal, {
  desc = "Toggle floating terminal",
})

-- Spell checking convenience mappings
vim.keymap.set("n", "<leader>tst", function()
  vim.opt_local.spell = not vim.opt_local.spell:get()
end, { desc = "Toggle spell checking" })

local spell_language_mappings = {
  { "<leader>tse", "en_us", "Spell language: English (US)" },
  { "<leader>tsg", "de", "Spell language: German" },
  { "<leader>tss", "sv", "Spell language: Swedish" },
}

for _, mapping in ipairs(spell_language_mappings) do
  vim.keymap.set("n", mapping[1], set_spell_language(mapping[2]), { desc = mapping[3] })
end
