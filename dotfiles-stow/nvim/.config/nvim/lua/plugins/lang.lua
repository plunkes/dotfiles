return {
  -- Rust: rust-analyzer + cargo commands. Docs: https://github.com/mrcjkb/rustaceanvim
  {
    "mrcjkb/rustaceanvim",
    version = "^8",
    lazy = false, -- the plugin lazy-loads itself on rust files
    init = function()
      vim.g.rustaceanvim = {
        server = {
          on_attach = function(_, buf)
            vim.keymap.set("n", "<leader>ca", function() vim.cmd.RustLsp("codeAction") end, { buffer = buf, desc = "Code action" })
            vim.keymap.set("n", "<leader>cr", function() vim.cmd.RustLsp("runnables") end, { buffer = buf, desc = "Run" })
            vim.keymap.set("n", "<leader>ct", function() vim.cmd.RustLsp("testables") end, { buffer = buf, desc = "Test" })
          end,
          default_settings = {
            ["rust-analyzer"] = { cargo = { allFeatures = true }, check = { command = "clippy" } },
          },
        },
      }
    end,
  },
  -- Cargo.toml versions/features. Docs: https://github.com/saecki/crates.nvim
  {
    "saecki/crates.nvim",
    event = "BufRead Cargo.toml",
    opts = { completion = { crates = { enabled = true } }, lsp = { enabled = true, actions = true, completion = true, hover = true } },
  },

  -- C/C++: clangd extras (header switch, AST, type hierarchy). Docs: https://github.com/p00f/clangd_extensions.nvim
  {
    "p00f/clangd_extensions.nvim",
    ft = { "c", "cpp" },
    opts = {},
    keys = { { "<leader>ch", "<cmd>LspClangdSwitchSourceHeader<cr>", desc = "Switch source/header", ft = { "c", "cpp" } } },
  },
  -- CMake configure/build/run. Docs: https://github.com/Civitasv/cmake-tools.nvim
  {
    "Civitasv/cmake-tools.nvim",
    ft = { "cmake", "c", "cpp" },
    opts = { cmake_build_directory = "build/${variant:buildType}" },
    keys = {
      { "<leader>cg", "<cmd>CMakeGenerate<cr>", desc = "CMake generate" },
      { "<leader>cb", "<cmd>CMakeBuild<cr>", desc = "CMake build" },
      { "<leader>cx", "<cmd>CMakeRun<cr>", desc = "CMake run" },
    },
  },

  -- Python: pick a venv from $VENV_HOME or the project. Docs: https://github.com/linux-cultist/venv-selector.nvim
  {
    "linux-cultist/venv-selector.nvim",
    ft = "python",
    cmd = "VenvSelect",
    opts = {
      search = {
        venv_home = { command = "fd '/bin/python$' " .. (vim.env.VENV_HOME or "~/progs/libs") .. " --full-path --color never -L" },
        project = { command = "fd '/bin/python$' . --full-path --color never -H -I -L -E node_modules" },
      },
      options = { notify_user_on_venv_activation = true },
    },
    keys = { { "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Select venv", ft = "python" } },
  },

  -- ROS 2: interface/node/topic pickers, msg highlighting. Docs: https://github.com/ErickKramer/nvim-ros2
  {
    "ErickKramer/nvim-ros2",
    dependencies = { "folke/snacks.nvim", "nvim-treesitter/nvim-treesitter" },
    ft = { "python", "cpp", "xml", "yaml", "rosmsg", "rossrv", "rosaction" },
    opts = { picker = "snacks", autocmds = true, treesitter = true },
    keys = {
      { "<leader>li", function() require("nvim-ros2").pickers.interfaces() end, desc = "Interfaces" },
      { "<leader>ln", function() require("nvim-ros2").pickers.nodes() end, desc = "Nodes" },
      { "<leader>la", function() require("nvim-ros2").pickers.actions() end, desc = "Actions" },
      { "<leader>lt", function() require("nvim-ros2").pickers.topics_info() end, desc = "Topics (info)" },
      { "<leader>le", function() require("nvim-ros2").pickers.topics_echo() end, desc = "Topics (echo)" },
      { "<leader>ls", function() require("nvim-ros2").pickers.services() end, desc = "Services" },
    },
  },

  -- Markdown rendered in the buffer. Docs: https://github.com/MeanderingProgrammer/render-markdown.nvim
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "markdown",
    opts = {},
    keys = { { "<leader>um", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle markdown render", ft = "markdown" } },
  },

  -- SQL client + completion. Docs: https://github.com/kristijanhusak/vim-dadbod-ui
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      "tpope/vim-dadbod",
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" } },
    },
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection" },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/dadbod_ui"
    end,
    keys = { { "<leader>D", "<cmd>DBUIToggle<cr>", desc = "Database UI" } },
  },
}
