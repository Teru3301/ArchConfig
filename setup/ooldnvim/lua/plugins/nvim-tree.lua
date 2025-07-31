require('nvim-tree').setup({
  view = {
    width = 30,
    side = 'left',
  },
  renderer = {
    highlight_opened_files = "all",
    icons = {
      glyphs = {
        default = '',
        symlink = '',
        folder = {
          arrow_closed = '',
          arrow_open = '',
          default = '',
          open = '',
          empty = '',
          empty_open = '',
        },
      },
    },
  },
  actions = {
    open_file = {
      quit_on_open = true,
    },
  },
})

-- Дополнительные настройки прозрачности
vim.api.nvim_set_hl(0, 'NvimTreeNormal', { bg = 'none' })
vim.api.nvim_set_hl(0, 'NvimTreeEndOfBuffer', { bg = 'none' })
vim.api.nvim_set_hl(0, 'NvimTreeVertSplit', { bg = 'none' })
