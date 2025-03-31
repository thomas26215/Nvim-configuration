return {
    "github/copilot.vim",
    config = function()
        vim.g.copilot_no_tab_map = true

        -- Fonction pour gérer la touche Ctrl+Escape
        local function smart_escape()
            if vim.fn['copilot#GetDisplayedSuggestion']().text ~= '' then
                return vim.fn['copilot#Dismiss']()
            else
                return vim.api.nvim_replace_termcodes('<C-Esc>', true, false, true)
            end
        end

        -- Mappages des touches
        vim.api.nvim_set_keymap("i", "<C-l>", 'copilot#Accept("<CR>")', { silent = true, expr = true })

        -- Rendre la fonction accessible globalement
        _G.smart_escape = smart_escape

        -- Autocmd pour l'authentification automatique
        vim.api.nvim_create_autocmd("User", {
            pattern = "CopilotReady",
            callback = function()
                vim.cmd("Copilot auth")
            end,
        })
    end
}

