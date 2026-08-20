-- Statusline, replaces vim-airline. Powerline separators need the
-- PowerlineSymbols font that install.sh already provides.
return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        options = {
            theme = "solarized_dark",
            section_separators = { left = "", right = "" },
            component_separators = { left = "", right = "" },
        },
        sections = {
            lualine_b = {
                "branch",
                "diff",
                {
                    "diagnostics",
                    symbols = { error = "✗ ", warn = "‼ ", info = "ℹ ", hint = "➤ " },
                },
            },
        },
    },
}
