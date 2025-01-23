require("settings")
require("plugins")
require("mapping")

-- Activer la colonne de signes
vim.opt.signcolumn = "yes"

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

