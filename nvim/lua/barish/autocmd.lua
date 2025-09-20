local autocmd = vim.api.nvim_create_autocmd

-- Before writing to buffer, delete trailing whitespaces.
autocmd("BufWritePre", {
    pattern = "*",
    command = [[%s/\s\+$//e]] -- e means suppress errors
})

-- Add keybindings to the attached LSP
autocmd("LspAttach", {
    callback = function(e)
        local opts = { buffer = e.buf }
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
        vim.keymap.set("n", "gr", function() require('telescope.builtin').lsp_references() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "ca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    end
})

-- Highlight yanked text for visual hint
autocmd('TextYankPost', {
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})


-- Set the working directory to the argument of vim
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        local args = vim.fn.argv()
        if #args > 0 then
            local path = args[1]
            local stat = vim.loop.fs_stat(path)
            if stat then
                local dir
                if stat.type == "directory" then
                    dir = vim.fn.fnamemodify(path, ":p")
                else
                    dir = vim.fn.fnamemodify(path, ":p:h")
                end
                local ok, err = pcall(vim.cmd, "cd " .. vim.fn.fnameescape(dir))
                if not ok then
                    vim.notify("Failed to change directory: " .. err, vim.log.levels.WARN)
                end
            end
        end
    end,
})
