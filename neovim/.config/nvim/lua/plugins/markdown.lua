-- ===========================================================
-- Markdown & Document Rendering
-- Installs and configures inline previews for Markdown and
-- related document types.
-- ===========================================================

return function(gh)
  vim.pack.add({
    gh("folke/snacks.nvim"),
    gh("MeanderingProgrammer/render-markdown.nvim"),
  })

  require("snacks").setup({
    image = {
      enabled = true,
      math = { enabled = false },

      -- Inline previews for documents (Markdown, LaTeX, etc.)
      doc = {
        enabled = true, -- Render document images
        inline = true, -- Display images directly in the buffer
        float = true, -- Fall back to floating windows when needed
        max_width = 80, -- Maximum image width (cells)
        max_height = 40, -- Maximum image height (cells)
      },

      -- Render Markdown image links and LaTeX math blocks
      markdown = {
        enabled = true,
      },

      -- Convert unsupported formats (PDF, SVG, videos, Office docs, ...)
      -- using external tools like ImageMagick, Poppler and FFmpeg
      convert = {
        notify = false, -- Don't show conversion notifications
      },
    },
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
