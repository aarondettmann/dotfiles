-- ===========================================================
-- Plugin Bootstrap (Entry Point)
-- Loads all plugin modules in the correct order:
-- - core build hooks
-- - UI / UX plugins
-- - navigation (telescope)
-- - LSP configuration
-- - formatting
-- - completion
-- - treesitter
-- - final config layer (post-install configuration)
-- ===========================================================

local gh = function(repo) return "https://github.com/" .. repo end

require("plugins.build")(gh) -- Core build / event hooks
require("plugins.ui")(gh) -- UI / core UX
require("plugins.telescope")(gh) -- Search / navigation
require("plugins.lsp")(gh) -- LSP
require("plugins.formatting")(gh) -- Formatting
require("plugins.completion")(gh) -- Completion
require("plugins.treesitter")(gh) -- Treesitter
require("plugins.eunuch")(gh) -- Eunuch
