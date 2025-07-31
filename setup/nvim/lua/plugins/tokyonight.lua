-- ~/.config/nvim/lua/plugins/tokyonight.lua
return {
  "folke/tokyonight.nvim",
  lazy = false,    -- Загружать сразу при старте
  priority = 1000, -- Высший приоритет
  opts = {
    style = "night",  -- Вариант темы (night/moon/day)
    transparent = true, -- Прозрачный фон
    styles = {
      comments = { italic = true },
      keywords = { italic = true },
    },
  },
  config = function(_, opts)
    require("tokyonight").load(opts)
  end
}
