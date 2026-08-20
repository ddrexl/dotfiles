-- File browser sidebar, replaces NERDTree: same keys, self-sizing width,
-- closes after opening a file. Directory buffers belong to oil.nvim.
return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    cmd = "Neotree",
    keys = {
        { "<C-n>", "<Cmd>Neotree toggle<CR>", desc = "Toggle file tree" },
        { "<leader>n", "<Cmd>Neotree reveal<CR>", desc = "Reveal current file in tree" },
    },
    opts = {
        window = {
            width = "25%", -- share of the terminal, not a fixed column count
            auto_expand_width = true, -- grow past that to fit the longest entry
        },
        filesystem = {
            hijack_netrw_behavior = "disabled", -- oil.nvim owns directory buffers
            filtered_items = {
                hide_dotfiles = false,
                hide_gitignored = false,
                hide_by_name = { ".git", ".hg", ".svn", ".bzr" },
                hide_by_pattern = { "*.pyc", "*.pyd", "*.swo", "*.swp", "*~" },
            },
        },
        event_handlers = {
            {
                event = "file_open_requested",
                handler = function()
                    require("neo-tree.command").execute({ action = "close" })
                end,
            },
        },
    },
}
