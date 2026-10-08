-- ===========================================================
-- Fuzzy Finder (Snacks.picker)
-- Keymaps for the picker: files, grep, help, buffers,
-- diagnostics, spelling and LSP lists. The picker itself is
-- configured in plugins/snacks.lua; the Orgmode pickers live in
-- plugins/orgmode.lua.
-- ===========================================================

-- Each entry: keys, picker source, description. Sources are looked up on
-- each call, so nothing here depends on `Snacks.picker` being loaded yet.
local pickers = {
  { "<leader>sf", "files", "[S]earch [F]iles" },
  { "<leader>sg", "grep", "[S]earch [G]rep" },
  { "<leader>sh", "help", "[S]earch [H]elp" },
  { "<leader>sw", "grep_word", "[S]earch current [W]ord" },
  { "<leader>sD", "diagnostics", "[S]earch [D]iagnostics" },
  { "<leader>sr", "resume", "[S]earch [R]esume" },
  { "<leader>s.", "recent", "[S]earch recent files" },
  { "<leader><leader>", "buffers", "Search open buffers" },
  -- Replaces the builtin spell suggestion menu
  { "z=", "spelling", "Spell suggestions" },
}

local function open(source)
  return function()
    Snacks.picker[source]()
  end
end

for _, mapping in ipairs(pickers) do
  vim.keymap.set("n", mapping[1], open(mapping[2]), { desc = mapping[3] })
end

local lsp_pickers = {
  { "grr", "lsp_references", "References" },
  { "grd", "lsp_definitions", "Definitions" },
  { "gri", "lsp_implementations", "Implementations" },
  { "grt", "lsp_type_definitions", "Type Definitions" },
  { "gO", "lsp_symbols", "Document Symbols" },
  { "<leader>sd", "lsp_symbols", "Search Document Symbols" },
  { "<leader>ss", "lsp_workspace_symbols", "Search Workspace Symbols" },
}

local lsp_attach_group = vim.api.nvim_create_augroup("plugins-picker-lsp-attach", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
  group = lsp_attach_group,
  desc = "Set picker-backed LSP keymaps",
  callback = function(event)
    for _, mapping in ipairs(lsp_pickers) do
      vim.keymap.set("n", mapping[1], open(mapping[2]), {
        buffer = event.buf,
        desc = "LSP: " .. mapping[3],
      })
    end
  end,
})
