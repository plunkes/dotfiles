local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 6
opt.sidescrolloff = 8
opt.wrap = false
opt.termguicolors = true
opt.laststatus = 3
opt.showmode = false
opt.pumheight = 10
opt.winborder = "rounded"

opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true
opt.shiftround = true

opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "split"
opt.grepprg = "rg --vimgrep"

opt.splitbelow = true
opt.splitright = true
opt.clipboard = "unnamedplus"
opt.mouse = "a"
opt.undofile = true
opt.updatetime = 200
opt.timeoutlen = 300
opt.confirm = true
opt.completeopt = "menu,menuone,noselect"
opt.foldlevel = 99
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.g.omni_sql_no_default_maps = 1
