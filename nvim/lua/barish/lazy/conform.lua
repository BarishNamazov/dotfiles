return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
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
    },
}
