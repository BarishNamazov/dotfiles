local servers = { "json-lsp", "jq", "css-lsp", "beautysh", "eslint-lsp", "astro-language-server", "bash-language-server",
    "markdownlint", "lua-language-server", "prettier", "prettierd", "rust-analyzer", "shfmt", "cmake-language-server",
    "cmakelang", "starpls", "baz elrc-lsp", "bzl", "yaml-language-server", "eslint_d", "vtsls", "clang-format",
    "htmlhint", "ruff", "pyright", "mdx-analyzer", "clangd", "vue-language-server" }

local M = {}

function M.setup()
    -- --- Capabilities (from cmp) ----------------------------------------------
    local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    if ok_cmp then
        capabilities = vim.tbl_deep_extend("force", capabilities, cmp_nvim_lsp.default_capabilities())
    end

    -- --- Keymaps via LspAttach (applies to every attached client) -------------
    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("my.lsp.keys", { clear = true }),
        callback = function(args)
            local bufnr = args.buf
            local map = function(mode, lhs, rhs)
                vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, buffer = bufnr })
            end
            map("n", "gd", vim.lsp.buf.definition)
            map("n", "gi", vim.lsp.buf.implementation)
            map("n", "gr", function() require("telescope.builtin").lsp_references() end)
            map("n", "K", vim.lsp.buf.hover)
            map("n", "<leader>vws", vim.lsp.buf.workspace_symbol)
            map("n", "<leader>vd", vim.diagnostic.open_float)
            map("n", "<leader>vca", vim.lsp.buf.code_action)
            map("n", "ca", vim.lsp.buf.code_action)
            map("n", "<leader>vrr", vim.lsp.buf.references)
            map("n", "<leader>vrn", vim.lsp.buf.rename)
            map("i", "<C-h>", vim.lsp.buf.signature_help)
            map("n", "[d", vim.diagnostic.goto_next)
            map("n", "]d", vim.diagnostic.goto_prev)
        end,
    })

    vim.lsp.config("*", {
        capabilities = capabilities,
        root_markers = { ".git" },
    })

    vim.lsp.config("lua_ls", {
        filetypes = { "lua" },
        root_markers = { ".git", ".luarc.json", ".luarc.jsonc" },
        settings = {
            Lua = {
                runtime = { version = "Lua 5.1" }, -- adapt if you target LuaJIT, etc.
                diagnostics = {
                    globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                },
            },
        },
    })

    vim.lsp.config("eslint", {
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
        root_markers = {
            ".eslintrc", ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.json", "package.json", ".git",
        },
        settings = {
            format = { enable = true },
        },
    })

    local vue_plugin_path = vim.fn.stdpath("data")
        .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"
    local vue_plugin = nil
    if vim.uv and vim.uv.fs_stat(vue_plugin_path) or vim.loop and vim.loop.fs_stat(vue_plugin_path) then
        vue_plugin = {
            name = "@vue/typescript-plugin",
            location = vue_plugin_path,
            languages = { "vue" },
            configNamespace = "typescript",
        }
    end

    vim.lsp.config("vtsls", {
        filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
        root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
        settings = {
            vtsls = {
                tsserver = {
                    globalPlugins = vue_plugin and { vue_plugin } or nil,
                },
            },
        },
    })

    -- --- Enable the servers ---------------------------------------------------
    vim.lsp.enable(servers)
end

return M
