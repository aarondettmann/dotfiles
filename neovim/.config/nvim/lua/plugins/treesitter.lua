-- ===========================================================
-- Treesitter
-- Installs language parsers and enables Treesitter highlighting automatically.
-- ===========================================================

local gh = require("plugins.util").gh

vim.pack.add({
  gh("nvim-treesitter/nvim-treesitter"),
})
local treesitter_start_group = vim.api.nvim_create_augroup("plugins-treesitter-start", { clear = true })

local parsers = {
  "bash",
  "c",
  "css",
  "diff",
  "gitcommit",
  "go",
  "gomod",
  "gosum",
  "gowork",
  "html",
  "javascript",
  "latex",
  "lua",
  "markdown",
  "markdown_inline",
  "python",
  "scss",
  "svelte",
  "tsx",
  "typst",
  "vim",
  "vimdoc",
  "vue",
  "yaml",
}

-- Building parsers requires the tree-sitter CLI; warn once instead of erroring
-- per parser
if vim.fn.executable("tree-sitter") == 1 then
  require("nvim-treesitter").install(parsers)
else
  local installed = require("nvim-treesitter").get_installed("parsers")
  local missing = vim.tbl_filter(function(lang)
    return not vim.list_contains(installed, lang)
  end, parsers)
  if #missing > 0 then
    vim.notify(
      ("tree-sitter CLI not found; parsers not installed: %s"):format(table.concat(missing, ", ")),
      vim.log.levels.WARN
    )
  end
end

vim.api.nvim_create_autocmd("FileType", {
  group = treesitter_start_group,
  desc = "Start Treesitter when a parser is available",
  callback = function(args)
    -- Some plugins ship their own parser and start Treesitter from their own
    -- ftplugin (nvim-orgmode does). Do not attach a second highlighter.
    if vim.b[args.buf].ts_highlight then
      return
    end

    local lang = vim.treesitter.language.get_lang(args.match)
    if not lang then
      return
    end

    -- Safely start Treesitter if a parser exists for this language
    pcall(vim.treesitter.start, args.buf, lang)
  end,
})
