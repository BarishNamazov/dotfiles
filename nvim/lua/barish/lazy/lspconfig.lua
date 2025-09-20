return {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "williamboman/mason.nvim",
        "neovim/nvim-lspconfig",
        "hrsh7th/cmp-nvim-lsp",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
        local tools = {
            "json-lsp",
            "jq",
            "css-lsp",
            "beautysh",
            "eslint-lsp",
            "astro-language-server",
            "bash-language-server",
            "markdownlint",
            "lua-language-server",
            "prettier",
            "prettierd",
            "rust-analyzer",
            "shfmt",
            "cmake-language-server",
            "cmakelang",
            "starpls",
            "bazelrc-lsp",
            "bzl",
            "yaml-language-server",
            "eslint_d",
            "vtsls",
            "clang-format",
            "htmlhint",
            "ruff",
            "pyright",
            "mdx-analyzer",
            "clangd",
            "vue-language-server",
        }

        local servers = {
            "astro",
            "bashls",
            "bazelrc_lsp",
            "bzl",
            "clangd",
            "cmake",
            "cssls",
            "eslint",
            "jsonls",
            "lua_ls",
            "mdx_analyzer",
            "pyright",
            "rust_analyzer",
            "starpls",
            "vtsls",
            "yamlls",
        }

        require("mason").setup()
        require("mason-tool-installer").setup({
            ensure_installed = tools,
            auto_update = false,
            run_on_start = true,
        })

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()
        capabilities = vim.tbl_deep_extend("force", capabilities, cmp_capabilities)

        local mason_lspconfig = require("mason-lspconfig")

        mason_lspconfig.setup({
            ensure_installed = servers,
            automatic_enable = true
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
                    runtime = { version = "Lua 5.1" },
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
    end,
}
