-- LSP servers, formatters, linters, completion.
local servers = {
  "basedpyright", "ruff", "clangd", "neocmake", "lua_ls", "bashls",
  "jsonls", "yamlls", "dockerls", "docker_compose_language_service", "marksman", "taplo",
}
local tools = { "stylua", "shfmt", "sqlfluff" }

return {
  -- Server configs for vim.lsp.config. Docs: https://github.com/neovim/nvim-lspconfig
  { "neovim/nvim-lspconfig", lazy = false },

  -- Installs servers/tools into ~/.local/share/nvim/mason. Docs: https://github.com/mason-org/mason.nvim
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {},
    config = function(_, opts)
      require("mason").setup(opts)
      local registry = require("mason-registry")
      registry.refresh(function()
        for _, name in ipairs(tools) do
          local ok, pkg = pcall(registry.get_package, name)
          if ok and not pkg:is_installed() then pkg:install() end
        end
      end)
    end,
  },

  -- Installs + enables the servers above. Docs: https://github.com/mason-org/mason-lspconfig.nvim
  {
    "mason-org/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
    opts = {
      ensure_installed = servers,
      -- rust-analyzer comes from rustup and is started by rustaceanvim.
      automatic_enable = { exclude = { "rust_analyzer" } },
    },
  },

  -- JSON/YAML schemas (used in config/lsp.lua). Docs: https://github.com/b0o/SchemaStore.nvim
  { "b0o/SchemaStore.nvim", version = false },

  -- Completion. Docs: https://cmp.saghen.dev
  {
    "saghen/blink.cmp",
    version = "1.*", -- prebuilt fuzzy matcher
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = {
      keymap = {
        preset = "enter",
        ["<Tab>"] = {
          function(cmp)
            if cmp.is_menu_visible() then
              return cmp.select_next()
            elseif vim.snippet.active({ direction = 1 }) then
              return vim.snippet.jump(1)
            end
          end,
          "fallback",
        },
        ["<S-Tab>"] = {
          function(cmp)
            if cmp.is_menu_visible() then
              return cmp.select_prev()
            elseif vim.snippet.active({ direction = -1 }) then
              return vim.snippet.jump(-1)
            end
          end,
          "fallback",
        },
      },
      completion = { documentation = { auto_show = true, auto_show_delay_ms = 200 } },
      signature = { enabled = true },
      sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        per_filetype = { sql = { "snippets", "dadbod", "buffer" } },
        providers = {
          lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
          dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
        },
      },
    },
  },

  -- Neovim Lua API types when editing this config. Docs: https://github.com/folke/lazydev.nvim
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = { library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } }, "snacks.nvim" } },
  },

  -- Format on save. Docs: https://github.com/stevearc/conform.nvim
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    keys = {
      { "<leader>cf", function() require("conform").format({ async = true }) end, mode = { "n", "x" }, desc = "Format" },
      {
        "<leader>uf",
        function()
          vim.g.disable_autoformat = not vim.g.disable_autoformat
          vim.notify("Format on save " .. (vim.g.disable_autoformat and "off" or "on"))
        end,
        desc = "Toggle format on save",
      },
    },
    opts = {
      formatters_by_ft = {
        python = { "ruff_organize_imports", "ruff_format" },
        lua = { "stylua" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        rust = { "rustfmt" },
        sh = { "shfmt" },
        fish = { "fish_indent" },
      },
      default_format_opts = { lsp_format = "fallback" },
      format_on_save = function()
        if vim.g.disable_autoformat then return end
        return { timeout_ms = 1000 }
      end,
    },
  },

  -- Extra linters. Docs: https://github.com/mfussenegger/nvim-lint
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufWritePost" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = { sql = { "sqlfluff" } }
      lint.linters.sqlfluff.args = { "lint", "--format=json", "--dialect=postgres", "-" }
      vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("lunkes_lint", { clear = true }),
        callback = function() lint.try_lint() end,
      })
    end,
  },
}
