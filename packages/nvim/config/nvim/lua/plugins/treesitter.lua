-- ~/.config/nvim/lua/plugins/treesitter.lua
--
-- Используем ветку master: модуль `nvim-treesitter.configs` есть только в ней.
-- Ветка main (сейчас дефолтная в репозитории) — полный рерайт без этого модуля,
-- отсюда ошибка "module 'nvim-treesitter.configs' not found".
-- textobjects тоже нужен из master, main-версия рассчитана на новый API.
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    { "nvim-treesitter/nvim-treesitter-textobjects", branch = "master" },
    "windwp/nvim-ts-autotag",
    {
      "JoosepAlviste/nvim-ts-context-commentstring",
      config = function()
        -- Глобальная переменная ускоряет загрузку
        vim.g.skip_ts_context_commentstring_module = true
        require("ts_context_commentstring").setup({})
      end,
    },
  },
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "c", "cpp", "go", "lua", "python", "javascript", "typescript",
        "html", "css", "json", "yaml", "bash", "markdown",
      },
      highlight = { enable = true },
      indent = { enable = true },

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
    })

    -- nvim-ts-autotag настраивается отдельно: ключ `autotag` внутри
    -- treesitter.setup() он давно не читает.
    require("nvim-ts-autotag").setup()
  end,
}
