-- ===========================================================
-- Snacks
-- Installs and configures shared Snacks utilities, plus the
-- `Snacks.toggle` mappings (defined here rather than in
-- `core/keymaps.lua` because they depend on Snacks).
-- ===========================================================

local gh = require("plugins.util").gh

vim.pack.add({
  gh("folke/snacks.nvim"),
})

-- Directories skipped by the file and grep pickers when hidden files are
-- included (`fd --exclude` and `rg --glob '!...'`; a pattern without a slash
-- matches at any depth). Both pickers already exclude `.git`.
local search_excludes = {
  ".venv",
  "node_modules",
}

require("snacks").setup({
  -- Disable Treesitter and other expensive features in very large files
  bigfile = { enabled = true },

  -- Floating-window UI for `vim.ui.input` (used by Orgmode prompts, LSP
  -- rename, etc.) instead of the bare command line
  input = { enabled = true },

  -- Render `vim.notify` messages as floating notifications; without this
  -- they only land in `:messages` (auto-save errors, build hook failures)
  notifier = { enabled = true },

  -- Highlight LSP references of the symbol under the cursor and jump
  -- between them with `]]` and `[[`
  words = { enabled = true },

  -- Fuzzy finder (keymaps in plugins/picker.lua). Enabling it also routes
  -- `vim.ui.select` (Orgmode menus, code actions, ...) through the picker.
  picker = {
    enabled = true,

    sources = {
      files = {
        hidden = true,
        follow = true,
        exclude = search_excludes,
      },
      grep = {
        hidden = true,
        exclude = search_excludes,
      },
      -- Buffers are listed most recently used first; without the current
      -- one, the previous buffer is the first selection.
      buffers = {
        current = false,
      },
      -- A `vim.ui.select` prompt returns a single item, so the default
      -- `<Tab>` (mark and move) only clutters the list; move instead.
      select = {
        win = {
          input = {
            keys = {
              ["<Tab>"] = { "list_down", mode = { "i", "n" } },
              ["<S-Tab>"] = { "list_up", mode = { "i", "n" } },
            },
          },
        },
      },
    },
  },

  image = {
    enabled = true,
    math = { enabled = false },

    -- Inline previews for documents (Markdown, LaTeX, etc.)
    doc = {
      enabled = true, -- Render document images
      inline = true, -- Display images directly in the buffer
      float = true, -- Fall back to floating windows when needed
      max_width = 80, -- Maximum image width (cells)
      max_height = 40, -- Maximum image height (cells)
    },

    -- Render Markdown image links and LaTeX math blocks
    markdown = {
      enabled = true,
    },

    -- Convert unsupported formats (PDF, SVG, videos, Office docs, ...)
    -- using external tools like ImageMagick, Poppler and FFmpeg
    convert = {
      notify = false, -- Don't show conversion notifications
    },
  },
  terminal = {
    win = {
      position = "float",
      width = 0.8,
      height = 0.8,
      border = "rounded",
      backdrop = false,
      keys = {
        term_normal = false,
      },
    },
  },
})

-- ~~~~~~~~~~ Toggle mappings ~~~~~~~~~~
-- `Snacks.toggle` registers each mapping with which-key, which then shows
-- the current on/off state next to the description.
Snacks.toggle.option("list", { name = "Invisible Characters" }):map("<leader>tl")
Snacks.toggle.option("wrap", { name = "Line Wrapping" }):map("<leader>tw")
Snacks.toggle.option("spell", { name = "Spell Checking" }):map("<leader>tst")
Snacks.toggle.inlay_hints():map("<leader>th")

-- Inline diagnostics are off by default (see core/diagnostics.lua). Virtual
-- text and underlines are toggled together; `Snacks.toggle.diagnostics()`
-- would disable diagnostics entirely, signs included.
Snacks.toggle({
  name = "Diagnostic Virtual Text",
  get = function()
    return vim.diagnostic.config().virtual_text ~= false
  end,
  set = function(enabled)
    vim.diagnostic.config({
      virtual_text = enabled,
      underline = enabled and { severity = { min = vim.diagnostic.severity.WARN } } or false,
    })
  end,
}):map("<leader>td")
