return function(gh)
  vim.pack.add({ gh("L3MON4D3/LuaSnip") })
  require("luasnip").setup({})

  vim.pack.add({ gh("saghen/blink.cmp") })

  require("blink.cmp").setup({
    keymap = { preset = "default" },
    appearance = { nerd_font_variant = "mono" },
    sources = { default = { "lsp", "path", "snippets" } },
    snippets = { preset = "luasnip" },
    signature = { enabled = true },
  })
end
