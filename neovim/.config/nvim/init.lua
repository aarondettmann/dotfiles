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
.
├── init.lua         │ Entry point. Loads all configuration modules.
│
└── lua
   ├── core          │ Core editor configuration that does not depend
   │   ├── init.lua  │ on plugins (options, keymaps, autocmds, etc.).
   │   ├── ...
   │   └── ...
   │
   └── plugins       │ Plugin management and plugin configuration.
       ├── init.lua  │ Each file is responsible for installing and
       ├── ...       │ configuring a related group of plugins.
       └── ...
--]]

require("core")
require("plugins")
