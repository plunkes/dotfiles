-- Leader must be set before lazy.nvim loads plugin keymaps.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.options")
require("config.lazy")
require("config.keymaps")
require("config.autocmds")
require("config.lsp")

require("config.theme").reload()
