require('barbar').setup({
  animation = true,
  auto_hide = false,
  tabpages = true,
  icons = {
    button = '',
    inactive = { separator = { left = '▎', right = '' } },
    separator = { left = '▎', right = '' },
  },
})

-- Настройки прозрачности для вкладок
vim.api.nvim_set_hl(0, 'BufferCurrent', { bg = 'none' })
vim.api.nvim_set_hl(0, 'BufferCurrentIndex', { bg = 'none' })
vim.api.nvim_set_hl(0, 'BufferCurrentMod', { bg = 'none' })
vim.api.nvim_set_hl(0, 'BufferCurrentSign', { bg = 'none' })
vim.api.nvim_set_hl(0, 'BufferCurrentTarget', { bg = 'none' })
