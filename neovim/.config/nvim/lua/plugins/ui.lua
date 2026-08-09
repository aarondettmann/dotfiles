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
    gh("folke/todo-comments.nvim"),
    gh("folke/which-key.nvim"),
    gh("nvim-lualine/lualine.nvim"),
  })

  require("guess-indent").setup({})

  require("which-key").setup({
    delay = 0,
    icons = { mappings = vim.g.have_nerd_font },
    spec = {
      { "<leader>b", group = "[B]uffer" },
      { "<leader>d", group = "[D]iagnostics" },
      { "<leader>e", group = "[E]dit" },
      { "<leader>o", group = "[O]rgmode" },
      { "<leader>s", group = "[S]earch", mode = { "n", "v" } },
      { "<leader>t", group = "[T]oggle" },
      { "<leader>ts", group = "[S]pell" },
      { "gr", group = "LSP Actions", mode = { "n" } },
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
    sections = {
      lualine_c = {
        { "filename", path = 3 },
      },
    },
  })
end
