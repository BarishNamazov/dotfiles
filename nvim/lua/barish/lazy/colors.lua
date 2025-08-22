function SetTheme(theme)
    theme = theme or "catppuccin-mocha"
    vim.cmd.colorscheme(theme)

    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
    vim.api.nvim_set_hl(0, "LspInlayHint", { bg = "none", fg = "#f2d6e6", italic = true })
end

return {
    {
        "catppuccin/nvim", name = "catppuccin",
    }
}
