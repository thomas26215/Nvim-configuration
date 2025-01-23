return {
    "github/copilot.vim",
    config = function()
        vim.g.copilot_no_tab_map = true
        vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
        
        vim.api.nvim_create_autocmd("User", {
            pattern = "CopilotReady",
            callback = function()
                -- Insérez ici la commande que vous souhaitez exécuter
                vim.cmd("Copilot auth")
            end,
        })
    end
}

