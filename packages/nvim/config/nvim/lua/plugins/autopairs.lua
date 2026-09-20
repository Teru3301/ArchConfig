-- ~/.config/nvim/lua/plugins/autopairs.lua
return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  dependencies = { "hrsh7th/nvim-cmp" },  -- Явно указываем зависимость
  opts = {
    disable_filetype = { "TelescopePrompt" },
  },
  config = function(_, opts)
    require("nvim-autopairs").setup(opts)

    -- Безопасная интеграция с cmp (если cmp доступен)
    pcall(function()
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end)
  end
}
