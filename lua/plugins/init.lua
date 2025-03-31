local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local opts = {
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
}

local function create_note_from_template()
  vim.ui.input({prompt = "Enter note title: "}, function(title)
    if title then
      vim.cmd("ObsidianNewFromTemplate")
      vim.api.nvim_buf_set_lines(0, 0, -1, false, {title})
    end
  end)
end

local plugins = {
    require("plugins.completion"),
    require("plugins.telescope"),
    require("plugins.treesitter"),
    require("plugins.nvim-tree"),
    require("plugins.lazygit"),
    require("plugins.copilot"),
    {
        "mfussenegger/nvim-dap",
        lazy = true,
        config = function()
            -- Ajoutez ici la configuration de nvim-dap si nécessaire
        end
    },
    {
        "akinsho/flutter-tools.nvim",
        lazy = false,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "stevearc/dressing.nvim",
            "mfussenegger/nvim-dap",
        },
        config = function()
            require("flutter-tools").setup({
                debugger = {
                    enabled = true,
                    run_via_dap = true,
                },
                -- autres options...
            })
        end
    },
    {
        'lewis6991/gitsigns.nvim',
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require('gitsigns').setup({
                -- Configuration de Gitsigns...
            })
        end
    },
    {
        "epwalsh/obsidian.nvim",
        version = "*",
        lazy = false,
        ft = "markdown",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        opts = {
            workspaces = {
                { name = "vault", path = "~/Obsidian/" },
            },
            completion = {
                nvim_cmp = true,
            },
            new_notes_location = "Inbox",
            disable_frontmatter = true,
            
            templates = {
                subdir = "Templates",
                date_format = "%Y-%m-%d",
                time_format = "%H:%M",
            },
            follow_url_func = function(url)
                vim.fn.jobstart({"xdg-open", url})
            end,
        },
        keys = {
            { "<leader>on", create_note_from_template, desc = "Nouvelle note Obsidian depuis un template" },
            { "<leader>oo", "<cmd>ObsidianOpen<CR>", desc = "Ouvrir dans Obsidian" },
            { "<leader>os", "<cmd>ObsidianSearch<CR>", desc = "Rechercher une note Obsidian" },
            { "<leader>oq", "<cmd>ObsidianQuickSwitch<CR>", desc = "Changement rapide Obsidian" },
            { "<leader>ob", "<cmd>ObsidianBacklinks<CR>", desc = "Voir les backlinks Obsidian" },
            { "<leader>ot", "<cmd>ObsidianTemplate<CR>", desc = "Insérer un modèle Obsidian" },
            { "gf", function() return require("obsidian").util.gf_passthrough() end, desc = "Suivre le lien Obsidian" },
        },
    },
    { "nelsyeung/twig.vim" },
    {
        "lervag/vimtex",
        ft = {"tex", "latex"},
        config = function()
            vim.g.vimtex_view_method = 'zathura'
            vim.g.vimtex_compiler_method = 'latexmk'
            vim.g.vimtex_quickfix_mode = 0
            vim.opt.conceallevel = 2
            vim.g.tex_conceal = 'abdmg'
        end
    },
}

require("lazy").setup(plugins, opts)

-- Keymaps for Flutter development
vim.keymap.set('n', '<leader>fr', ':FlutterRun<CR>')
vim.keymap.set('n', '<leader>fq', ':FlutterQuit<CR>')
vim.keymap.set('n', '<leader>fR', ':FlutterReload<CR>')
vim.keymap.set('n', '<leader>fD', ':FlutterRestart<CR>')
vim.keymap.set('n', '<leader>fd', ':FlutterDevices<CR>')
vim.keymap.set('n', '<leader>fe', ':FlutterEmulators<CR>')

-- Configuration pour LaTeX
vim.api.nvim_create_autocmd("FileType", {
    pattern = {"tex", "latex"},
    callback = function()
        vim.opt_local.conceallevel = 2
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
    end
})

-- Raccourci pour compiler LaTeX
vim.keymap.set('n', '<leader>lc', ':VimtexCompile<CR>')

-- Configuration supplémentaire pour Obsidian
vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        vim.opt_local.conceallevel = 2
    end
})

