-- Speed of light motion, replaces easymotion: s + two characters +
-- label jumps anywhere. f/F/t/T stay stock vim.
return {
    "folke/flash.nvim",
    opts = {
        modes = {
            char = { enabled = false },
        },
    },
    keys = {
        {
            "s",
            -- stylua: ignore
            function() require("flash").jump() end,
            mode = { "n", "x", "o" },
            desc = "Flash jump",
        },
    },
}
