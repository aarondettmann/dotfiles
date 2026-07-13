-- ===========================================================
-- mini.nvim Helpers
-- Installs and configures the mini.nvim modules used by the
-- editor, including icon compatibility for UI plugins.
-- ===========================================================

return function(gh)
  vim.pack.add({
    gh("nvim-mini/mini.nvim"),
  })

  if vim.g.have_nerd_font then
    local mini_icons = require("mini.icons")
    mini_icons.setup()
    mini_icons.mock_nvim_web_devicons()
  end

  require("mini.ai").setup({
    mappings = {
      around_next = "aa",
      inside_next = "ii",
    },
    n_lines = 500,
  })

  require("mini.surround").setup()

  local mini_trailspace = require("mini.trailspace")
  mini_trailspace.setup()
  vim.keymap.set("n", "<F5>", mini_trailspace.trim, { desc = "Trim all trailing whitespace" })

  -- Text bubbling in visual and normal modes
  require("mini.move").setup({
    mappings = {
      -- Move visual selection in Visual mode
      left = "",
      right = "",
      down = "<C-Down>",
      up = "<C-Up>",

      -- Move current line in Normal mode
      line_left = "",
      line_right = "",
      line_down = "<C-Down>",
      line_up = "<C-Up>",
    },
  })

  require("mini.operators").setup({
    -- Exchange text regions
    exchange = {
      prefix = "cx",
      reindent_linewise = false,
    },
  })
end
