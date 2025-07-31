-- ~/.config/nvim/lua/plugins/treesitter.lua
return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
    "windwp/nvim-ts-autotag",
    {
      "JoosepAlviste/nvim-ts-context-commentstring",
      config = function()
        -- Устанавливаем глобальную переменную для ускорения загрузки
        vim.g.skip_ts_context_commentstring_module = true
        require("ts_context_commentstring").setup({})
      end
    },
  },
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "lua", "python", "javascript", "typescript", "html",
        "css", "json", "yaml", "bash", "markdown"
      },
      highlight = { enable = true },
      indent = { enable = true },
      
      -- Убрали старую настройку context_commentstring отсюда
      -- и перенесли в отдельный config для плагина выше
      
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "gnn",
          node_incremental = "grn",
          scope_incremental = "grc",
          node_decremental = "grm",
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
          },
        },
      },
      autotag = {
        enable = true,
        filetypes = { "html", "xml", "javascript", "typescriptreact" },
      },
    })
  end
}
