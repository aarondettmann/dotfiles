-- ===========================================================
-- Plugin Helpers
-- Library module shared by the `plugins.*` modules. Required on
-- demand, so it is deliberately absent from `plugins/init.lua`,
-- which only loads side-effecting modules.
-- ===========================================================

local M = {}

--- Expand an `owner/repo` shorthand into a source URL for `vim.pack.add()`.
--- See the "Use shorter source" section of `:help vim.pack`.
---@param repo string
---@return string
function M.gh(repo)
  return "https://github.com/" .. repo
end

return M
