-- Syntax trees for highlighting, indentation and folding (see foldexpr
-- in options.lua). This is the `main` branch API: no modules, parsers
-- start per buffer via the FileType autocmd below.
return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    -- last commit supporting nvim 0.11 ("feat!: drop support for Nvim 0.11"
    -- follows it); remove the pin once nvim >= 0.12
    commit = "90cd6580",
    build = ":TSUpdate",
    lazy = false,
    config = function()
        require("nvim-treesitter").install(require("treesitter-parsers"))

        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
            callback = function(args)
                -- no parser installed for this filetype -> keep regex syntax
                if not pcall(vim.treesitter.start, args.buf) then
                    return
                end
                -- python's treesitter indent is still unreliable, its
                -- ftplugin indent is better
                if vim.bo[args.buf].filetype ~= "python" then
                    vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end
            end,
        })
    end,
}
