--  ________
-- < neovim >
--  --------
--   \
--    \   \_\_    _/_/
--     \      \__/
--            (oo)\_______
--            (__)\       )\/\
--                ||----w |
--                ||     ||

local function source_if_readable(path)
  if vim.fn.filereadable(path) == 1 then
    vim.cmd.source(vim.fn.fnameescape(path))
    return true
  end
  return false
end

local shared_vimrc = vim.fn.expand("~/.vimrc")
if not source_if_readable(shared_vimrc) then
  local dotfiles_dir = vim.env.DOTFILES_DIR
  if dotfiles_dir and dotfiles_dir ~= "" then
    local normalized = dotfiles_dir:gsub("\\", "/")
    source_if_readable(normalized .. "/vim/.vimrc")
  end
end
