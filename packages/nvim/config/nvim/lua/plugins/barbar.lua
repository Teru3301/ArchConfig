return {
  "romgrk/barbar.nvim",
--  dependencies = {
--    "nvim-tree/nvim-web-devicons"  -- Иконки для вкладок
--  },
  init = function()
    vim.g.barbar_auto_setup = false  -- Отключаем авто-инициализацию
    
    -- Настройка прозрачного фона для barbar.nvim
    vim.api.nvim_set_hl(0, 'BufferCurrent', { bg = 'none' }) -- Активная вкладка
    vim.api.nvim_set_hl(0, 'BufferCurrentIndex', { bg = 'none' }) -- Индекс активной вкладки
    vim.api.nvim_set_hl(0, 'BufferCurrentMod', { bg = 'none' }) -- Активная вкладка с изменениями
    vim.api.nvim_set_hl(0, 'BufferCurrentSign', { bg = 'none' }) -- Значок активной вкладки
    vim.api.nvim_set_hl(0, 'BufferCurrentTarget', { bg = 'none' }) -- Цель активной вкладки
  end,
  opts = {
    -- Основные настройки
    animation = true,
    auto_hide = false,
    tabpages = true,
    closable = true,
    clickable = true,
    focus_on_close = "previous",  -- При закрытии переключаться на предыдущий буфер
    
    -- Настройки иконок
    icons = {
      button = '', -- Иконка для кнопки закрытия вкладки
      inactive = { 
        separator = { left = '▎', right = '' } -- Стиль неактивных вкладок
      },
      separator = { left = '▎', right = '' }, -- Разделитель между вкладками
      modified = { button = '●' }, -- Иконка измененного файла
      pinned = { button = '車', filename = true }, -- Закрепленные вкладки
      
      -- Иконки для типов файлов
      filetype = {
        custom_colors = false, -- Использовать цвета из devicons
        enabled = true,
      },
    },
    
    -- Настройки подсветки
    highlight_visible = true,  -- Подсветка текущего буфера
    highlight_alternate = false, -- Подсветка альтернативного буфера
    highlight_inactive_file_icons = false, -- Подсветка иконок неактивных буферов
    
    -- Дополнительные настройки
    insert_at_end = true,      -- Новые буферы добавляются в конец
    maximum_padding = 2,       -- Максимальный отступ между вкладками
    minimum_padding = 1,       -- Минимальный отступ
    semantic_letters = true,   -- Использовать семантические буквы для быстрого переключения
    
    -- Исключения
    exclude_ft = { 'qf' },     -- Не показывать для quickfix
    exclude_name = { 'package.json' }, -- Исключить определенные файлы
  },
  config = function(_, opts)
    -- Безопасная инициализация с обработкой ошибок
    local ok, barbar = pcall(require, 'barbar')
    if not ok then return end
    
    -- Применяем настройки
    barbar.setup(opts)
  end
}
