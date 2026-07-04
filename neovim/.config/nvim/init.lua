--[[
 ________
< neovim >
 --------
  \
   \   \_\_    _/_/
    \      \__/
           (oo)\_______
           (__)\       )\/\
               ||----w |
               ||     ||

Neovim configuration layout
---------------------------

init.lua
  Entry point. Loads all configuration modules.

lua/config/
  Core editor configuration that does not depend on plugins
  (options, keymaps, autocmds, etc.).

lua/plugins/
  Plugin management and plugin configuration.
  Each file is responsible for installing and configuring a related
  group of plugins. Requiring `plugins` loads the entire plugin setup.
--]]

-- Load order matters
--  1. Core options + keymaps (no plugin dependencies)
--  2. Plugins (must be loaded before any plugin-dependent config)
--  3. Feature configs (diagnostics, autocmds, formatting, etc.)
require("config.options")
require("config.keymaps")

require("plugins")

require("config.diagnostics")
require("config.autocmds")
require("config.formatting")
