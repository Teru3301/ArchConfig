-- ~/.config/nvim/lua/plugins/blankline.lua
return {
  "lukas-reineke/indent-blankline.nvim",
  event = { "BufReadPost", "BufNewFile" },
  main = "ibl",  -- Важно: новый модуль называется 'ibl'
  opts = {
    indent = {
      char = "│",  -- Символ для отступов
      tab_char = "│",
    },
    scope = {
      enabled = true,
      show_start = false,
      show_end = false,
    },
    exclude = {
      filetypes = {
        "help",
        "alpha",
        "dashboard",
        "lazy",
        "mason",
        "notify",
        "terminal",
      },
    },
  },
  config = function(_, opts)
    require("ibl").setup(opts)
  end
}
