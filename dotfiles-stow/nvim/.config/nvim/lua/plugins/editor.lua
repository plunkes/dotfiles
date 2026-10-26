return {
  -- Treesitter (main branch: parsers + queries; highlighting is native).
  -- Docs: https://github.com/nvim-treesitter/nvim-treesitter/tree/main
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local parsers = {
        "bash", "c", "cpp", "cmake", "diff", "dockerfile", "fish", "json", "lua", "luadoc",
        "markdown", "markdown_inline", "python", "query", "regex", "rust", "sql", "toml",
        "vim", "vimdoc", "xml", "yaml",
      }
      require("nvim-treesitter").install(parsers)
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("lunkes_ts", { clear = true }),
        callback = function(ev)
          if pcall(vim.treesitter.start, ev.buf) then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
  -- Textobject queries used by mini.ai (af/if, ac/ic).
  { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },

  -- Docs: https://github.com/echasnovski/mini.ai
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),
        },
      }
    end,
  },
  -- Docs: https://github.com/echasnovski/mini.pairs
  { "echasnovski/mini.pairs", event = "InsertEnter", opts = {} },
  -- gsa/gsd/gsr: add/delete/replace surroundings (s is flash). Docs: https://github.com/echasnovski/mini.surround
  {
    "echasnovski/mini.surround",
    event = "VeryLazy",
    opts = {
      mappings = {
        add = "gsa", delete = "gsd", find = "gsf", find_left = "gsF",
        highlight = "gsh", replace = "gsr", update_n_lines = "gsn",
      },
    },
  },
  -- Better comment strings in embedded languages. Docs: https://github.com/folke/ts-comments.nvim
  { "folke/ts-comments.nvim", event = "VeryLazy", opts = {} },

  -- Jump anywhere with s. Docs: https://github.com/folke/flash.nvim
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash treesitter" },
    },
  },

  -- Docs: https://github.com/lewis6991/gitsigns.nvim
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      on_attach = function(buf)
        local gs = require("gitsigns")
        local map = function(l, r, desc) vim.keymap.set("n", l, r, { buffer = buf, desc = desc }) end
        map("]h", function() gs.nav_hunk("next") end, "Next hunk")
        map("[h", function() gs.nav_hunk("prev") end, "Prev hunk")
        map("<leader>ghs", gs.stage_hunk, "Stage hunk")
        map("<leader>ghr", gs.reset_hunk, "Reset hunk")
        map("<leader>ghp", gs.preview_hunk_inline, "Preview hunk")
        map("<leader>ghd", gs.diffthis, "Diff this")
      end,
    },
  },

  -- Docs: https://github.com/folke/trouble.nvim
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {},
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix" },
      { "<leader>cs", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols outline" },
    },
  },

  -- Docs: https://github.com/folke/todo-comments.nvim
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Prev todo" },
      { "<leader>st", function() Snacks.picker.todo_comments() end, desc = "Todos" },
    },
  },
}
