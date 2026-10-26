-- Native LSP (Neovim 0.11+). Server definitions come from nvim-lspconfig,
-- binaries from Mason (see lua/plugins/lsp.lua). Rust is handled by rustaceanvim.
--
-- Built-in maps: K hover, grn rename, gra code action, grr references,
-- gri implementation, grt type definition, gO symbols, <C-s> signature (insert).

vim.diagnostic.config({
  severity_sort = true,
  virtual_text = { spacing = 2, prefix = "●" },
  float = { source = "if_many" },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = " ",
    },
  },
})

-- Server-specific settings (merged over nvim-lspconfig defaults).
vim.lsp.config("lua_ls", {
  settings = { Lua = { workspace = { checkThirdParty = false }, completion = { callSnippet = "Replace" } } },
})

vim.lsp.config("basedpyright", {
  settings = { basedpyright = { analysis = { typeCheckingMode = "standard" } } },
})

vim.lsp.config("clangd", {
  cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu", "--completion-style=detailed" },
})

vim.lsp.config("jsonls", {
  before_init = function(_, config)
    config.settings.json.schemas = require("schemastore").json.schemas()
  end,
  settings = { json = { validate = { enable = true } } },
})

vim.lsp.config("yamlls", {
  before_init = function(_, config)
    config.settings.yaml.schemas = require("schemastore").yaml.schemas()
  end,
  settings = { yaml = { schemaStore = { enable = false, url = "" } } },
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lunkes_lsp", { clear = true }),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method("textDocument/inlayHint") then
      vim.keymap.set("n", "<leader>uh", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }), { bufnr = ev.buf })
      end, { buffer = ev.buf, desc = "Toggle inlay hints" })
    end
  end,
})
