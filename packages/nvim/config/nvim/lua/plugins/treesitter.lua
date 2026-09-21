-- ~/.config/nvim/lua/plugins/treesitter.lua
--
-- Ветка main: полный рерайт плагина, нужен Neovim 0.12+ и tree-sitter-cli
-- (см. packages/nvim/install.sh).
--
-- Ветка master заархивирована и не работает с Neovim 0.12: её query_predicates.lua
-- падает с "attempt to call method 'range' (a nil value)". Чинить её не будут.
--
-- Что изменилось по сравнению с master:
--   * модуля `nvim-treesitter.configs` больше нет — highlight и indent включаются
--     вручную через FileType-автокоманду (см. ниже);
--   * плагин не поддерживает ленивую загрузку (lazy = false);
--   * incremental_selection убрали из плагина: в Neovim 0.12 оно встроенное,
--     в Visual-режиме `an` расширяет выделение, `in` сужает (`]n` / `[n` — соседние узлы);
--   * textobjects настраиваются через собственный setup(), а маппинги — руками
--     (они лежат в core/keymaps.lua).

local parsers = {
  "c", "c_sharp", "cpp", "go", "lua", "python", "javascript", "typescript",
  "html", "css", "json", "yaml", "bash", "markdown", "markdown_inline",
}

-- Отступы на treesitter (экспериментально, по README плагина) включаем только
-- там, где раньше работало. Ключи — filetype, а не имя парсера (bash -> sh).
local indent_filetypes = {
  c = true, cpp = true, go = true, lua = true, python = true,
  javascript = true, typescript = true, html = true, css = true,
  sh = true, bash = true,
}

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  dependencies = {
    { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
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
    -- Асинхронно ставит недостающие парсеры (no-op, если всё уже есть).
    -- На первом запуске сборка займёт минуту-другую — файлы, открытые за это
    -- время, подсветятся только после переоткрытия.
    require("nvim-treesitter").install(parsers)

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
      callback = function(args)
        -- start() бросает ошибку, если для filetype нет парсера — тогда просто
        -- остаётся обычная (regex) подсветка.
        if not pcall(vim.treesitter.start, args.buf) then
          return
        end
        if indent_filetypes[vim.bo[args.buf].filetype] then
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })

    require("nvim-treesitter-textobjects").setup({
      select = { lookahead = true },
    })

    -- nvim-ts-autotag настраивается отдельно: ключ `autotag` внутри
    -- treesitter.setup() он давно не читает.
    require("nvim-ts-autotag").setup()
  end,
}

