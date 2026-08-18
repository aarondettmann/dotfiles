-- ============================================================
-- Diagnostics
-- Configures how LSP diagnostics are displayed and interacted with.
-- Controls virtual text, floating windows, severity rules, and
-- keymaps for navigating and listing diagnostics.
-- ============================================================

local diagnostic_underline = { severity = { min = vim.diagnostic.severity.WARN } }

vim.diagnostic.config({
  update_in_insert = false,
  severity_sort = true,
  float = { border = "rounded", source = "if_many" },

  -- Inline diagnostics are off by default (toggle with `<leader>td`)
  underline = false,
  virtual_text = false, -- At the end of the line
  virtual_lines = false, -- Underneath the line, with virtual lines

  -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
  jump = {
    on_jump = function(_, bufnr)
      vim.diagnostic.open_float({
        bufnr = bufnr,
        scope = "cursor",
        focus = false,
      })
    end,
  },
})

vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "Open diagnostic [L]ocation list" })

vim.keymap.set("n", "<leader>td", function()
  local config = vim.diagnostic.config()
  local enabled = not config.virtual_text
  vim.diagnostic.config({
    virtual_text = enabled,
    underline = enabled and diagnostic_underline or false,
  })
end, { desc = "Toggle diagnostic text and underlines" })
