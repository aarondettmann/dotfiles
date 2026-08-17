-- ===========================================================
-- Plugin Bootstrap (Entry Point)
-- Each module below installs its plugins with `vim.pack.add()`
-- and configures them, so this is also the order in which
-- plugins are added and set up.
-- ===========================================================

require("plugins.build") -- First: the build hooks must be registered before any `vim.pack.add()`
require("plugins.mini")
require("plugins.snacks")
require("plugins.ui")
require("plugins.git")
require("plugins.markdown")
require("plugins.orgmode")
require("plugins.tex")
require("plugins.telescope")
require("plugins.mason") -- Before `plugins.lsp`: puts Mason's `bin` directory on `$PATH`
require("plugins.lsp")
require("plugins.formatting")
require("plugins.completion")
require("plugins.treesitter")
require("plugins.eunuch")

vim.api.nvim_create_user_command("UpdatePlugins", function()
  vim.pack.update(nil, { force = true })
end, {
  desc = "Update all plugins without confirmation",
})
