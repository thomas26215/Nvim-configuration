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
                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns

                    local function map(mode, l, r, opts)
                        opts = opts or {}
                        opts.buffer = bufnr
                        vim.keymap.set(mode, l, r, opts)
                    end

                    -- Navigation
                    map('n', ']c', function()
                        if vim.wo.diff then return ']c' end
                        vim.schedule(function() gs.next_hunk() end)
                        return '<Ignore>'
                    end, {expr=true})

                    map('n', '[c', function()
                        if vim.wo.diff then return '[c' end
                        vim.schedule(function() gs.prev_hunk() end)
                        return '<Ignore>'
                    end, {expr=true})

                    -- Actions
                    map('n', '<leader>hs', gs.stage_hunk)
                    map('n', '<leader>hr', gs.reset_hunk)
                    map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line("."), vim.fn.line("v")} end)
                    map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line("."), vim.fn.line("v")} end)
                    map('n', '<leader>hS', gs.stage_buffer)
                    map('n', '<leader>hu', gs.undo_stage_hunk)
                    map('n', '<leader>hR', gs.reset_buffer)
                    map('n', '<leader>hp', gs.preview_hunk)
                    map('n', '<leader>hb', function() gs.blame_line{full=true} end)
                    map('n', '<leader>tb', gs.toggle_current_line_blame)
                    map('n', '<leader>hd', gs.diffthis)
                    map('n', '<leader>hD', function() gs.diffthis('~') end)
                    map('n', '<leader>td', gs.toggle_deleted)

                    -- Text object
                    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
                end
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

-- Configuration des signes Git, y compris pour les lignes non modifiées
vim.fn.sign_define("GitSignsAdd", {text = "│", texthl = "GitSignsAdd"})
vim.fn.sign_define("GitSignsChange", {text = "│", texthl = "GitSignsChange"})
vim.fn.sign_define("GitSignsDelete", {text = "_", texthl = "GitSignsDelete"})
vim.fn.sign_define("GitSignsTopDelete", {text = "‾", texthl = "GitSignsDelete"})
vim.fn.sign_define("GitSignsChangeDelete", {text = "~", texthl = "GitSignsChange"})
vim.fn.sign_define("GitSignsUntracked", {text = "┆", texthl = "GitSignsAdd"})
vim.fn.sign_define("GitSignsUnchanged", {text = "│", texthl = "GitSignsUnchanged"})

-- Personnalisation des couleurs pour GitSigns
vim.cmd([[
    highlight GitSignsAdd guifg=#009900 ctermfg=2
    highlight GitSignsChange guifg=#bbbb00 ctermfg=3
    highlight GitSignsDelete guifg=#ff2222 ctermfg=1
    highlight GitSignsUnchanged guifg=#444444 ctermfg=8
]])

-- Fonction pour ajouter des signes pour les lignes inchangées
local function add_signs_for_unchanged_lines()
    local bufnr = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_line_count(bufnr)
    for i = 1, lines do
        if not vim.fn.sign_getplaced(bufnr, {group = "gitsigns_vimfn_signs", lnum = i})[1].signs[1] then
            vim.fn.sign_place(0, "unchanged_lines", "GitSignsUnchanged", bufnr, {lnum = i, priority = 5})
        end
    end
end

-- Autocmd pour mettre à jour les signes des lignes inchangées
vim.api.nvim_create_autocmd({"BufEnter", "BufWritePost"}, {
    pattern = "*",
    callback = add_signs_for_unchanged_lines
})

