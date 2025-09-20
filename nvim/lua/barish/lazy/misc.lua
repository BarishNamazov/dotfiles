return {
    -- Shared utility functions used across many plugins
    {
        "nvim-lua/plenary.nvim",
        name = "plenary",
    },

    -- Silly cellular automaton animations for fun breaks
    {
        "eandrju/cellular-automaton.nvim",
    },

    -- Undo history visualizer with toggle keymap
    {
        "mbbill/undotree",
        config = function()
            vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
        end,
    },

    -- Seamless navigation between Neovim and tmux panes
    {
        "christoomey/vim-tmux-navigator",
        cmd = {
            "TmuxNavigateLeft",
            "TmuxNavigateDown",
            "TmuxNavigateUp",
            "TmuxNavigateRight",
            "TmuxNavigatePrevious",
            "TmuxNavigatorProcessList",
        },
        keys = {
            { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
            { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
            { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
            { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
            { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
        },
    },

    -- Claude chatbot integration for inline AI assistance
    {
        "greggh/claude-code.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            require("claude-code").setup({ window = { position = "vertical" } })
        end,
    },

    -- GitHub Copilot integration with a manual suggestion trigger
    {
        "github/copilot.vim",
        config = function()
            vim.keymap.set("i", "<C-Space>", "<Plug>(copilot-suggest)", { desc = "Trigger Copilot suggestion" })
        end,
    },

    -- LazyGit command integration for a nicer git UI
    {
        "kdheepak/lazygit.nvim",
        lazy = true,
        cmd = {
            "LazyGit",
            "LazyGitConfig",
            "LazyGitCurrentFile",
            "LazyGitFilter",
            "LazyGitFilterCurrentFile",
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        keys = {
            { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
        },
    },

    -- Automatically detect indentation settings per file
    {
        "tpope/vim-sleuth",
    },
}
