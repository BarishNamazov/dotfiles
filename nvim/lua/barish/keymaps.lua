-- Set map leader to space
vim.g.mapleader = " "

-- Open the netrw explorer
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Move selected text up and down by a line
-- and then reindent it
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Join the next line into the current line
vim.keymap.set("n", "J", "mzJ`z")

-- Recenter the cursor after scrolling half-screen
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Recenter the cursor after search result
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Paste over without losing the current register
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Delete without losing the current register
vim.keymap.set({ "n", "v" }, "<leader>d", "\"_d")

-- Copy to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Format
vim.keymap.set("n", "<leader>f", function()
    local conform = require("conform")
    local buf = vim.api.nvim_get_current_buf()
    local ft = vim.bo[buf].filetype

    -- Check if Conform has any formatters for this filetype
    local formatters = conform.list_formatters(buf)
    if formatters and #formatters > 0 then
        -- Conform has a formatter, use it
        conform.format({ async = true, lsp_fallback = true })
    else
        -- No formatter configured, use LSP directly
        vim.lsp.buf.format({ async = true })
    end
end, { desc = "Format with Conform or fallback to LSP" })

-- Start find and replace with the word under the cursor
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Make the current file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- Make it rain
vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>");
