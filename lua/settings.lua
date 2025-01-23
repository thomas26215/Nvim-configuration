vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.g.mapleader = " "

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

