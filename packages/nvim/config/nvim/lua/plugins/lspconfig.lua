-- ~/.config/nvim/lua/plugins/lspconfig.lua
--
-- Нужен Neovim 0.11+ (vim.lsp.config / vim.lsp.enable).
-- Сам плагин nvim-lspconfig остаётся: он поставляет готовые конфиги серверов
-- (каталог lsp/), но `require("lspconfig")` больше не вызываем — он deprecated.
-- Бинарники серверов ставятся пакетами из packages/lsp, packages/go и т.д.
return {
  "neovim/nvim-lspconfig",
  dependencies = { "hrsh7th/cmp-nvim-lsp" },
  config = function()
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.server_capabilities.hoverProvider then
          vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = args.buf })
        end
      end,
    })

    -- Общие настройки для всех серверов: capabilities для nvim-cmp
    vim.lsp.config("*", {
      capabilities = require("cmp_nvim_lsp").default_capabilities(),
    })

    -- Python
    vim.lsp.config("pyright", {
      settings = {
        python = {
          analysis = {
            typeCheckingMode = "basic",
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
          },
        },
      },
    })

    -- Go
    vim.lsp.config("gopls", {
      settings = {
        gopls = {
          analyses = { unusedparams = true },
          staticcheck = true,
        },
      },
    })

    -- Lua
    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          diagnostics = { globals = { "vim" } },
          workspace = { library = vim.api.nvim_get_runtime_file("", true) },
          telemetry = { enable = false },
        },
      },
    })

    -- Серверы без дополнительных настроек берут дефолты из nvim-lspconfig
    vim.lsp.enable({
      "pyright",
      "clangd",
      "gopls",
      "html",
      "cssls",
      "jsonls",
      "bashls",
      "lua_ls",
      "dockerls",
      "yamlls",
      -- "rust_analyzer",
    })
  end,
}
