-- ===========================================================
-- Markdown & Document Rendering
-- Installs and configures inline previews for Markdown and
-- related document types.
-- ===========================================================

local gh = require("plugins.util").gh

vim.pack.add({
  gh("MeanderingProgrammer/render-markdown.nvim"),
})

require("render-markdown").setup({
  enabled = true,

  latex = {
    enabled = true,
  },

  -- The default `hide` conceals the closing fence, and with it the
  -- Mermaid diagram that Snacks renders below the fence
  code = {
    border = "thin",
  },

  file_types = {
    "markdown",
  },
})
