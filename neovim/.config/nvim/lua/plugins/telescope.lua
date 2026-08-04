-- ===========================================================
-- Fuzzy Finder (Telescope)
-- Installs and configures Telescope search UI, extensions,
-- and keymaps.
-- ===========================================================

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

  local telescope = require("telescope")
  local hidden_search_excludes = {
    ".git",
    ".venv",
    "node_modules",
  }

  -- Choose correct `fd` executable. Ubuntu ships `fdfind` instead of `fd`.
  local find_files_binary = vim.fn.executable("fd") == 1 and "fd"
    or (vim.fn.executable("fdfind") == 1 and "fdfind" or nil)
  local find_files_command

  if find_files_binary then
    find_files_command = {
      find_files_binary,
      "--type",
      "f",
      "--hidden",
      "--follow",
    }

    for _, pattern in ipairs(hidden_search_excludes) do
      table.insert(find_files_command, "--exclude")
      table.insert(find_files_command, pattern)
    end
  end

  telescope.setup({
    defaults = {
      path_display = { "smart" },
    },
    pickers = {
      find_files = {
        find_command = find_files_command,
      },
      live_grep = {
        additional_args = function()
          local args = { "--hidden" }

          for _, pattern in ipairs(hidden_search_excludes) do
            table.insert(args, "--glob")
            table.insert(args, "!" .. pattern .. "/**")
          end

          return args
        end,
      },
    },
    extensions = {
      ["ui-select"] = require("telescope.themes").get_dropdown(),
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case",
      },
    },
  })

  pcall(telescope.load_extension, "fzf")
  pcall(telescope.load_extension, "ui-select")

  local builtin = require("telescope.builtin")
  local lsp_attach_group = vim.api.nvim_create_augroup("plugins-telescope-lsp-attach", { clear = true })

  vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
  vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch [G]rep" })
  vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })

  vim.api.nvim_create_autocmd("LspAttach", {
    group = lsp_attach_group,
    desc = "Set Telescope-powered LSP keymaps",
    callback = function(event)
      local map = function(keys, picker, desc)
        vim.keymap.set("n", keys, picker, {
          buffer = event.buf,
          desc = "LSP: " .. desc,
        })
      end

      map("grr", builtin.lsp_references, "References")
      map("grd", builtin.lsp_definitions, "Definitions")
      map("gri", builtin.lsp_implementations, "Implementations")
      map("grt", builtin.lsp_type_definitions, "Type Definitions")
      map("gO", builtin.lsp_document_symbols, "Document Symbols")
      map("<leader>sd", builtin.lsp_document_symbols, "Search Document Symbols")
      map("<leader>ss", builtin.lsp_dynamic_workspace_symbols, "Search Workspace Symbols")
    end,
  })
end
