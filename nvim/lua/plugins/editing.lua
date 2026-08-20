-- Editing helpers. The tpope classics work unchanged in Neovim;
-- vim-surround is replaced by nvim-surround with identical mappings.
-- vim-commentary is gone: gc/gcc are built into Neovim now.
return {
    { "kylechui/nvim-surround", version = "*", event = "VeryLazy", opts = {} },
    { "tpope/vim-repeat", event = "VeryLazy" },
    { "tpope/vim-unimpaired", event = "VeryLazy" },
    { "tpope/vim-abolish", event = "VeryLazy" },
    { "wellle/targets.vim", event = "VeryLazy" },
    { "michaeljsmith/vim-indent-object", event = "VeryLazy" },
    {
        "andymass/vim-matchup",
        event = "VeryLazy",
        config = function()
            -- treesitter-based matching; the old nvim-treesitter module
            -- config does not exist on the ts main branch
            pcall(function()
                require("match-up").setup({ treesitter = {} })
            end)
        end,
    },
}
