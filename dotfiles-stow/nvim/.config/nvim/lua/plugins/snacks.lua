-- snacks.nvim: picker, explorer, dashboard, lazygit, terminal, notifications, images.
-- Docs: https://github.com/folke/snacks.nvim
local function pick(source, opts)
  return function() Snacks.picker[source](opts) end
end

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    quickfile = { enabled = true },
    notifier = { enabled = true },
    input = { enabled = true },
    indent = { enabled = true },
    words = { enabled = true },
    statuscolumn = { enabled = true },
    scope = { enabled = true },
    image = { enabled = true }, -- images/PDFs inline in Kitty
    picker = { enabled = true },
    explorer = { enabled = true, replace_netrw = true },
    lazygit = { enabled = true },
    terminal = { enabled = true },
    dashboard = {
      enabled = true,
      sections = {
        { section = "header" },
        { section = "keys", gap = 1, padding = 1 },
        { section = "startup" },
      },
      preset = {
        header = [=[
▀███▄   ▀███▀███▀▀▀███  ▄▄█▀▀██▄ ▀████▀   ▀███▀████▀████▄     ▄███▀
  ███▄    █   ██    ▀█▄██▀    ▀██▄ ▀██     ▄█   ██   ████    ████
  █ ███   █   ██   █  ██▀      ▀██  ██▄   ▄█    ██   █ ██   ▄█ ██
  █  ▀██▄ █   ██████  ██        ██   ██▄  █▀    ██   █  █▓  █▀ ██
  █   ▀██▄▓   ██   █  ▄█        ██   ▀▓█ ▓▀     █▓   ▓  █▓▄█▀  ██
  ▓     ▓█▓   █▓     ▄███      ██▀    ▓██▄      █▓   ▓  ▀▓█▀   ██
  ▓   ▀▓▓▓▓   ▓▓   ▓  ▓██      ▓█▓    ▓▓ ▓▀     ▓▓   ▓  ▓▓▓▓▀  ▓▓
  ▓     ▓▓▓   ▓▓     ▓▓█▓▓▓    ▓▓▓    ▓▓▒▒      ▒▓   ▒  ▀▓▓▀   ▓▓
▒ ▒ ▒    ▒▓▓▒ ▒▒▒▓▒ ▒ ▒ ▒ ▒ ▒ ▒        ▒      ▒▓▒ ▒▒ ▒▒▒ ▒   ▒ ▒▒▒

[plunkes >BD]]=],
        keys = {
          { icon = " ", key = "f", desc = "Find file", action = ":lua Snacks.picker.files()" },
          { icon = " ", key = "g", desc = "Grep", action = ":lua Snacks.picker.grep()" },
          { icon = " ", key = "r", desc = "Recent", action = ":lua Snacks.picker.recent()" },
          { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.picker.files({ cwd = vim.fn.stdpath('config') })" },
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
    },
  },
  keys = {
    -- find
    { "<leader><space>", pick("smart"), desc = "Find files (smart)" },
    { "<leader>/", pick("grep"), desc = "Grep" },
    { "<leader>,", pick("buffers"), desc = "Buffers" },
    { "<leader>:", pick("command_history"), desc = "Command history" },
    { "<leader>ff", pick("files"), desc = "Files" },
    { "<leader>fg", pick("git_files"), desc = "Git files" },
    { "<leader>fr", pick("recent"), desc = "Recent" },
    { "<leader>fc", pick("files", { cwd = vim.fn.stdpath("config") }), desc = "Config files" },
    { "<leader>e", function() Snacks.explorer() end, desc = "Explorer" },
    -- search
    { "<leader>sw", pick("grep_word"), desc = "Word under cursor", mode = { "n", "x" } },
    { "<leader>sh", pick("help"), desc = "Help" },
    { "<leader>sk", pick("keymaps"), desc = "Keymaps" },
    { "<leader>sd", pick("diagnostics"), desc = "Diagnostics" },
    { "<leader>sD", pick("diagnostics_buffer"), desc = "Buffer diagnostics" },
    { "<leader>ss", pick("lsp_symbols"), desc = "Symbols" },
    { "<leader>sS", pick("lsp_workspace_symbols"), desc = "Workspace symbols" },
    { "<leader>sr", pick("resume"), desc = "Resume last picker" },
    { "<leader>su", pick("undo"), desc = "Undo history" },
    { "<leader>n", pick("notifications"), desc = "Notifications" },
    -- lsp (picker versions of the built-in gr* maps)
    { "gd", pick("lsp_definitions"), desc = "Goto definition" },
    { "gD", pick("lsp_declarations"), desc = "Goto declaration" },
    { "gr", pick("lsp_references"), nowait = true, desc = "References" },
    { "gI", pick("lsp_implementations"), desc = "Goto implementation" },
    { "gy", pick("lsp_type_definitions"), desc = "Goto type definition" },
    -- git
    { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
    { "<leader>gl", pick("git_log"), desc = "Git log" },
    { "<leader>gf", pick("git_log_file"), desc = "File history" },
    { "<leader>gs", pick("git_status"), desc = "Git status" },
    { "<leader>gb", function() Snacks.git.blame_line() end, desc = "Blame line" },
    { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Open in browser", mode = { "n", "x" } },
    -- misc
    { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete buffer" },
    { "<leader>bo", function() Snacks.bufdelete.other() end, desc = "Delete other buffers" },
    { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename file" },
    { "<C-/>", function() Snacks.terminal() end, desc = "Terminal", mode = { "n", "t" } },
    { "]]", function() Snacks.words.jump(1, true) end, desc = "Next reference" },
    { "[[", function() Snacks.words.jump(-1, true) end, desc = "Prev reference" },
  },
}
