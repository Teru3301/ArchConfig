-- ~/.config/nvim/lua/plugins/lazygit.lua
return {
  "kdheepak/lazygit.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    -- Настройки окна lazygit
    vim.g.lazygit_floating_window_scaling_factor = 0.9
    vim.g.lazygit_floating_window_winblend = 0
  end
}
