-- ===========================================================
-- Conform
-- Code formatting configuration.
-- ===========================================================

local format_on_save_filetypes = {
  -- lua = true,
  -- python = true,
}

local formatters_by_ft = {
  -- lua = { "stylua" },
  -- python = { "ruff_format" },
}

return function(gh)
  vim.pack.add({
    gh("stevearc/conform.nvim"),
  })

  local conform = require("conform")

  conform.setup({
    notify_on_error = false,

    default_format_opts = {
      lsp_format = "fallback",
    },

    format_on_save = function(bufnr)
      if format_on_save_filetypes[vim.bo[bufnr].filetype] then return { timeout_ms = 500 } end
    end,

    formatters_by_ft = formatters_by_ft,
  })

  vim.keymap.set({ "n", "v" }, "<leader>f", function() conform.format({ async = true }) end, {
    desc = "[F]ormat buffer",
  })
end
