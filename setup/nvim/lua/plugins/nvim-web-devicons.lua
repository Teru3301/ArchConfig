return {
  "nvim-tree/nvim-web-devicons",
  lazy = true,
  opts = {
    default = true,
    override = {
      cpp = {
        icon = "", -- Иконка для C++
        color = "#f34b7d",
      },
      go = {
        icon = "", -- Иконка для Go
        color = "#519aba",
      },
    },
  },
}
