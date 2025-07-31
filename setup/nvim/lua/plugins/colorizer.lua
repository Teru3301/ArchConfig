-- ~/.config/nvim/lua/plugins/colorizer.lua
return {
  "norcalli/nvim-colorizer.lua",
  event = { "BufReadPre", "BufNewFile" },  -- Оптимальное событие для загрузки
  config = function()
    require("colorizer").setup({
      filetypes = {
        "css",
        "scss",
        "html",
        "javascript",
        "typescript",
        "lua",
        "vue",
        "svelte",
      },
      user_default_options = {
        RGB = true,          -- #RGB hex codes
        RRGGBB = true,       -- #RRGGBB hex codes
        names = false,       -- "red" instead of "#FF0000"
        RRGGBBAA = true,     -- #RRGGBBAA hex codes
        rgb_fn = true,       -- CSS rgb() and rgba() functions
        hsl_fn = true,       -- CSS hsl() and hsla() functions
        css = true,          -- Enable all CSS features
        css_fn = true,       -- Enable CSS functions
        mode = "background", -- Set display mode
        tailwind = true,     -- Enable tailwind colors
      }
    })

    -- Включить сразу для всех поддерживаемых буферов
    vim.defer_fn(function()
      require("colorizer").attach_to_buffer(0)
    end, 0)
  end
}
