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
                        return { "--hidden" }
                    end
                },
            },
        })

        local builtin = require('telescope.builtin')
        local function pick_cwd()
            -- window/tab-aware cwd (respects :cd/:lcd/:tcd)
            return vim.fn.getcwd()
        end

        local function with_cwd(fn, extra)
            return function()
                local opts = vim.tbl_extend('force', { cwd = pick_cwd() }, extra or {})
                fn(opts)
            end
        end

        -- files/grep/buffers use the current cwd
        vim.keymap.set('n', '<leader>pf', with_cwd(builtin.find_files), { desc = 'Telescope find files' })
        vim.keymap.set('n', '<leader>fg', with_cwd(builtin.live_grep), { desc = 'Telescope live grep' })
        vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })

        -- <C-p>: prefer git files, but *in the current cwd* and not the repo root
        vim.keymap.set('n', '<C-p>', function()
            local cwd = pick_cwd()
            -- use_git_root=false makes it respect cwd instead of jumping to repo top
            local ok = pcall(builtin.git_files, { cwd = cwd, use_git_root = false, show_untracked = true })
            if not ok then
                builtin.find_files({ cwd = cwd })
            end
        end, {})

        -- recent files filtered by current cwd (what you already intended)
        vim.keymap.set('n', '<leader><leader>', function()
            local cwd = pick_cwd()
            builtin.oldfiles({
                cwd_only = true,
                cwd = cwd,
                prompt_title = 'Recent Files in Current Directory',
            })
        end, { desc = 'Telescope recent files in current directory' })
    end
}
