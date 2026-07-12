-- ============================================================
-- Autocommands
-- Defines event-driven editor behavior using Neovim autocmds.
-- ============================================================

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- Auto-save files when leaving insert mode or when text changes
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
  pattern = "*",
  callback = function() vim.cmd("silent! update") end,
})

-- Automatically enter Terminal-mode when opening a terminal buffer
vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter" }, {
  pattern = "term://*",
  callback = function() vim.cmd("startinsert") end,
})

-- Enable spell checking for prose buffers and plain text files while ignoring special buffers
local prose_filetypes = {
  gitcommit = true,
  markdown = true,
  rst = true,
  text = true,
  typst = true,
}

local function enable_spell()
  if vim.bo.buftype ~= "" then return end

  if vim.bo.filetype == "" or prose_filetypes[vim.bo.filetype] then
    vim.opt_local.spell = true
    vim.opt_local.spelllang = { "en_us" }
  end
end

vim.api.nvim_create_autocmd({ "FileType", "BufReadPost", "BufNewFile" }, {
  callback = enable_spell,
})
