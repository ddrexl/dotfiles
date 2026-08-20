-- Truecolor successor of vim-colors-solarized (which was pinned to the
-- 16-color terminal palette). Transparent background as before.
return {
    "maxmx03/solarized.nvim",
    lazy = false,
    priority = 1000,
    opts = {
        transparent = {
            enabled = true,
            pmenu = true,
            normal = true,
            normalfloat = true,
            neotree = true,
            telescope = true,
            lazy = true,
            mason = true,
        },
    },
    config = function(_, opts)
        require("solarized").setup(opts)
        vim.cmd.colorscheme("solarized")
    end,
}
