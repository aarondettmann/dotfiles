-- ============================================================
-- Autocommands
-- Defines event-driven editor behavior using Neovim autocmds.
-- ============================================================

local highlight_yank_group = vim.api.nvim_create_augroup("core-highlight-yank", { clear = true })
local auto_save_group = vim.api.nvim_create_augroup("core-auto-save", { clear = true })
local terminal_insert_group = vim.api.nvim_create_augroup("core-terminal-insert", { clear = true })
local prose_spell_group = vim.api.nvim_create_augroup("core-prose-spell", { clear = true })

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = highlight_yank_group,
  callback = function()
    vim.hl.on_yank()
  end,
})

local function should_auto_save(bufnr)
  local bo = vim.bo[bufnr]

  return bo.buftype == "" and bo.modifiable and not bo.readonly and vim.api.nvim_buf_get_name(bufnr) ~= ""
end

local function auto_save(args)
  local bufnr = args.buf
  if not should_auto_save(bufnr) or not vim.bo[bufnr].modified then
    return
  end

  vim.api.nvim_buf_call(bufnr, function()
    vim.cmd.update()
  end)
end

-- Auto-save files when leaving insert mode or when text changes
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
  group = auto_save_group,
  desc = "Write editable named buffers after changes",
  callback = auto_save,
})

-- Automatically enter Terminal-mode when opening a terminal buffer
vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter" }, {
  group = terminal_insert_group,
  desc = "Enter insert mode when focusing terminal buffers",
  pattern = "term://*",
  callback = function()
    vim.cmd("startinsert")
  end,
})

-- Enable spell checking for prose buffers and plain text files while ignoring special buffers
local prose_filetypes = {
  gitcommit = true,
  markdown = true,
  org = true,
  rst = true,
  text = true,
  typst = true,
}

local function enable_spell(args)
  local bufnr = args.buf
  local bo = vim.bo[bufnr]
  if bo.buftype ~= "" then
    return
  end

  if bo.filetype == "" or prose_filetypes[bo.filetype] then
    vim.opt_local.spell = true
    vim.opt_local.spelllang = { "en_us" }
  end
end

vim.api.nvim_create_autocmd({ "FileType", "BufReadPost", "BufNewFile" }, {
  group = prose_spell_group,
  desc = "Enable spell checking for prose-oriented buffers",
  callback = enable_spell,
})
