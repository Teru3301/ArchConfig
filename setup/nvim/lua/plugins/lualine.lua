-- ~/.config/nvim/lua/plugins/lualine.lua
return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
--    "nvim-tree/nvim-web-devicons",
    "folke/tokyonight.nvim"  -- Для корректной работы темы
  },
  opts = {
    options = {
      theme = "tokyonight",    -- Явно указываем тему
      component_separators = { left = "", right = "" },  -- Стильные разделители
      section_separators = { left = "", right = "" },    -- Красивые границы секций
      disabled_filetypes = {   -- Отключаем для специальных буферов
        "alpha",
        "dashboard",
        "lazy",
        "neo-tree",
        "Trouble",
      },
      globalstatus = true,     -- Единая статусная строка для всех окон
    },
    sections = {
      lualine_a = { 
        { "mode", icon = "" }  -- Режим с иконкой
      },
      lualine_b = {
        "branch",               -- Ветка Git
        { 
          "diff",               -- Изменения
          symbols = {
            added = " ",
            modified = " ",
            removed = " "
          }
        },
        {
          "diagnostics",        -- Диагностика
          symbols = {
            error = " ",
            warn = " ",
            info = " ",
            hint = " "
          }
        }
      },
      lualine_c = {
        { 
          "filename",           -- Имя файла
          path = 1,             -- Относительный путь
          symbols = {
            modified = " ●",    -- Иконка измененного файла
            readonly = " ",    -- Иконка только для чтения
            unnamed = " "      -- Иконка безымянного буфера
          }
        }
      },
      lualine_x = {
        {
          "encoding",           -- Кодировка
          fmt = string.upper    -- В верхнем регистре
        },
        "fileformat",           -- Формат файла (unix/dos)
        "filetype",             -- Тип файла
      },
      lualine_y = {
        { "progress", separator = " ", padding = { left = 1, right = 0 } },  -- Прогресс
      },
      lualine_z = {
        { "location", padding = { left = 0, right = 1 } },  -- Позиция курсора
      }
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { 
        { 
          "filename", 
          path = 1,
          color = { fg = "#7f7f7f" }  -- Серый цвет для неактивных окон
        } 
      },
      lualine_x = { "location" },
      lualine_y = {},
      lualine_z = {}
    },
    extensions = { "nvim-tree", "fugitive" }  -- Специальные расширения
  },
  config = function(_, opts)
    -- Устанавливаем пользовательские цвета для темы
    local colors = require("tokyonight.colors").setup()
    opts.options.theme = {
      normal = {
        a = { fg = colors.black, bg = colors.blue, gui = "bold" },
        b = { fg = colors.fg, bg = colors.bg_statusline },
        c = { fg = colors.fg, bg = colors.bg_statusline }
      },
      -- ... остальные стили
    }
    
    require("lualine").setup(opts)
  end
}
