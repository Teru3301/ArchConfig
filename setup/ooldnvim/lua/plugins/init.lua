-- Установка и настройка Packer
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd 'packadd packer.nvim'
end

-- Загрузка плагинов
return require('packer').startup(function(use)
  -- Packer может управлять собой
  use 'wbthomason/packer.nvim'

  -- Плагины для Git
  use 'lewis6991/gitsigns.nvim'
  use { 'kdheepak/lazygit.nvim', requires = { 'nvim-lua/plenary.nvim' } }

  -- Treesitter и дополнения
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use 'nvim-treesitter/nvim-treesitter-context'
  use 'nvim-treesitter/nvim-treesitter-textobjects'

  -- Цветовая схема
  use 'folke/tokyonight.nvim'

  -- Автодополнение и сниппеты
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-nvim-lua'
  use 'saadparwaiz1/cmp_luasnip'
  use 'L3MON4D3/LuaSnip'
  use 'onsails/lspkind-nvim'

  -- LSP
  use 'neovim/nvim-lspconfig'

  -- UI компоненты
  use { 'nvim-tree/nvim-tree.lua', requires = { 'nvim-tree/nvim-web-devicons' } }
  use { 'nvim-lualine/lualine.nvim', requires = { 'nvim-tree/nvim-web-devicons' } }
  use { 'romgrk/barbar.nvim', requires = { 'nvim-tree/nvim-web-devicons' } }
  use { 'akinsho/toggleterm.nvim' }
  use { 'numToStr/Comment.nvim' }

  -- Прочие полезные плагины
  use 'windwp/nvim-autopairs'
  use 'norcalli/nvim-colorizer.lua'
  use 'mhinz/vim-startify'
  use 'lukas-reineke/indent-blankline.nvim'
  use { 'petertriho/nvim-scrollbar' }
  use { 'ellisonleao/glow.nvim', cmd = "Glow" }
end)
