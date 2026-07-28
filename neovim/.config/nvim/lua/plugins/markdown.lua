-- ===========================================================
-- Markdown & Document Rendering
-- Installs and configures inline previews for Markdown and
-- related document types.
-- ===========================================================

return function(gh)
  vim.pack.add({
    gh("MeanderingProgrammer/render-markdown.nvim"),
  })

  require("render-markdown").setup({
    enabled = true,

    latex = {
      enabled = true,
    },

    file_types = {
      "markdown",
    },
  })
end
