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
        vim.keymap.set("n", "ca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "<leader>r", function() vim.lsp.buf.rename() end, opts)
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
-- Handle "nvim oil:///path" and regular paths
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        local args = vim.fn.argv()
        if #args == 0 then
            return
        end

        local path = args[1]

        -- Ignore stdin ("-")
        if path == "-" then
            return
        end

        -- Normalize Oil URIs -> filesystem path
        -- oil:///home/user/foo   -> /home/user/foo
        -- oil://home/user/foo    -> /home/user/foo (just in case)
        if path:match("^oil://") then
            path = path:gsub("^oil:///*", "/")
        end

        -- If it's a file/dir that exists, cd accordingly
        local uv = vim.uv or vim.loop
        local stat = uv.fs_stat(path)
        if not stat then
            return
        end

        local dir
        if stat.type == "directory" then
            dir = vim.fn.fnamemodify(path, ":p")
        else
            dir = vim.fn.fnamemodify(path, ":p:h")
        end

        local ok, err = pcall(function()
            vim.cmd("cd " .. vim.fn.fnameescape(dir))
        end)
        if not ok then
            vim.notify("Failed to change directory: " .. tostring(err), vim.log.levels.WARN)
        end
    end,
})
