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

-- Core build / event hooks
require("plugins.build")(gh)

-- UI / core UX
require("plugins.ui")(gh)

-- Search / navigation
require("plugins.telescope")(gh)

-- LSP
require("plugins.lsp")(gh)

-- Formatting
require("plugins.formatting")(gh)

-- Completion
require("plugins.completion")(gh)

-- Treesitter
require("plugins.treesitter")(gh)

-- Config layer (must run after plugin installs)
require("config.formatting")
