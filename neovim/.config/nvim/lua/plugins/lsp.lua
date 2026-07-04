---@diagnostic disable: undefined-global

return function(gh)
  vim.pack.add {
    gh "neovim/nvim-lspconfig",
    gh "mason-org/mason.nvim",
    gh "mason-org/mason-lspconfig.nvim",
    gh "WhoIsSethDaniel/mason-tool-installer.nvim",
    gh "j-hui/fidget.nvim",
  }

  require("fidget").setup {}

  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(event)
      local map = function(keys, func, desc)
        vim.keymap.set("n", keys, func, {
          buffer = event.buf,
          desc = "LSP: " .. desc,
        })
      end

      map("grn", vim.lsp.buf.rename, "Rename")
      map("gra", vim.lsp.buf.code_action, "Code Action")
      map("grD", vim.lsp.buf.declaration, "Declaration")
    end,
  })

  local servers = {
    stylua = {},

    lua_ls = {
      on_init = function(client)
        client.server_capabilities.documentFormattingProvider = false
      end,
      settings = {
        Lua = { format = { enable = false } },
      },
    },
  }

  require("mason").setup()

  require("mason-tool-installer").setup {
    ensure_installed = vim.tbl_keys(servers),
  }

  for name, config in pairs(servers) do
    vim.lsp.config(name, config)
    vim.lsp.enable(name)
  end
end
