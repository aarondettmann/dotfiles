-- ===========================================================
-- Conform
-- Code formatting configuration.
-- ===========================================================

local gh = require("plugins.util").gh

vim.pack.add({
  gh("stevearc/conform.nvim"),
})

-- Opt in per filetype when format-on-save is desired. Only deliberate
-- `:write`s format: auto-saves (see core/autocmds.lua) are skipped, so text
-- does not reflow under the cursor on every edit.
local format_on_save_filetypes = {
  go = true,
  gomod = true,
  gosum = true,
  gowork = true,
}

local formatters_by_ft = {
  c = { "clang-format" },
  go = { "goimports", "gofumpt" },
  lua = { "stylua" },
  python = { "ruff_organize_imports", "ruff_format" },
}

local conform = require("conform")

conform.setup({
  notify_on_error = true,

  default_format_opts = {
    lsp_format = "fallback",
  },

  format_on_save = function(bufnr)
    if vim.b[bufnr].auto_save_write then
      return
    end

    if format_on_save_filetypes[vim.bo[bufnr].filetype] then
      return { timeout_ms = 500 }
    end
  end,

  formatters_by_ft = formatters_by_ft,
})

vim.keymap.set({ "n", "v" }, "<leader>f", function()
  conform.format({ async = true })
end, {
  desc = "[F]ormat buffer",
})
