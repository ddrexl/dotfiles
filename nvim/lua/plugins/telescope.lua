-- Fuzzy finding, replaces CtrlP on the same keys. Uses ripgrep.
return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        "debugloop/telescope-undo.nvim",
    },
    cmd = "Telescope",
    keys = {
        { "<leader>f", "<Cmd>Telescope find_files<CR>", desc = "Find files" },
        { "<leader>b", "<Cmd>Telescope buffers<CR>", desc = "Find buffers" },
        { "<leader>r", "<Cmd>Telescope oldfiles<CR>", desc = "Find recent files" },
        { "<leader>t", "<Cmd>Telescope lsp_dynamic_workspace_symbols<CR>", desc = "Find symbols (was: tags)" },
        { "<leader>u", "<Cmd>Telescope undo<CR>", desc = "Undo history" },
        { "<leader>a", "<Cmd>Telescope live_grep<CR>", desc = "Live grep" },
        { "<leader>*", "<Cmd>Telescope grep_string<CR>", desc = "Grep word under cursor" },
    },
    opts = {
        defaults = {
            -- stylua: ignore
            file_ignore_patterns = {
                "^%.git/", "^%.hg/", "^%.svn/",
                "%.pyc$", "%.pyd$", "%.exe$", "%.so$", "%.dll$",
            },
        },
        pickers = {
            find_files = { hidden = true },
        },
    },
    config = function(_, opts)
        local telescope = require("telescope")
        telescope.setup(opts)
        telescope.load_extension("fzf")
        telescope.load_extension("undo")
    end,
}
