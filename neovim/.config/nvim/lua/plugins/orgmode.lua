-- ===========================================================
-- Orgmode
-- Installs and configures nvim-orgmode, headline bullets and
-- the Telescope pickers for headlines, tags, refiling and links.
--
-- Org structure is formatted with `gq`: nvim-orgmode sets `formatexpr`, so
-- `gqq` on a headline aligns its tags and `gqip` reformats a table.
-- ===========================================================

local org_dir = vim.fn.expand("~/projects/_personal/orgfiles")

-- `telescope.extensions` loads and configures an extension on first access,
-- so resolving the picker lazily keeps this independent of module load order.
local function picker(name)
  return function()
    require("telescope").extensions.orgmode[name]()
  end
end

local org_pickers = {
  { "<leader>oh", "search_headings", "Search [H]eadlines" },
  { "<leader>oT", "search_tags", "Search [T]ags" },
  { "<leader>oR", "refile_heading", "[R]efile headline" },
  { "<leader>oL", "insert_link", "Insert [L]ink" },
}

return function(gh)
  vim.pack.add({
    gh("nvim-orgmode/org-bullets.nvim"),
    gh("nvim-orgmode/orgmode"),
    gh("nvim-orgmode/telescope-orgmode.nvim"),
  })

  require("org-bullets").setup()

  require("orgmode").setup({
    org_agenda_files = { org_dir .. "/**/*.org" },
    org_default_notes_file = org_dir .. "/inbox.org",

    -- Indent content virtually instead of writing indentation into the file.
    -- This implies `org_adapt_indentation = false`, so files stay flat on disk.
    org_startup_indented = true,
    -- `org-bullets` already renders the headline stars.
    org_indent_mode_turns_on_hiding_stars = false,

    -- Collect notes (`org_add_note`) in the same drawer that clocking uses,
    -- instead of appending them to the headline body.
    org_log_into_drawer = "LOGBOOK",

    -- Hiding markup requires `conceallevel`, which is set per buffer below.
    org_hide_emphasis_markers = true,

    -- Link to headlines by `id:` so links survive headline renames.
    org_id_link_to_org_use_id = true,

    -- Templates without a `target` are captured to `org_default_notes_file`.
    org_capture_templates = {
      t = {
        description = "Task",
        template = "* TODO %?\n%u",
      },
      n = {
        description = "Note",
        template = "* %?\n%u",
      },
      j = {
        description = "Journal",
        -- Refiling demotes the headline to fit the date tree.
        template = "* %U\n\n%?",
        target = org_dir .. "/journal.org",
        datetree = true,
      },
    },

    -- In-editor reminders for DEADLINE and SCHEDULED dates.
    notifications = {
      enabled = true,
    },
  })

  for _, mapping in ipairs(org_pickers) do
    vim.keymap.set("n", mapping[1], picker(mapping[2]), { desc = "Orgmode: " .. mapping[3] })
  end

  local org_group = vim.api.nvim_create_augroup("plugins-orgmode", { clear = true })

  vim.api.nvim_create_autocmd("FileType", {
    group = org_group,
    pattern = "org",
    desc = "Set Org buffer-local options",
    callback = function()
      -- Conceal emphasis markers and link brackets, except on the cursor line
      -- (the default `concealcursor` is empty).
      vim.opt_local.conceallevel = 2
    end,
  })
end
