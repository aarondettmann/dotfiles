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
      local client = event.data and vim.lsp.get_client_by_id(event.data.client_id)
      local map = function(keys, func, desc)
        vim.keymap.set("n", keys, func, {
          buffer = event.buf,
          desc = "LSP: " .. desc,
        })
      end

      if client and client.name == "ruff" then
        client.server_capabilities.hoverProvider = false
      end

      map("K", vim.lsp.buf.hover, "Hover Documentation")
      map("gd", vim.lsp.buf.definition, "Definition")
      map("gD", vim.lsp.buf.declaration, "Declaration")
      map("gK", vim.lsp.buf.signature_help, "Signature Help")
      map("grn", vim.lsp.buf.rename, "Rename")
      map("gra", vim.lsp.buf.code_action, "Code Action")

      if client and client.name == "clangd" then
        map("grh", "<cmd>LspClangdSwitchSourceHeader<CR>", "Switch Source/Header")
      end

      if client and client:supports_method("textDocument/inlayHint") then
        map("<leader>th", function()
          local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf })
          vim.lsp.inlay_hint.enable(not enabled, { bufnr = event.buf })
        end, "Toggle Inlay Hints")
      end

      if client and client:supports_method("textDocument/documentHighlight") then
        local document_highlight_group =
          vim.api.nvim_create_augroup("plugins-lsp-highlight-" .. event.buf, { clear = true })

        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
          group = document_highlight_group,
          buffer = event.buf,
          desc = "Highlight symbol references under cursor",
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "BufLeave" }, {
          group = document_highlight_group,
          buffer = event.buf,
          desc = "Clear symbol reference highlights",
          callback = vim.lsp.buf.clear_references,
        })
      end

      if client and client:supports_method("textDocument/codeLens") then
        local codelens_group = vim.api.nvim_create_augroup("plugins-lsp-codelens-" .. event.buf, { clear = true })

        map("grx", vim.lsp.codelens.run, "Run CodeLens")

        vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
          group = codelens_group,
          buffer = event.buf,
          desc = "Refresh LSP code lenses",
          callback = function()
            vim.lsp.codelens.refresh({ bufnr = event.buf })
          end,
        })

        vim.lsp.codelens.refresh({ bufnr = event.buf })
      end
    end,
  })

  local servers = {
    basedpyright = {
      settings = {
        basedpyright = {
          disableOrganizeImports = true,
        },
      },
    },
    clangd = {
      cmd = { "clangd", "--clang-tidy" },
    },
    lua_ls = {
      on_init = function(client)
        client.server_capabilities.documentFormattingProvider = false
      end,
      settings = {
        Lua = {
          format = { enable = false },
          diagnostics = { globals = { "vim" } },
        },
      },
    },
    gopls = {
      settings = {
        gopls = {
          analyses = {
            unusedparams = true,
          },
          codelenses = {
            test = true,
          },
          completeUnimported = true,
          gofumpt = true,
          staticcheck = true,
          usePlaceholders = true,
        },
      },
    },
    ruff = {},
  }

  for name, config in pairs(servers) do
    vim.lsp.config(name, config)
    vim.lsp.enable(name)
  end
end
