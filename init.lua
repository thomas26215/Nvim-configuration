vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.g.mapleader = " "

-- Activer la colonne de signes
vim.opt.signcolumn = "yes"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
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

local opts = {}
local plugins = {
    {
        'nvim-telescope/telescope.nvim', 
        tag = '0.1.8',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        opts = {
            ensure_installed = {
                "lua", "vim", "vimdoc", "javascript", "typescript",
                "python", "java", "c", "cpp", "bash", "markdown", "markdown_inline",
            },
            highlight = { enable = true },
            indent = { enable = true },
        },
    },
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("nvim-tree").setup {}
        end,
    },
    {
        "kdheepak/lazygit.nvim",
        lazy = true,
        cmd = {
            "LazyGit", "LazyGitConfig", "LazyGitCurrentFile",
            "LazyGitFilter", "LazyGitFilterCurrentFile",
        },
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = { { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" } }
    },
    {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup({
                signs = {
                    add          = { text = '│' },
                    change       = { text = '│' },
                    delete       = { text = '_' },
                    topdelete    = { text = '‾' },
                    changedelete = { text = '~' },
                    untracked    = { text = '┆' },
                },
                signcolumn = true,
                numhl = false,
                linehl = false,
                word_diff = false,
                watch_gitdir = {
                    interval = 1000,
                    follow_files = true
                },
                attach_to_untracked = true,
                current_line_blame = false,
                current_line_blame_opts = {
                    virt_text = true,
                    virt_text_pos = 'eol',
                    delay = 1000,
                    ignore_whitespace = false,
                },
                current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
                sign_priority = 6,
                update_debounce = 100,
                status_formatter = nil,
                max_file_length = 40000,
                preview_config = {
                    border = 'single',
                    style = 'minimal',
                    relative = 'cursor',
                    row = 0,
                    col = 1
                },
                yadm = { enable = false },
            })
        end
    }
}

require("lazy").setup(plugins, opts)

-- Ajout du raccourci pour NvimTree
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

-- Configuration des icônes personnalisées
local web_devicons = require("nvim-web-devicons")

-- Configuration de Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})

-- Personnalisation des couleurs pour GitSigns
vim.cmd([[
    highlight GitSignsAdd guifg=#009900 ctermfg=2
    highlight GitSignsChange guifg=#bbbb00 ctermfg=3
    highlight GitSignsDelete guifg=#ff2222 ctermfg=1
]])

