-- Colors follow the wallpaper: `wall` writes a base16 palette (matugen) to
-- stdpath("state")/matugen.lua and calls reload() in every running Neovim.
-- Without that file, the built-in retrobox scheme is used.
local M = {}

local palette_file = vim.fn.stdpath("state") .. "/matugen.lua"

function M.reload()
  local ok, palette = pcall(dofile, palette_file)
  if ok and type(palette) == "table" then
    require("mini.base16").setup({ palette = palette, use_cterm = false })
    vim.g.colors_name = "matugen"
  else
    vim.cmd.colorscheme("retrobox")
  end
  -- lualine's "auto" theme reads the new highlights.
  local has_lualine, lualine = pcall(require, "lualine")
  if has_lualine then lualine.setup(lualine.get_config()) end
end

return M
