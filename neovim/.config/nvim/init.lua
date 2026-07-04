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

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("plugins")

