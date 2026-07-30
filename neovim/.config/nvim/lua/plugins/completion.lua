-- ===========================================================
-- Completion & Snippets
-- Installs and configures the completion engine and snippet
-- support.
-- ===========================================================

return function(gh)
  vim.pack.add({
    gh("L3MON4D3/LuaSnip"),
    gh("rafamadriz/friendly-snippets"),
    gh("saghen/blink.lib"),
    gh("saghen/blink.cmp"),
  })

  require("luasnip").setup({})
  require("luasnip.loaders.from_vscode").lazy_load()

  local blink = require("blink.cmp")
  blink.build():pwait()
  blink.setup({
    keymap = {
      preset = "enter",

      ["<Tab>"] = {
        "select_next",
        "snippet_forward",
        "fallback",
      },

      ["<S-Tab>"] = {
        "select_prev",
        "snippet_backward",
        "fallback",
      },
    },

    appearance = {
      nerd_font_variant = "mono",
    },

    fuzzy = {
      implementation = "prefer_rust_with_warning",
    },

    snippets = {
      preset = "luasnip",
    },

    sources = {
      default = {
        "lsp",
        "path",
        "snippets",
        "buffer",
      },
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

    cmdline = {
      keymap = {
        preset = "cmdline",
        ["<CR>"] = { "fallback" },
      },

      completion = {
        menu = {
          auto_show = false,
        },
      },
    },

    term = {
      enabled = false,
    },
  })
end
