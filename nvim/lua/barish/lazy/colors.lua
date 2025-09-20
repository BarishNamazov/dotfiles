function SetTheme(theme)
    theme = theme or "catppuccin-mocha"
    vim.cmd.colorscheme(theme)

    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
    vim.api.nvim_set_hl(0, "LspInlayHint", { bg = "none", fg = "#f2d6e6", italic = true })
    
    -- Better window separators
    vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#6c7086", bg = "none" })
    vim.api.nvim_set_hl(0, "VertSplit", { fg = "#6c7086", bg = "none" })
    
    -- Enhanced popup borders
    vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#89b4fa", bg = "none" })
    
    -- Better diagnostic signs
    vim.api.nvim_set_hl(0, "DiagnosticSignError", { fg = "#f38ba8", bg = "none" })
    vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { fg = "#f9e2af", bg = "none" })
    vim.api.nvim_set_hl(0, "DiagnosticSignInfo", { fg = "#89b4fa", bg = "none" })
    vim.api.nvim_set_hl(0, "DiagnosticSignHint", { fg = "#a6e3a1", bg = "none" })
    
    -- Winbar styling
    vim.api.nvim_set_hl(0, "WinBar", { fg = "#cdd6f4", bg = "none", bold = true })
    vim.api.nvim_set_hl(0, "WinBarNC", { fg = "#6c7086", bg = "none" })
end

return {
    {
        "catppuccin/nvim", name = "catppuccin",
    }
}
