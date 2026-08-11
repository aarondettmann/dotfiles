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

  -- Unlisted buffers are excluded: plugins use file-backed but unlisted buffers
  -- as scratch space (Orgmode's capture window and the hidden windows it edits
  -- Org files through), and those must not be written on every change.
  return bo.buftype == ""
    and bo.buflisted
    and bo.modifiable
    and not bo.readonly
    and vim.api.nvim_buf_get_name(bufnr) ~= ""
end

local function auto_save(args)
  local bufnr = args.buf
  if not should_auto_save(bufnr) or not vim.bo[bufnr].modified then
    return
  end

  vim.api.nvim_buf_call(bufnr, function()
    -- Mark the write so BufWritePre hooks (Conform's format-on-save) can tell
    -- auto-saves from deliberate `:write`s and skip reformatting on every edit.
    vim.b.auto_save_write = true
    local ok, err = pcall(vim.cmd.update)
    vim.b.auto_save_write = nil
    if not ok then
      vim.notify(err, vim.log.levels.ERROR)
    end
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

local function is_prose(bufnr)
  local bo = vim.bo[bufnr]
  return bo.buftype == "" and (bo.filetype == "" or prose_filetypes[bo.filetype] or false)
end

-- 'spell' is window-local and sticks to the window across buffer switches, so
-- it has to be turned both on and off as buffers come and go. BufWinEnter runs
-- after filetype detection has finished; FileType covers later changes.
-- The spell language is a buffer-local option with a global default (set in
-- core/options.lua), so per-buffer language picks survive these events.
vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter" }, {
  group = prose_spell_group,
  desc = "Enable spell checking for prose buffers only",
  callback = function(args)
    vim.wo.spell = is_prose(args.buf)
  end,
})
