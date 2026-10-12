-- ===========================================================
-- Orgmode
-- Installs and configures nvim-orgmode, headline bullets and
-- the pickers for headlines, tags, refiling and links
-- (telescope-orgmode with its Snacks adapter; no Telescope).
--
-- Org structure is formatted with `gq`: nvim-orgmode sets `formatexpr`, so
-- `gqq` on a headline aligns its tags and `gqip` reformats a table.
-- ===========================================================

local edit_file = require("core.util").edit_file
local gh = require("plugins.util").gh

local org_dir = vim.fn.expand("~/projects/_personal/orgfiles")

-- Resolved on each call, so the module is only loaded once a picker is used.
local function picker(name)
  return function()
    require("telescope-orgmode")[name]()
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

-- Despite its name the plugin runs on `Snacks.picker` (see plugins/snacks.lua)
-- and does not load Telescope with this adapter.
require("telescope-orgmode").setup({
  adapter = "snacks",
})

require("orgmode").setup({
  org_agenda_files = { org_dir .. "/**/*.org" },
  -- Fallback for templates without a `target`.
  org_default_notes_file = org_dir .. "/todo.org",
  -- Relative to the archived file's directory; created on first use.
  org_archive_location = "archive/%s_archive::",

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

  -- Standalone tasks go to `todo.org`, project tasks under their project
  -- headline, dated thoughts to the journal; hence no plain note template.
  --
  -- The `vim.ui.select` menu below shows descriptions only, so the keys
  -- just set the order (sorted by key). `t` must stay: it overrides the
  -- plugin's built-in `t` template, which is merged in otherwise.
  org_capture_templates = {
    -- A planning line rather than `%u`: the agenda ignores inactive dates
    -- (`[...]`), so a task captured with `%u` never shows up in a dated
    -- view. SCHEDULED additionally carries the task forward once its date
    -- passes ("Sched. 3x:"), which a bare active timestamp does not.
    -- `%^t` opens the calendar on today; closing it without a date
    -- cancels the capture, so every task has a SCHEDULED date.
    t = {
      description = "Task",
      template = "* TODO %?\nSCHEDULED: %^t",
      target = org_dir .. "/todo.org",
    },
    u = {
      description = "Journal",
      -- Refiling demotes the headline to fit the date tree.
      template = "* %U\n\n%?",
      target = org_dir .. "/journal.org",
      datetree = true,
    },
    -- Appended at the end of the file; refile under a project if needed.
    v = {
      description = "Idea",
      template = "* %?",
      target = org_dir .. "/ideas.org",
    },
  },

  -- Don't show DONE items on their SCHEDULED/DEADLINE dates in the agenda.
  org_agenda_skip_scheduled_if_done = true,
  org_agenda_skip_deadline_if_done = true,

  -- Today's agenda, then all open tasks not already shown there (`past`
  -- includes today). Opened directly by `<leader>oa` below.
  org_agenda_custom_commands = {
    d = {
      description = "Today and open tasks",
      types = {
        {
          type = "agenda",
          org_agenda_span = "day",
          org_agenda_overriding_header = "Today",
        },
        {
          type = "tags_todo",
          match = "",
          org_agenda_overriding_header = "Open tasks",
          org_agenda_todo_ignore_scheduled = "past",
        },
      },
    },
  },

  -- In-editor reminders for DEADLINE and SCHEDULED dates.
  notifications = {
    enabled = true,
  },

  -- Agenda menu on `<leader>oA`, freeing `<leader>oa`. The plugin attaches
  -- global mappings deferred, so a later `vim.keymap.set` cannot override.
  mappings = {
    global = {
      org_agenda = "<prefix>A",
    },
  },

  -- Open agenda and capture in floating windows instead of splits.
  win_split_mode = "float",
  win_border = "rounded",

  ui = {
    menu = {
      -- Replace the built-in keystroke menus (agenda, capture, export)
      -- with `vim.ui.select`, which `Snacks.picker` renders (`ui_select`
      -- in plugins/snacks.lua). Quit is dropped since the picker closes
      -- with ESC.
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

vim.keymap.set("n", "<leader>oa", function()
  require("orgmode").agenda:open_by_key("d")
end, { desc = "Orgmode: [A]genda (today and open tasks)" })

-- The headline picker matches headlines only; this searches body text too.
vim.keymap.set("n", "<leader>og", function()
  Snacks.picker.grep({ cwd = org_dir })
end, { desc = "Orgmode: [G]rep Org files" })

-- File jumps live under the `[E]dit` group (`core/keymaps.lua`) rather than
-- `<leader>o`, which is Orgmode's own mapping prefix.
vim.keymap.set("n", "<leader>eo", function()
  edit_file(org_dir .. "/todo.org")
end, { desc = "Edit todo.org" })

vim.keymap.set("n", "<leader>ej", function()
  edit_file(org_dir .. "/journal.org")
end, { desc = "Edit journal.org" })

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
