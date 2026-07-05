return function(gh)
  vim.pack.add({ gh("nvim-treesitter/nvim-treesitter") })

  local parsers = {
    "bash",
    "c",
    "diff",
    "html",
    "lua",
    "markdown",
    "vim",
    "vimdoc",
  }

  require("nvim-treesitter").install(parsers)

  vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
      local buf = args.buf
      local filetype = args.match

      local language = vim.treesitter.language.get_lang(filetype)
      if not language then return end

      -- Only start Treesitter if the parser can be loaded
      if vim.treesitter.language.add(language) then vim.treesitter.start(buf, language) end
    end,
  })
end
