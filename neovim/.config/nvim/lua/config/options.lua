---@diagnostic disable: undefined-global

-- Enable faster startup by caching compiled Lua modules
vim.loader.enable()

-- Create shorthand namespace
local opt = vim.opt
local g = vim.g

-- Disable default splash screen
opt.shortmess:append "I"

-- =========================
-- Global variables
-- =========================

g.have_nerd_font = false

-- =========================
-- UI
-- =========================

opt.number = true
opt.relativenumber = true

opt.cursorline = true
opt.signcolumn = "yes"

opt.scrolloff = 10

-- =========================
-- Input
-- =========================

opt.mouse = "a"
opt.timeoutlen = 300
opt.updatetime = 100

-- =========================
-- Behavior
-- =========================

opt.showmode = false
opt.clipboard = "unnamedplus"

opt.breakindent = true
opt.linebreak = true
opt.undofile = true

opt.ignorecase = true
opt.smartcase = true

opt.splitright = true
opt.splitbelow = true

opt.inccommand = "split"
opt.confirm = true

-- =========================
-- Whitespace rendering
-- =========================

opt.list = true
opt.listchars = {
  tab = "» ",
  trail = "·",
  nbsp = "␣",
  extends = "›",
  precedes = "‹",
  -- eol = "$",
}
