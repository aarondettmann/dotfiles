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

    -- Symbol references under the cursor are highlighted by `Snacks.words`
    -- (see plugins/snacks.lua), which also maps `]]`/`[[` to jump between
    -- them. The inlay hint toggle (`<leader>th`) lives there as well.

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
        -- Neovim embeds LuaJIT, so load its standard library rather than the
        -- 5.4 one the server assumes by default.
        runtime = { version = "LuaJIT" },
        -- Without the Neovim runtime on the library path, `vim` is an unknown
        -- global: no completion, hover or signatures for the Neovim API. This
        -- covers `vim.*` only, not plugin modules such as `require("snacks")`.
        workspace = {
          checkThirdParty = false,
          library = { vim.env.VIMRUNTIME },
        },
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
