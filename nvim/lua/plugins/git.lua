-- Git in Vim!! fugitive stays, gitsigns adds hunk signs and mappings.
return {
    {
        "tpope/vim-fugitive",
        cmd = { "Git", "Gvdiffsplit", "Gdiffsplit", "Gread", "Gwrite", "Gedit" },
        keys = {
            { "<leader>gs", "<Cmd>Git<CR>", desc = "Git status" },
            { "<leader>gd", "<Cmd>Gvdiffsplit<CR>", desc = "Git diff file" },
            { "<leader>gc", "<Cmd>Git commit<CR>", desc = "Git commit" },
            { "<leader>gb", "<Cmd>Git blame<CR>", desc = "Git blame" },
            {
                "<leader>gl",
                ":Git --paginate log --graph --pretty=format:'%h %d %s <%an> [%ad]' --abbrev-commit --date=relative -30<CR>",
                silent = true,
                desc = "Git log",
            },
            { "<leader>gp", "<Cmd>Git push<CR>", desc = "Git push" },
            { "<leader>gr", "<Cmd>Gread<CR>", desc = "Git checkout file" },
            { "<leader>gw", "<Cmd>Gwrite<CR>", desc = "Git add file" },
            { "<leader>ge", "<Cmd>Gedit<CR>", desc = "Git edit" },
        },
        config = function()
            vim.api.nvim_create_autocmd("BufReadPost", {
                group = vim.api.nvim_create_augroup("fugitive_buffers", { clear = true }),
                pattern = "fugitive://*",
                callback = function()
                    vim.bo.bufhidden = "delete"
                end,
            })

            -- this matches the <leader>gl mapping above
            vim.api.nvim_create_autocmd("Syntax", {
                group = vim.api.nvim_create_augroup("git_log_syntax", { clear = true }),
                pattern = "git",
                callback = function()
                    vim.cmd([[
                        syn match gitLgLine     /^[_\*|\/\\ ]\+\(\<\x\{4,40\}\>.*\)\?$/
                        syn match gitLgGraph    /^[_\*|\/\\ ]\+/ contained containedin=gitLgLine nextgroup=gitHashAbbrev skipwhite
                        syn match gitLgDate     /\[.*\]/ contained containedin=gitLgLine
                        syn match gitLgRefs     /(.*)/ contained containedin=gitLgLine
                        syn match gitLgCommit   /^[^-]\+- / contained containedin=gitLgLine nextgroup=gitLgIdentity skipwhite
                        syn match gitLgIdentity /<.*>/ contained containedin=gitLgLine
                        hi def link gitLgGraph    Comment
                        hi def link gitLgDate     gitDate
                        hi def link gitLgRefs     gitReference
                        hi def link gitLgIdentity gitIdentity
                    ]])
                end,
            })
        end,
    },
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            on_attach = function(bufnr)
                local gitsigns = require("gitsigns")
                local function map(mode, lhs, rhs, desc)
                    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
                end

                map("n", "]c", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "]c", bang = true })
                    else
                        gitsigns.nav_hunk("next")
                    end
                end, "Next hunk")
                map("n", "[c", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "[c", bang = true })
                    else
                        gitsigns.nav_hunk("prev")
                    end
                end, "Previous hunk")
                map("n", "<leader>hs", gitsigns.stage_hunk, "Stage hunk")
                map("n", "<leader>hr", gitsigns.reset_hunk, "Reset hunk")
                map("n", "<leader>hp", gitsigns.preview_hunk, "Preview hunk")
            end,
        },
    },
}
