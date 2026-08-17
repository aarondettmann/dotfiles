-- ===========================================================
-- Language Server Protocol (LSP)
-- Installs and configures language servers, LSP keymaps, and
-- related tools.
-- ===========================================================

local gh = require("plugins.util").gh

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

    map("gd", vim.lsp.buf.definition, "Definition")
    map("gD", vim.lsp.buf.declaration, "Declaration")
    map("gK", vim.lsp.buf.signature_help, "Signature Help")

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
      vim.lsp.codelens.enable(true, { bufnr = event.buf })
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
    -- Lua is formatted by `stylua` through Conform, so both formatting
    -- capabilities are dropped. Range formatting matters as much as document
    -- formatting: Neovim points `formatexpr` at the LSP for any server
    -- advertising it (`:help lsp-defaults`), which would otherwise hand `gq`
    -- to lua_ls and leave it doing nothing at all. See `ruff` below for the
    -- other server this applies to.
    on_init = function(client)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end,
    settings = {
      Lua = {
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
  -- Neovim logs everything a server writes to stderr at ERROR level, and
  -- `ruff server` reports routine workspace activity there, which grows
  -- `lsp.log` by megabytes. `--quiet` keeps diagnostics and drops the rest.
  ruff = {
    cmd = { "ruff", "server", "--quiet" },
    -- Same `formatexpr` hijack as lua_ls: Conform already runs `ruff format`,
    -- and the advertised range formatting only costs `gq` in Python buffers.
    -- Document formatting is left alone, since nothing routes to it.
    -- `gopls` needs no equivalent: it advertises document but not range
    -- formatting, so Neovim leaves `formatexpr` empty for Go. `clangd` does
    -- advertise it, but its range formatting works, so it keeps `gq`.
    on_init = function(client)
      client.server_capabilities.documentRangeFormattingProvider = false
    end,
  },
}

for name, config in pairs(servers) do
  vim.lsp.config(name, config)
end

vim.lsp.enable(vim.tbl_keys(servers))
