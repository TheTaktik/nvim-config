-- global settings

vim.g.mapleader = " "
vim.wo.number = true
vim.wo.relativenumber = true
-- TODO preserve undo hist

-- native key remaps

vim.keymap.set("n", "]q", ":cnext<CR>", {noremap=true})
vim.keymap.set("n", "[q", ":cprev<CR>", {noremap=true})
vim.keymap.set("n", "]l", ":lnext<CR>", {noremap=true})
vim.keymap.set("n", "[l", ":lprev<CR>", {noremap=true})
vim.keymap.set("v", "<leader>y", '"+y', {noremap=true})
vim.keymap.set("v", "<leader>Y", '"+Y', {noremap=true})
vim.keymap.set("n", "<leader>y", '"+y', {noremap=true})
vim.keymap.set("n", "<leader>Y", '"+Y', {noremap=true})

-- lazy.nvim

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd([[colorscheme catppuccin]])
		end,
	},
	{"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	"tpope/vim-fugitive",
	"tpope/vim-surround",
	"airblade/vim-gitgutter",
	-- Mason
	'williamboman/mason.nvim',
	'williamboman/mason-lspconfig.nvim',
	-- LSP Support
	{
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v3.x',
		lazy = true,
		config = false,
	},
	{
		'neovim/nvim-lspconfig',
		dependencies = {
			{'hrsh7th/cmp-nvim-lsp'},
		}
	},
	-- Autocompletion
	{
		'hrsh7th/nvim-cmp',
		dependencies = {
			{'L3MON4D3/LuaSnip'}
		},
	},
}

require("lazy").setup(plugins)

-- telescope

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- lsp zero
local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({buffer = bufnr})
end)

--- if you want to know more about lsp-zero and mason.nvim
--- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
require('mason').setup({})
require('mason-lspconfig').setup({
  handlers = {
    lsp_zero.default_setup,
  },
})
