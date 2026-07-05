return function(gh)
  local telescope_plugins = {
    gh("nvim-lua/plenary.nvim"),
    gh("nvim-telescope/telescope.nvim"),
    gh("nvim-telescope/telescope-ui-select.nvim"),
  }

  if vim.fn.executable("make") == 1 then
    table.insert(telescope_plugins, gh("nvim-telescope/telescope-fzf-native.nvim"))
  end

  vim.pack.add(telescope_plugins)

  require("telescope").setup({
    extensions = {
      ["ui-select"] = require("telescope.themes").get_dropdown(),
    },
  })

  pcall(require("telescope").load_extension, "fzf")
  pcall(require("telescope").load_extension, "ui-select")

  local builtin = require("telescope.builtin")

  vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
  vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch [G]rep" })
  vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })

  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(event)
      vim.keymap.set("n", "grr", builtin.lsp_references, { buffer = event.buf })
      vim.keymap.set("n", "grd", builtin.lsp_definitions, { buffer = event.buf })
      vim.keymap.set("n", "gri", builtin.lsp_implementations, { buffer = event.buf })
      vim.keymap.set("n", "gO", builtin.lsp_document_symbols, { buffer = event.buf })
    end,
  })
end
