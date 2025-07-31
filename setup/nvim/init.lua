-- ~/.config/nvim/init.lua
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Загрузка базовых настроек
require("core.options")
require("core.keymaps")

-- Настройка Lazy.nvim 
require("lazy").setup({
  --[[
    Порядок загрузки плагинов:
    1. Цветовая схема (должна загружаться первой)
    2. UI-компоненты (статусная строка, скроллбар)
    3. Инструменты разработки (git, автодополнение)
    4. Вспомогательные плагины (подсветка, отступы)
  --]]
  { import = "plugins.dashboard-nvim" },    -- [1] Аниме девочка
  { import = "plugins.tokyonight" },        -- [1] Цветовая схема Tokyo Night
  { import = "plugins.nvim-web-devicons" }, -- [1] Перед nvim-tree и barbar
  
  { import = "plugins.lualine" },           -- [2] Статусная строка
  { import = "plugins.scrollbar" },         -- [2] Скроллбар с дополнительными функциями
  { import = "plugins.nvim-tree" },         -- [2] Файловый менеджер с иконками
  { import = "plugins.barbar" },            -- [2] Вкладки буферов с иконками

  { import = "plugins.lspconfig" },
  { import = "plugins.nvim-treesitter" },
  { import = "plugins.lazygit" },           -- [3] Git-интеграция
  { import = "plugins.cmp" },               -- [3] Система автодополнения
  { import = "plugins.autopairs" },         -- [3] Автозакрытие скобок
  
  { import = "plugins.treesitter" },      -- [4] Парсер синтаксиса
  { import = "plugins.colorizer" },       -- [4] Подсветка цветов
  { import = "plugins.blankline" },       -- [4] Индикаторы отступов
})
