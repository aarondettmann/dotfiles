-- ===========================================================
-- User Interface (UI)
-- Installs and configures visual enhancements, editor UI, and
-- appearance.
-- ===========================================================

return function(gh)
  vim.pack.add({
    gh("NMAC427/guess-indent.nvim"),
    gh("akinsho/bufferline.nvim"),
    gh("ellisonleao/gruvbox.nvim"),
    gh("folke/snacks.nvim"),
    gh("folke/todo-comments.nvim"),
    gh("folke/which-key.nvim"),
    gh("lewis6991/gitsigns.nvim"),
    gh("nvim-lualine/lualine.nvim"),
    gh("nvim-mini/mini.nvim"),
    gh("nvim-tree/nvim-web-devicons"),
  })

  require("guess-indent").setup({})

  require("gitsigns").setup({
    signs = {
      add = { text = "+" },
      change = { text = "~" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
    },
  })

  require("which-key").setup({
    delay = 0,
    icons = { mappings = vim.g.have_nerd_font },
    spec = {
      { "<leader>s", group = "[S]earch", mode = { "n", "v" } },
      { "<leader>t", group = "[T]oggle" },
      { "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
      { "gr", group = "LSP Actions", mode = { "n" } },
    },
  })

  require("snacks").setup({
    image = {
      enabled = true,

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

  require("gruvbox").setup({
    italic = { comments = false },
  })
  vim.o.background = "dark"
  vim.cmd.colorscheme("gruvbox")

  require("todo-comments").setup({
    signs = false,
  })

  if vim.g.have_nerd_font then
    require("mini.icons").setup()
    MiniIcons.mock_nvim_web_devicons()
  end

  require("mini.ai").setup({
    mappings = {
      around_next = "aa",
      inside_next = "ii",
    },
    n_lines = 500,
  })

  require("mini.surround").setup()

  require("mini.trailspace").setup()
  vim.keymap.set("n", "<F5>", MiniTrailspace.trim, { desc = "Trim all trailing whitespace" })

  -- Text bubbling in visual and normal modes
  require("mini.move").setup({
    mappings = {
      -- Move visual selection in Visual mode
      left = "<C-Left>",
      right = "<C-Right>",
      down = "<C-Down>",
      up = "<C-Up>",

      -- Move current line in Normal mode
      line_left = "<C-Left>",
      line_right = "<C-Right>",
      line_down = "<C-Down>",
      line_up = "<C-Up>",
    },
  })

  require("mini.operators").setup({
    -- Exchange text regions
    exchange = {
      prefix = "cx",
      reindent_linewise = false,
    },
  })

  require("bufferline").setup({
    options = {
      diagnostics = "nvim_lsp",
      separator_style = "thin",
    },
  })

  require("lualine").setup({
    options = {
      theme = "gruvbox",
    },
  })
end
