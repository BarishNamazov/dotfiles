return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "stevearc/conform.nvim",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },

    config = function()
        require("conform").setup({
            formatters_by_ft = {
                javascript = { "prettierd", "prettier" },
                typescript = { "prettierd", "prettier" },
                javascriptreact = { "prettierd", "prettier" },
                typescriptreact = { "prettierd", "prettier" },
                vue = { "prettierd", "prettier" },
                json = { "prettierd", "prettier" },
                css = { "prettierd", "prettier" },
                markdown = { "prettierd" },
                cpp = { "clang_format" },
                cmake = {},
                bazel = {},
                bzl = {},
            },
        })

        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        local on_attach = function(_, bufnr)
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end

        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "rust_analyzer",
                "clangd",
                "ruff",
                "eslint",
                "vtsls",
                "vue_ls"
            },
            handlers = {
                function(server_name)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities,
                        on_attach = on_attach
                    }
                end,

                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        on_attach = on_attach,
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = { version = "Lua 5.1" },
                                diagnostics = {
                                    globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                                }
                            }
                        }
                    }
                end,

                ["eslint"] = function()
                    local lspconfig = require("lspconfig")

                    -- Determine which eslint executable to use
                    local eslint_cmd = "eslint"
                    if vim.fn.executable("eslint_d") == 1 then
                        eslint_cmd = "eslint_d"
                    end

                    lspconfig.eslint.setup {
                        capabilities = capabilities,
                        on_attach = on_attach,
                        settings = {
                            eslint = {
                                execPath = eslint_cmd,
                            },
                            format = { enable = true },
                        },
                    }
                end,

                ["vtsls"] = function()
                    local lspconfig = require("lspconfig")
                    local util = require("lspconfig.util")

                    local vue_plugin = {
                        name = '@vue/typescript-plugin',
                        location = vim.fn.stdpath('data') ..
                            '/mason/packages/vue-language-server/node_modules/@vue/language-server',
                        languages = { 'vue' },
                        configNamespace = 'typescript',
                    }

                    lspconfig.vtsls.setup {
                        capabilities = capabilities,
                        on_attach = on_attach,
                        settings = {
                            vtsls = {
                                tsserver = {
                                    globalPlugins = { vue_plugin }
                                }
                            }
                        },
                        filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
                        root_dir = util.root_pattern("tsconfig.json", "jsconfig.json", "package.json", ".git")
                    }
                end,

                ["vue_ls"] = function()
                    local lspconfig = require("lspconfig")

                    lspconfig.vue_ls.setup {
                        capabilities = capabilities,
                        on_attach = on_attach,
                    }
                end,
            }
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-Space>'] = cmp.mapping.confirm({ select = true }),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
            }, {
                { name = 'buffer' },
            })
        })

        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
                max_width = 80,
                max_height = 20,
            },
            virtual_text = {
                spacing = 4,
                prefix = "●",
            },
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = "✗",
                    [vim.diagnostic.severity.WARN] = "⚠",
                    [vim.diagnostic.severity.INFO] = "ⓘ",
                    [vim.diagnostic.severity.HINT] = "💡",
                },
            },
            severity_sort = true,
        })
    end,

    opts = {
        inlay_hints = true
    }
}
