---@diagnostic disable: undefined-global

return function(gh)
  vim.pack.add { gh "NMAC427/guess-indent.nvim" }
  require("guess-indent").setup {}

  vim.pack.add { gh "lewis6991/gitsigns.nvim" }
  require("gitsigns").setup {
    signs = {
      add = { text = "+" },
      change = { text = "~" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
    },
  }

  vim.pack.add { gh "folke/which-key.nvim" }
  require("which-key").setup {
    delay = 0,
    icons = { mappings = vim.g.have_nerd_font },
    spec = {
      { "<leader>s", group = "[S]earch", mode = { "n", "v" } },
      { "<leader>t", group = "[T]oggle" },
      { "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
      { "gr", group = "LSP Actions", mode = { "n" } },
    },
  }

  vim.pack.add { gh "ellisonleao/gruvbox.nvim" }
  require("gruvbox").setup {
    italic = { comments = false },
  }
  vim.o.background = "dark"
  vim.cmd.colorscheme("gruvbox")

  vim.pack.add { gh "folke/todo-comments.nvim" }
  require("todo-comments").setup { signs = false }

  vim.pack.add { gh "nvim-mini/mini.nvim" }

  if vim.g.have_nerd_font then
    require("mini.icons").setup()
    MiniIcons.mock_nvim_web_devicons()
  end

  require("mini.ai").setup {
    mappings = {
      around_next = "aa",
      inside_next = "ii",
    },
    n_lines = 500,
  }

  require("mini.surround").setup()

  vim.pack.add {
    gh "nvim-tree/nvim-web-devicons",
    gh "nvim-lualine/lualine.nvim",
  }

  require("lualine").setup {
    options = {
      theme = "gruvbox",
    },
  }
end
