-- ===========================================================
-- Git Integrations
-- Installs and configures Git-aware editor features.
-- ===========================================================

local gh = require("plugins.util").gh

vim.pack.add({
  gh("lewis6991/gitsigns.nvim"),
})

require("gitsigns").setup({
  signs = {
    add = { text = "+" },
    change = { text = "~" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
  },
})
