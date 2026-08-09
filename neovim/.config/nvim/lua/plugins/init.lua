-- ===========================================================
-- Plugin Bootstrap (Entry Point)
-- Loads all plugin modules in the desired order:
-- - build hooks
-- - mini.nvim helpers
-- - Snacks utilities
-- - UI / UX plugins
-- - git integrations
-- - markdown / document rendering
-- - navigation (telescope)
-- - external tools (mason)
-- - LSP configuration
-- - formatting
-- - completion
-- - treesitter
-- - file utilities
-- ===========================================================

local gh = function(repo)
  return "https://github.com/" .. repo
end

require("plugins.build")(gh) -- Core build / event hooks
require("plugins.mini")(gh) -- mini.nvim helpers / icon compatibility
require("plugins.snacks")(gh) -- Snacks utilities
require("plugins.ui")(gh) -- UI / core UX
require("plugins.git")(gh) -- Git integrations
require("plugins.markdown")(gh) -- Markdown / document rendering
require("plugins.orgmode")(gh) -- Orgmode notes / agenda / capture
require("plugins.tex")(gh) -- LaTeX / VimTeX
require("plugins.telescope")(gh) -- Search / navigation
require("plugins.mason")(gh) -- External tools
require("plugins.lsp")(gh) -- LSP
require("plugins.formatting")(gh) -- Formatting
require("plugins.completion")(gh) -- Completion
require("plugins.treesitter")(gh) -- Treesitter
require("plugins.eunuch")(gh) -- Vim-Eunuch

vim.api.nvim_create_user_command("UpdatePlugins", function()
  vim.pack.update(nil, { force = true })
end, {
  desc = "Update all plugins without confirmation",
})
