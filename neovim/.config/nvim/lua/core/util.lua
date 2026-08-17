-- ============================================================
-- Core Helpers
-- Library module shared by the `core.*` and `plugins.*` modules.
-- Required on demand, so it is deliberately absent from
-- `core/init.lua`, which only loads side-effecting modules.
-- ============================================================

local M = {}

--- Open `path`, escaping the characters `:edit` would otherwise expand.
---@param path string
function M.edit_file(path)
  vim.cmd.edit(vim.fn.fnameescape(path))
end

return M
