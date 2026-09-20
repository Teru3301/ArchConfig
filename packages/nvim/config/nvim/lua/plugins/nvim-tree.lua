-- ~/.config/nvim/lua/plugins/nvim-tree.lua
return {
  "nvim-tree/nvim-tree.lua",
  cmd = { "NvimTreeToggle", "NvimTreeFocus" },
  config = function()
    -- Установка прозрачного фона для NvimTree
    vim.api.nvim_set_hl(0, 'NvimTreeNormal', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'NvimTreeEndOfBuffer', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'NvimTreeVertSplit', { bg = 'none' })

    require("nvim-tree").setup({
      view = {
        width = 35,                      -- Ширина файлового менеджера
        side = "left",                   -- Расположение (left/right)
      },
      renderer = {
        group_empty = true,              -- Группировать пустые папки
        icons = {
          glyphs = {
            folder = {
              arrow_closed = "▸",        -- Иконка закрытой папки
              arrow_open = "▾",          -- Иконка открытой папки
            },
          },
        },
      },
      filters = {
        dotfiles = false,                -- Показывать скрытые файлы
      },
    })
  end
}
