-- ~/.config/nvim/init.lua

-- Проверка версии Neovim (рекомендуется 0.9+)
if vim.fn.has('nvim-0.9') == 0 then
  vim.notify("Рекомендуется использовать Neovim v0.9 или новее", vim.log.levels.WARN)
end

-- Отключение встроенных плагинов которые не нужны
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1
-- vim.g.loaded_matchit = 1
-- vim.g.loaded_matchparen = 1
-- vim.g.loaded_logiPat = 1
-- vim.g.loaded_rrhelper = 1

-- Установка leader-клавиши (должно быть до загрузки keymaps)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Загрузка базовых настроек
require('core.options')   -- Основные настройки Neovim
require('core.keymaps')   -- Пользовательские сочетания клавиш
require('core.autocmds')  -- Автоматические команды

-- Загрузка цветовой схемы
local ok, _ = pcall(require, 'colorscheme')
if not ok then
  vim.notify("Ошибка загрузки цветовой схемы, используется дефолтная", vim.log.levels.ERROR)
  vim.cmd('colorscheme desert')
end

-- Загрузка плагинов (Packer)
local plugins_ok, _ = pcall(require, 'plugins.init')
if not plugins_ok then
  vim.notify("Ошибка загрузки конфигурации плагинов", vim.log.levels.ERROR)
end

-- Проверка и загрузка пользовательских модулей (если есть)
local user_modules = {
  'user.settings',    -- Пользовательские настройки (опционально)
  'user.keymaps',     -- Дополнительные keymaps (опционально)
  'user.plugins',     -- Дополнительные плагины (опционально)
}

for _, module in ipairs(user_modules) do
  pcall(require, module)
end

-- Сообщение о успешной загрузке конфига
vim.notify("Конфигурация Neovim успешно загружена!", vim.log.levels.INFO)

