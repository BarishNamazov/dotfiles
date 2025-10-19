return {
    "nvim-telescope/telescope.nvim",

    dependencies = {
        "nvim-lua/plenary.nvim"
    },

    config = function()
        require('telescope').setup({
            defaults = {
                file_ignore_patterns = {
                    "node_modules",
                    "%.git/",
                    "target/",
                    "build/",
                    "dist/",
                },
            },
            pickers = {
                find_files = {
                    hidden = true,
                },
                git_files = {
                    show_untracked = true,
                },
                live_grep = {
                    additional_args = function(opts)
                        return {"--hidden"}
                    end
                },
            },
        })

        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = 'Telescope find files' })
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
        vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
        vim.keymap.set('n', '<C-p>', function()
            local ok = pcall(builtin.git_files)
            if not ok then
                builtin.find_files()
            end
        end, {})
        -- on <leader><leader> open files from current directory recursively
        vim.keymap.set('n', '<leader><leader>', function()
            local cwd = vim.fn.getcwd()
            builtin.oldfiles({
                cwd_only = true,
                cwd = cwd,
                prompt_title = 'Recent Files in Current Directory'
            })
        end, { desc = 'Telescope recent files in current directory' })
    end
}
