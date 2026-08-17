-- ===========================================================
-- Orgmode
-- Installs and configures nvim-orgmode, headline bullets and
-- the Telescope pickers for headlines, tags, refiling and links.
--
-- Org structure is formatted with `gq`: nvim-orgmode sets `formatexpr`, so
-- `gqq` on a headline aligns its tags and `gqip` reformats a table.
-- ===========================================================

local edit_file = require("core.util").edit_file
local gh = require("plugins.util").gh

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
    -- A planning line rather than `%u`: the agenda ignores inactive dates
    -- (`[...]`), so a task captured with `%u` never shows up in a dated
    -- view. SCHEDULED additionally carries the task forward once its date
    -- passes ("Sched. 3x:"), which a bare active timestamp does not.
    t = {
      description = "Task",
      template = "* TODO %?\nSCHEDULED: %t",
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

  -- Don't show DONE items on their SCHEDULED/DEADLINE dates in the agenda.
  org_agenda_skip_scheduled_if_done = true,
  org_agenda_skip_deadline_if_done = true,

  -- In-editor reminders for DEADLINE and SCHEDULED dates.
  notifications = {
    enabled = true,
  },

  -- Open agenda and capture in floating windows instead of splits.
  win_split_mode = "float",
  win_border = "rounded",

  ui = {
    menu = {
      -- Replace the built-in keystroke menus (agenda, capture, export)
      -- with `vim.ui.select`, which telescope-ui-select renders as a
      -- dropdown. Quit is dropped since the picker closes with ESC.
      handler = function(data)
        local options = vim.tbl_filter(function(item)
          return item.key and item.label:lower() ~= "quit"
        end, data.items)
        vim.ui.select(options, {
          prompt = data.prompt,
          format_item = function(item)
            return item.label
          end,
        }, function(choice)
          if choice and choice.action then
            choice.action()
          end
        end)
      end,
    },
  },
})

for _, mapping in ipairs(org_pickers) do
  vim.keymap.set("n", mapping[1], picker(mapping[2]), { desc = "Orgmode: " .. mapping[3] })
end

-- File jumps live under the `[E]dit` group (`core/keymaps.lua`) rather than
-- `<leader>o`, which is Orgmode's own mapping prefix.
vim.keymap.set("n", "<leader>eo", function()
  edit_file(org_dir .. "/inbox.org")
end, { desc = "Edit inbox.org" })

vim.keymap.set("n", "<leader>eO", function()
  -- Pick from the loaded agenda files instead of globbing `org_dir`, which
  -- also holds non-Org files.
  vim.ui.select(require("orgmode").files:filenames(), {
    prompt = "Org files",
    format_item = function(filename)
      return vim.fn.fnamemodify(filename, ":t")
    end,
  }, function(choice)
    if choice then
      edit_file(choice)
    end
  end)
end, { desc = "Edit Org file" })

local org_group = vim.api.nvim_create_augroup("plugins-orgmode", { clear = true })

vim.api.nvim_create_autocmd("BufNew", {
  group = org_group,
  pattern = "*.org",
  desc = "Disable swap files for Org buffers",
  callback = function(args)
    -- Orgmode updates agenda files in the background via `bufadd()` +
    -- `nvim_open_win()`, a path where the swap-file check runs but the
    -- `SwapExists` autocmd does not fire. If another Neovim instance holds a
    -- swap file for the same org file, that raises E325 as an error instead
    -- of a prompt. `BufNew` fires inside `bufadd()`, before the buffer
    -- loads, so disabling `swapfile` here skips the check entirely.
    vim.bo[args.buf].swapfile = false
  end,
})

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
