-- ============================================================
-- Floating Terminal Plugin
-- Adds a floating terminal that can be toggled on or off.
-- Inspired by https://youtu.be/5PIiKDES_wc
-- ============================================================

local M = {}

local state = {
  buf = nil,
  win = nil,
}

local function open_float(buf)
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
  })

  -- Floating window options
  local wo = vim.wo[win]
  wo.number = false
  wo.relativenumber = false
  wo.signcolumn = "no"
  wo.cursorline = false

  return win
end

function M.toggle()
  -- Hide the window if it's already visible
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_hide(state.win)
    return
  end

  -- Create the terminal buffer the first time.
  if not (state.buf and vim.api.nvim_buf_is_valid(state.buf)) then
    state.buf = vim.api.nvim_create_buf(false, false)
  end

  state.win = open_float(state.buf)

  -- Start a shell if this isn't already a terminal buffer
  if vim.bo[state.buf].buftype ~= "terminal" then
    vim.cmd.terminal()
  end
end

return M
