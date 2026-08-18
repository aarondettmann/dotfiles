-- ============================================================
-- Core settings
-- ============================================================

-- Enable faster startup by caching compiled Lua modules
vim.loader.enable()

-- Create shorthand namespace
local opt = vim.opt
local g = vim.g

-- Disable default splash screen
opt.shortmess:append("I")

-- ~~~~~~~~~~ Global variables ~~~~~~~~~~
g.have_nerd_font = true

-- Disable unused remote plugin hosts and their `:checkhealth` warnings
g.loaded_node_provider = 0
g.loaded_perl_provider = 0
g.loaded_python3_provider = 0
g.loaded_ruby_provider = 0

-- ~~~~~~~~~~ UI ~~~~~~~~~~
opt.number = true
opt.relativenumber = true

opt.cursorline = true
opt.signcolumn = "yes"

opt.scrolloff = 8

-- ~~~~~~~~~~ Input ~~~~~~~~~~
opt.mouse = "" -- Mouse disabled in all modes
opt.timeoutlen = 300
opt.updatetime = 100

-- ~~~~~~~~~~ Behavior ~~~~~~~~~~
opt.showmode = false -- Mode shown in statusline
opt.clipboard = ""

opt.breakindent = true
opt.linebreak = true
opt.undofile = true

opt.ignorecase = true
opt.smartcase = true

-- Default spell language; buffers where spell is enabled inherit it
-- (see core/autocmds.lua and the `<leader>ts*` mappings)
opt.spelllang = "en_us"

opt.splitright = true
opt.splitbelow = true

opt.inccommand = "split"
opt.confirm = true

-- ~~~~~~~~~~ Whitespace rendering ~~~~~~~~~~
-- Disable invisibles by default
opt.list = false
opt.listchars = {
  tab = "» ",
  trail = "·",
  nbsp = "␣",
  extends = "›",
  precedes = "‹",
  eol = "$",
}

-- ~~~~~~~~~~ Miscellaneous ~~~~~~~~~~
-- Allow `:cd %%` to expand to the directory of the current file (Vim-style shortcut)
vim.cmd([[
  cnoreabbrev <expr> %% getcmdtype() == ':' ? expand('%:p:h') : '%%'
]])
