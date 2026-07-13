-- ===========================================================
-- Language Server Protocol (LSP)
-- Installs and configures language servers, LSP keymaps, and
-- related tools.
-- ===========================================================

return function(gh)
  vim.pack.add({
    gh("neovim/nvim-lspconfig"),
    gh("j-hui/fidget.nvim"),
  })

  require("fidget").setup({})
  local lsp_attach_group = vim.api.nvim_create_augroup("plugins-lsp-attach", { clear = true })

  vim.api.nvim_create_autocmd("LspAttach", {
    group = lsp_attach_group,
    desc = "Set buffer-local LSP keymaps",
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
    lua_ls = {
      on_init = function(client) client.server_capabilities.documentFormattingProvider = false end,
      settings = {
        Lua = {
          format = { enable = false },
          diagnostics = { globals = { "vim" } },
        },
      },
    },
  }

  for name, config in pairs(servers) do
    vim.lsp.config(name, config)
    vim.lsp.enable(name)
  end
end
