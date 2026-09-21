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

vim.api.nvim_create_user_command("CleanPlugins", function()
  -- A plugin is inactive when it is recorded in the lockfile (and present on
  -- disk) but was not added by any module above, which is what dropping it
  -- from the configuration leaves behind. `info = false` skips the per-plugin
  -- Git branch and tag queries, which are not needed here.
  local stale = {}

  for _, plugin in ipairs(vim.pack.get(nil, { info = false })) do
    if not plugin.active then
      table.insert(stale, plugin.spec.name)
    end
  end

  if #stale == 0 then
    vim.notify("No unused plugins to remove", vim.log.levels.INFO)
    return
  end

  -- Removal deletes the plugin directory and rewrites the lockfile, so ask
  -- first, unlike `:UpdatePlugins`.
  local prompt = ("Remove %d unused plugin(s)?\n%s"):format(#stale, table.concat(stale, "\n"))
  if vim.fn.confirm(prompt, "&Yes\n&No", 2) == 1 then
    vim.pack.del(stale)
  end
end, {
  desc = "Remove plugins that are no longer part of the configuration",
})
