-- ===========================================================
-- Plugin Build Hooks (PackChanged)
-- Automatically runs build steps after plugin install/update events.
-- This module is used to compile native dependencies and trigger
-- post-install setup commands for specific plugins managed by the
-- pack system.
-- ===========================================================

return function(gh)
  local has_make = vim.fn.executable("make") == 1

  local function run_build(name, cmd, cwd)
    local result = vim.system(cmd, { cwd = cwd }):wait()

    if result.code ~= 0 then
      local output = (result.stderr and result.stderr ~= "" and result.stderr)
        or result.stdout
        or "No output from build command."

      vim.notify(
        ("Build failed for %s (cmd: %s)\n%s"):format(name, table.concat(cmd, " "), output),
        vim.log.levels.ERROR
      )
    end
  end

  vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
      if not ev or not ev.data then return end

      local name = ev.data.spec and ev.data.spec.name
      local kind = ev.data.kind
      local path = ev.data.path

      if kind ~= "install" and kind ~= "update" then return end

      if not name or not path then return end

      -- telescope-fzf-native build
      if name == "telescope-fzf-native.nvim" and has_make then run_build(name, { "make" }, path) end

      -- LuaSnip optional JS regex engine build
      if name == "LuaSnip" and not vim.fn.has("win32") == 1 and has_make then
        run_build(name, { "make", "install_jsregexp" }, path)
      end

      -- Treesitter post-update hook
      if name == "nvim-treesitter" then
        if ev.data.active == false then
          vim.cmd.packadd("nvim-treesitter") -- ensure loaded
        end

        vim.schedule(function() vim.cmd("silent TSUpdate") end)
      end
    end,
  })
end
