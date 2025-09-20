return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "williamboman/mason.nvim",
        "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
        require("mason").setup()
        require("barish.lsp").setup()
    end,
}
