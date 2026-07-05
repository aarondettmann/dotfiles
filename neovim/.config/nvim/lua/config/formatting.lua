-- ============================================================
-- Formatting
-- Configures conform.nvim for formatting and the <leader>f keymap.
-- External formatters can be configured via `formatters_by_ft`.
-- ============================================================

local conform = require "conform"

conform.setup {
  notify_on_error = false,

  format_on_save = function(bufnr)
    local enabled_filetypes = {}

    if enabled_filetypes[vim.bo[bufnr].filetype] then return { timeout_ms = 500 } end
  end,

  default_format_opts = {
    lsp_format = "fallback",
  },

  formatters_by_ft = {},
}

vim.keymap.set({ "n", "v" }, "<leader>f", function() conform.format { async = true } end, { desc = "[F]ormat buffer" })
