-- ===========================================================
-- Completion & Snippets
-- Installs and configures the completion engine and snippet
-- support.
-- ===========================================================

return function(gh)
  vim.pack.add({
    gh("L3MON4D3/LuaSnip"),
    gh("rafamadriz/friendly-snippets"),
    gh("saghen/blink.cmp"),
  })

  require("luasnip").setup({})
  require("luasnip.loaders.from_vscode").lazy_load()

  require("blink.cmp").setup({
    keymap = {
      preset = "super-tab",
      ["<CR>"] = { "accept", "fallback" },
    },

    appearance = {
      nerd_font_variant = "mono",
    },

    sources = {
      default = {
        "lsp",
        "buffer",
        "path",
        "snippets",
      },
    },

    snippets = {
      preset = "luasnip",
    },

    completion = {
      menu = {
        auto_show = true,
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
      },
      ghost_text = {
        enabled = true,
      },
    },

    signature = {
      enabled = true,
    },
  })
end
