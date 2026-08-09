-- ===========================================================
-- Orgmode
-- Installs and configures nvim-orgmode.
-- ===========================================================

return function(gh)
  vim.pack.add({
    gh("nvim-orgmode/orgmode"),
  })

  local org_dir = vim.fn.expand("~/projects/_personal/orgfiles")

  require("orgmode").setup({
    org_agenda_files = { org_dir .. "/**/*.org" },
    org_default_notes_file = org_dir .. "/inbox.org",
  })
end
