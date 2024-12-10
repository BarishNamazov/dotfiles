return {
    {
        "nvim-lua/plenary.nvim",
        name = "plenary"
    },

    {
        "eandrju/cellular-automaton.nvim"
    },

    {
        "mbbill/undotree",
        config = function()
            vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
        end
    }
}
