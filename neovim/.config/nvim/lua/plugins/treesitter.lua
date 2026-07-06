-- ===========================================================
-- Treesitter
-- Installs language parsers and enables Treesitter highlighting automatically.
-- ===========================================================

return function(gh)
  vim.pack.add({
    gh("nvim-treesitter/nvim-treesitter"),
  })

  local parsers = {
    "bash",
    "c",
    "diff",
    "gitcommit",
    "html",
    "lua",
    "markdown",
    "vim",
    "vimdoc",
  }

  require("nvim-treesitter").install(parsers)

  vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
      local lang = vim.treesitter.language.get_lang(args.match)
      if not lang then
        return
      end

      -- Safely start Treesitter if a parser exists for this language
      pcall(vim.treesitter.start, args.buf, lang)
    end,
  })
end
