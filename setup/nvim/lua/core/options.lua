-- ~/.config/nvim/lua/core/options.lua
vim.opt.number = true                   -- Номера строк
vim.opt.termguicolors = true            -- Поддержка true color
vim.opt.laststatus = 3                  -- Глобальная статусная строка
vim.opt.showmode = false                -- lualine будет показывать режим
vim.opt.wrap = false                    -- Перенос строк
vim.opt.whichwrap:append("<,>,h,l,[,]")	-- Перенос курсора
vim.opt.encoding = "utf-8"              -- Кодировка
-- настройки табуляции
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
