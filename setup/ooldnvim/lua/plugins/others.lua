-- Настройка indent-blankline
require("ibl").setup({
  indent = {
    char = "│",
  },
})

-- Настройка scrollbar
require("scrollbar").setup()

-- Настройка glow.nvim
require("glow").setup({
  border = "rounded",
  style = "dark",
  pager = false
})

-- Настройка autopairs
require('nvim-autopairs').setup()

-- Настройка colorizer
require('colorizer').setup()

-- Настройка toggleterm
require("toggleterm").setup({
  size = 20,
  open_mapping = [[<C-\>]],
  direction = 'horizontal',
  shade_filetypes = {},
  hide_numbers = true,
  shade_terminals = true,
  start_in_insert = true,
  persist_size = true,
  close_on_exit = true,
})

-- Настройка Comment.nvim
require('Comment').setup({
  toggler = {
    line = '<C-/>',
    block = '<C-/>',
  },
  opleader = {
    line = '<C-/>',
    block = '<C-/>',
  },
})
