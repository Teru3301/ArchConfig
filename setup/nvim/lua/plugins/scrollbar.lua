-- ~/.config/nvim/lua/plugins/scrollbar.lua
return {
  "petertriho/nvim-scrollbar",
  event = "BufReadPost",
  dependencies = {
    "kevinhwang91/nvim-hlslens",  -- Для подсветки поиска
    "lewis6991/gitsigns.nvim",     -- Для отметок git
  },
  config = function()
    -- Основные настройки скроллбара
    local scrollbar = require("scrollbar")
    
    scrollbar.setup({
      handle = {
        color = "#3b4252",      -- Цвет ползунка (под tokyonight)
        blend = 30,             -- Прозрачность (0-100)
        highlight = "CursorLine",-- Группа подсветки
      },
      marks = {
        Search = { color = "#ebcb8b" },  -- Цвет результатов поиска
        GitAdd = { text = "│" },
        GitChange = { text = "│" },
        GitDelete = { text = "󰍵" },
      },
      excluded_filetypes = {
        "prompt",
        "TelescopePrompt",
        "noice",
        "lazy",
      },
    })

    -- Интеграция с hlslens (поиск)
    require("scrollbar.handlers.search").setup()

    -- Интеграция с gitsigns (если установлен)
    if package.loaded["gitsigns"] then
      require("scrollbar.handlers.gitsigns").setup()
    end
  end
}
