-- Базовые настройки Neovim
vim.opt.encoding = "utf-8"
vim.cmd('syntax on')

-- Настройки интерфейса
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.wrap = false
vim.opt.termguicolors = true

-- Настройки табов и отступов
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true

-- Настройки поиска
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Прочие настройки
vim.opt.mouse = 'a'
vim.opt.history = 1000
vim.opt.completeopt = 'menuone,noselect'
vim.opt.whichwrap:append("<,>,h,l,[,]")

-- Прозрачный фон
vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
