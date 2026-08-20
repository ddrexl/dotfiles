-- Buffers along the top. S-H/S-L used to cycle tab pages; buffers turned
-- out to be what I actually use, so both these and F5/F6 cycle buffers.
return {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    keys = {
        { "<S-h>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Previous buffer" },
        { "<S-l>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
        { "<F5>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Previous buffer" },
        { "<F6>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
    },
    opts = {
        options = {
            show_buffer_close_icons = false,
            diagnostics = false,
        },
    },
}
