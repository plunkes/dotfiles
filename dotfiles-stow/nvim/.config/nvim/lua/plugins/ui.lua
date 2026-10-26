return {
  -- Key hints. Docs: https://github.com/folke/which-key.nvim
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      spec = {
        { "<leader>a", group = "ai" },
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>D", group = "database" },
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
        { "<leader>l", group = "ros2" },
        { "<leader>q", group = "quit" },
        { "<leader>s", group = "search" },
        { "<leader>u", group = "toggle" },
        { "<leader>w", group = "window" },
        { "<leader>x", group = "diagnostics" },
      },
    },
  },

  -- Statusline. Docs: https://github.com/nvim-lualine/lualine.nvim
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = { theme = "auto", globalstatus = true, section_separators = "", component_separators = "│" },
      sections = {
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "diagnostics", "filetype" },
      },
    },
  },

  -- Base16 colorscheme fed with the wallpaper palette (config/theme.lua).
  -- Docs: https://github.com/echasnovski/mini.base16
  { "echasnovski/mini.base16" },

  -- Icons (also mocks nvim-web-devicons). Docs: https://github.com/echasnovski/mini.icons
  {
    "echasnovski/mini.icons",
    opts = {},
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },
}
