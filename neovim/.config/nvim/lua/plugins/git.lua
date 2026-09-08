-- ===========================================================
-- Git Integrations
-- Installs and configures Git-aware editor features.
-- ===========================================================

local gh = require("plugins.util").gh

vim.pack.add({
  gh("lewis6991/gitsigns.nvim"),
})

local gitsigns = require("gitsigns")

gitsigns.setup({
  signs = {
    add = { text = "+" },
    change = { text = "~" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
  },

  -- Buffer-local mappings, set only for buffers that belong to a Git
  -- repository. Hunk mappings live under `<leader>h`; `]c`/`[c` mirror the
  -- builtin diff-mode jumps (`:help ]c`).
  on_attach = function(bufnr)
    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = "Git: " .. desc })
    end

    map("n", "]c", function()
      gitsigns.nav_hunk("next")
    end, "Next hunk")
    map("n", "[c", function()
      gitsigns.nav_hunk("prev")
    end, "Previous hunk")

    map("n", "<leader>hs", gitsigns.stage_hunk, "Stage hunk")
    map("n", "<leader>hr", gitsigns.reset_hunk, "Reset hunk")
    map("x", "<leader>hs", function()
      gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, "Stage selected lines")
    map("x", "<leader>hr", function()
      gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, "Reset selected lines")

    map("n", "<leader>hp", gitsigns.preview_hunk, "Preview hunk")
    map("n", "<leader>hb", gitsigns.blame_line, "Blame line")

    map({ "o", "x" }, "ih", gitsigns.select_hunk, "Select hunk")
  end,
})
