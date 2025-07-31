local lspconfig = require('lspconfig')
local cmp_nvim_lsp = require('cmp_nvim_lsp')

-- Общие настройки для LSP серверов
local capabilities = cmp_nvim_lsp.default_capabilities()

-- Настройки для разных языков
lspconfig.clangd.setup({ capabilities = capabilities }) -- C/C++
lspconfig.pyright.setup({ capabilities = capabilities }) -- Python
lspconfig.html.setup({ capabilities = capabilities })   -- HTML
lspconfig.cssls.setup({ capabilities = capabilities })  -- CSS

-- Настройки для Go
lspconfig.gopls.setup({
  capabilities = capabilities,
  settings = {
    gopls = {
      hints = {
        parameterNames = true,
        functionTypeParameters = true,
        rangeVariableTypes = true,
      },
    },
  },
})

-- Настройки для Lua
lspconfig.lua_ls.setup({
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = { globals = {'vim'} },
      workspace = { library = vim.api.nvim_get_runtime_file("", true) },
      telemetry = { enable = false },
    },
  },
})
