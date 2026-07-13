-- ===========================================================
-- Plugin Bootstrap (Entry Point)
-- Loads all plugin modules in the desired order:
-- - build hooks
-- - UI / UX plugins
-- - navigation (telescope)
-- - external tools (mason)
-- - LSP configuration
-- - formatting
-- - completion
-- - treesitter
-- - file utilities
-- ===========================================================

local gh = function(repo) return "https://github.com/" .. repo end

require("plugins.build")(gh) -- Core build / event hooks
require("plugins.ui")(gh) -- UI / core UX
require("plugins.telescope")(gh) -- Search / navigation
require("plugins.mason")(gh) -- External tools
require("plugins.lsp")(gh) -- LSP
require("plugins.formatting")(gh) -- Formatting
require("plugins.completion")(gh) -- Completion
require("plugins.treesitter")(gh) -- Treesitter
require("plugins.eunuch")(gh) -- Vim-Eunuch
