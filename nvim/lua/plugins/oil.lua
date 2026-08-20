-- Edit directories like text buffers: rename/delete/create files with
-- normal editing, :w applies. `-` goes to the parent directory, also
-- from within an oil buffer.
return {
    "stevearc/oil.nvim",
    lazy = false, -- so `nvim <directory>` opens oil
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
        { "-", "<Cmd>Oil<CR>", desc = "Edit parent directory" },
    },
    opts = {
        view_options = { show_hidden = true },
    },
}
