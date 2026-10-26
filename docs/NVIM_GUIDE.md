# Neovim

Config: `dotfiles-stow/nvim/.config/nvim`. Plugins pinned in `lazy-lock.json`; update with `:Lazy update`, then commit the lockfile.
First start installs plugins, treesitter parsers and Mason servers (needs `npm`, `tree-sitter-cli`).

```
init.lua            leader, load order, colorscheme (retrobox)
lua/config/         options, keymaps, autocmds, lsp (native vim.lsp.config), lazy bootstrap
lua/plugins/        snacks, ui, editor, lsp, lang, ai
```

## Plugins

| Plugin | Role |
|---|---|
| [lazy.nvim](https://lazy.folke.io) | plugin manager |
| [snacks.nvim](https://github.com/folke/snacks.nvim) | picker, explorer, dashboard, lazygit, terminal, notifier, Kitty images |
| [which-key](https://github.com/folke/which-key.nvim) · [lualine](https://github.com/nvim-lualine/lualine.nvim) · [mini.icons](https://github.com/echasnovski/mini.icons) | key hints, statusline, icons |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter/tree/main) (main) | parsers, indent |
| [mini.ai](https://github.com/echasnovski/mini.ai) · [mini.pairs](https://github.com/echasnovski/mini.pairs) · [mini.surround](https://github.com/echasnovski/mini.surround) · [ts-comments](https://github.com/folke/ts-comments.nvim) · [flash](https://github.com/folke/flash.nvim) | text objects, pairs, surround, comments, jump |
| [gitsigns](https://github.com/lewis6991/gitsigns.nvim) · [trouble](https://github.com/folke/trouble.nvim) · [todo-comments](https://github.com/folke/todo-comments.nvim) | git hunks, diagnostics list, TODOs |
| [mason](https://github.com/mason-org/mason.nvim) + [mason-lspconfig](https://github.com/mason-org/mason-lspconfig.nvim) + [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | install + enable LSP servers |
| [blink.cmp](https://cmp.saghen.dev) · [friendly-snippets](https://github.com/rafamadriz/friendly-snippets) · [lazydev](https://github.com/folke/lazydev.nvim) · [SchemaStore](https://github.com/b0o/SchemaStore.nvim) | completion, snippets, Lua types, JSON/YAML schemas |
| [conform](https://github.com/stevearc/conform.nvim) · [nvim-lint](https://github.com/mfussenegger/nvim-lint) | format on save, sqlfluff |
| [rustaceanvim](https://github.com/mrcjkb/rustaceanvim) · [crates](https://github.com/saecki/crates.nvim) | Rust |
| [clangd_extensions](https://github.com/p00f/clangd_extensions.nvim) · [cmake-tools](https://github.com/Civitasv/cmake-tools.nvim) | C/C++ |
| [venv-selector](https://github.com/linux-cultist/venv-selector.nvim) | Python venvs (`$VENV_HOME` + project) |
| [nvim-ros2](https://github.com/ErickKramer/nvim-ros2) | ROS 2 pickers (snacks) |
| [render-markdown](https://github.com/MeanderingProgrammer/render-markdown.nvim) | Markdown |
| [vim-dadbod](https://github.com/tpope/vim-dadbod) + [ui](https://github.com/kristijanhusak/vim-dadbod-ui) + [completion](https://github.com/kristijanhusak/vim-dadbod-completion) | SQL |
| [claudecode](https://github.com/coder/claudecode.nvim) | Claude Code |

LSP servers: basedpyright, ruff, clangd, neocmake, lua_ls, bashls, jsonls, yamlls, dockerls, docker-compose, marksman, taplo. Rust uses rust-analyzer from rustup.

## Keys (leader = Space)

| Keys | Action |
|---|---|
| `<leader><space>` `<leader>/` `<leader>,` | find files · grep · buffers |
| `<leader>e` | explorer |
| `<leader>f` / `<leader>s` | find… / search… (which-key shows the list) |
| `gd` `gr` `gI` `gy` `K` | definition · references · implementation · type · hover |
| `grn` `gra` `<leader>cf` | rename · code action · format |
| `<leader>cv` `<leader>ch` `<leader>cb` | venv · header/source · CMake build |
| `<leader>xx` `]d` `[d` | diagnostics · next/prev |
| `<leader>gg` `]h` `<leader>gh…` | lazygit · next hunk · hunk actions |
| `<leader>l…` | ROS 2 (interfaces, nodes, topics, services) |
| `<leader>D` | database UI |
| `<leader>a…` | Claude Code |
| `s` `S` · `gsa` `gsd` `gsr` | flash jump · surround add/delete/replace |
| `<C-/>` | terminal |
| `<leader>uf` `<leader>uh` | toggle format-on-save · inlay hints |
