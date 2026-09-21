-- ~/.config/nvim/lua/core/keymaps.lua
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"  -- Дополнительный локальный лидер

local map = vim.keymap.set

--[[
  Группы keymaps:
  1. Базовые операции
  2. Навигация и буферы
  3. Инструменты разработки
  4. Текстовые объекты
  5. Плагины
--]]

----- 1. Базовые операции -----
map("n", "<leader>w", ":w<CR>", { desc = "Save file" })
map("n", "<leader>q", ":q<CR>", { desc = "Quit window" })
map("n", "<leader>Q", ":qa<CR>", { desc = "Quit Neovim" })
map("n", "<leader>s", ":source %<CR>", { desc = "Reload current file" })

----- 2. Навигация и буферы -----
-- Навигация между окнами
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Управление буферами
map("n", "<Tab>", "<cmd>BufferNext<CR>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<cmd>BufferPrevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bc", "<cmd>BufferClose<CR>", { desc = "Close buffer" })
map("n", "<leader>bp", "<cmd>BufferPin<CR>", { desc = "Pin buffer" })

-- Быстрое переключение между буферами (Alt+1-9)
-- for i = 1, 9 do
--  map("n", string.format("<A-%s>", i), function()
--    require("barbar").go_to_buffer(i)
--  end, { desc = string.format("Go to buffer %s", i) })
-- end

vim.api.nvim_set_keymap('n', '<A-,>', ':BufferPrevious<CR>', { noremap = true, silent = true }) -- Перейти на предыдущую вкладку
vim.api.nvim_set_keymap('n', '<A-.>', ':BufferNext<CR>', { noremap = true, silent = true }) -- Перейти на следующую вкладку
vim.api.nvim_set_keymap('n', '<A-1>', ':BufferGoto 1<CR>', { noremap = true, silent = true }) -- Перейти на вкладку 1
vim.api.nvim_set_keymap('n', '<A-2>', ':BufferGoto 2<CR>', { noremap = true, silent = true }) -- Перейти на вкладку 2
vim.api.nvim_set_keymap('n', '<A-3>', ':BufferGoto 3<CR>', { noremap = true, silent = true }) -- Перейти на вкладку 3
vim.api.nvim_set_keymap('n', '<A-4>', ':BufferGoto 4<CR>', { noremap = true, silent = true }) -- Перейти на вкладку 4
vim.api.nvim_set_keymap('n', '<A-5>', ':BufferGoto 5<CR>', { noremap = true, silent = true }) -- Перейти на вкладку 5
vim.api.nvim_set_keymap('n', '<A-6>', ':BufferGoto 6<CR>', { noremap = true, silent = true }) -- Перейти на вкладку 6
vim.api.nvim_set_keymap('n', '<A-7>', ':BufferGoto 7<CR>', { noremap = true, silent = true }) -- Перейти на вкладку 7
vim.api.nvim_set_keymap('n', '<A-8>', ':BufferGoto 8<CR>', { noremap = true, silent = true }) -- Перейти на вкладку 8
vim.api.nvim_set_keymap('n', '<A-9>', ':BufferGoto 9<CR>', { noremap = true, silent = true }) -- Перейти на вкладку 9
vim.api.nvim_set_keymap('n', '<A-0>', ':BufferLast<CR>', { noremap = true, silent = true }) -- Перейти на последнюю вкладку
vim.api.nvim_set_keymap('n', '<A-c>', ':BufferClose<CR>', { noremap = true, silent = true }) -- Закрыть текущую вкладку

----- 3. Инструменты разработки -----
-- Git
map("n", "<leader>gg", "<cmd>LazyGit<CR>", { desc = "Toggle LazyGit" })
map("n", "<leader>gd", "<cmd>Gitsigns diffthis<CR>", { desc = "Git diff" })

-- Поиск/замена
map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "Search words" })
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Search files" })

----- 4. Текстовые объекты -----
-- Treesitter текстовые объекты (nvim-treesitter-textobjects, ветка main)
local function ts_select(query)
  return function()
    require("nvim-treesitter-textobjects.select").select_textobject(query, "textobjects")
  end
end
map({ "x", "o" }, "af", ts_select("@function.outer"), { desc = "Select outer function" })
map({ "x", "o" }, "if", ts_select("@function.inner"), { desc = "Select inner function" })
map({ "x", "o" }, "ac", ts_select("@class.outer"), { desc = "Select outer class" })
map({ "x", "o" }, "ic", ts_select("@class.inner"), { desc = "Select inner class" })

----- 5. Плагины -----
-- NvimTree
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
map("n", "<leader>E", "<cmd>NvimTreeFindFile<CR>", { desc = "Find current file in explorer" })

-- Treesitter
map("n", "<leader>ts", "<cmd>TSPlaygroundToggle<CR>", { desc = "Toggle Treesitter playground" })

-- LSP (если будете добавлять)
map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { desc = "Go to definition" })
map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", { desc = "Show references" })

-- Комментарии (если используете Comment.nvim)
map("n", "<leader>/", "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>", { desc = "Toggle comment" })
map("v", "<leader>/", "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", { desc = "Toggle comment (visual)" })

-- Перезагрузка конфигурации (удобно для разработки)
map("n", "<leader>R", "<cmd>lua require('plenary.reload').reload_module('plugins')<CR><cmd>source ~/.config/nvim/init.lua<CR>", 
  { desc = "Reload Neovim config" })

