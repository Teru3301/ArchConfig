-- Настройка цветовой схемы Tokyonight
require('tokyonight').setup({
  style = 'night',
  transparent = true,
  styles = {
    comments = { italic = true },
    keywords = { bold = true },
  },
})

-- Применение цветовой схемы
vim.cmd('colorscheme tokyonight')

-- Дополнительные настройки прозрачности
vim.api.nvim_set_hl(0, 'NvimTreeNormal', { bg = 'none' })
vim.api.nvim_set_hl(0, 'NvimTreeEndOfBuffer', { bg = 'none' })
vim.api.nvim_set_hl(0, 'NvimTreeVertSplit', { bg = 'none' })
