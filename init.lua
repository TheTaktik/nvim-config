-- global settings

vim.g.mapleader = " "
vim.wo.number = true
vim.wo.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- TODO preserve undo hist

-- native key remaps

vim.keymap.set("n", "]q", ":cnext<CR>", {noremap=true})
vim.keymap.set("n", "[q", ":cprev<CR>", {noremap=true})
vim.keymap.set("n", "]l", ":lnext<CR>", {noremap=true})
vim.keymap.set("n", "[l", ":lprev<CR>", {noremap=true})

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", [["_dP]])

vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

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
	    {'L3MON4D3/LuaSnip'},
	    {'hrsh7th/cmp-buffer'},
	    {'hrsh7th/cmp-path'},
	},
    },
    -- tmux integration
    'christoomey/vim-tmux-navigator',
    -- tree
    {
	'nvim-tree//nvim-tree.lua',
    }
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
    local opts = {buffer = bufnr, remap = false}

    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)

    vim.keymap.set("n", "gd", "<CMD>Telescope lsp_definitions<CR>", opts)
    vim.keymap.set("n", "gr", "<CMD>Telescope lsp_references<CR>", opts)
    vim.keymap.set("n", "gi", "<CMD>Telescope lsp_implementations<CR>", opts)

    vim.keymap.set("n", "<leader>vd", "<CMD>Telescope diagnostics<CR>", opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)

    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>ciw", function() vim.lsp.buf.rename() end, opts)
end)

--- if you want to know more about lsp-zero and mason.nvim
--- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
require('mason').setup({})
require('mason-lspconfig').setup({
    handlers = {
	lsp_zero.default_setup,
    },
})

-- order diagnostics by severity
vim.diagnostic.config({severity_sort = true})

-- completion

require('cmp').setup({
    sources = {
	{name = 'nvim_lsp'},
	{name = 'buffer'},
	{name = 'path'},
    }
})

-- tmux integration
vim.g.tmux_navigator_no_mappings = 1
vim.keymap.set("n", "<C-h>", vim.cmd.TmuxNavigateLeft)
vim.keymap.set("n", "<C-j>", vim.cmd.TmuxNavigateDown)
vim.keymap.set("n", "<C-k>", vim.cmd.TmuxNavigateUp)
vim.keymap.set("n", "<C-l>", vim.cmd.TmuxNavigateRight)

-- nvim tree
require('nvim-tree').setup({})
