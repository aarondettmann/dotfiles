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
  callback = function()
    vim.cmd("startinsert")
  end,
})
