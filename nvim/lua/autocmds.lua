local function augroup(name)
    return vim.api.nvim_create_augroup(name, { clear = true })
end
local autocmd = vim.api.nvim_create_autocmd

-- Remove trailing whitespaces
-- (set vim.b.no_strip_whitespace = 1 to disable for a buffer)
local strip_filetypes = { c = true, cpp = true, python = true, xml = true, yaml = true }
autocmd("BufWritePre", {
    group = augroup("strip_whitespace"),
    callback = function(args)
        if vim.b[args.buf].no_strip_whitespace or not strip_filetypes[vim.bo[args.buf].filetype] then
            return
        end
        local view = vim.fn.winsaveview()
        vim.cmd([[keeppatterns %s/\s\+$//e]])
        vim.fn.winrestview(view)
    end,
})
autocmd("FileType", {
    group = augroup("strip_whitespace_markdown"),
    pattern = "markdown",
    callback = function(args)
        vim.b[args.buf].no_strip_whitespace = 1
    end,
})

-- Instead of reverting the cursor to the last position in the buffer, we
-- set it to the first line when editing a git commit message
autocmd("FileType", {
    group = augroup("git_commit"),
    pattern = "gitcommit",
    callback = function()
        vim.api.nvim_win_set_cursor(0, { 1, 0 })
    end,
})

-- ROS and feed files are xml
vim.filetype.add({
    extension = {
        atom = "xml",
        launch = "xml",
        rss = "xml",
    },
})

-- Filetypes with special indentation
autocmd("FileType", {
    group = augroup("special_tabs"),
    pattern = { "cmake", "yaml" },
    callback = function()
        vim.bo.tabstop = 2
        vim.bo.softtabstop = 2
        vim.bo.shiftwidth = 2
        vim.bo.expandtab = true
    end,
})
autocmd("FileType", {
    group = augroup("special_tabs_make"),
    pattern = "make",
    callback = function()
        vim.bo.tabstop = 8
        vim.bo.softtabstop = 8
        vim.bo.shiftwidth = 8
        vim.bo.expandtab = false
    end,
})

-- Echo the diagnostic under the cursor in the command line (the old
-- g:lsp_diagnostics_echo_cursor behavior; floats stay disabled)
local echoed = false
local diag_echo = augroup("diagnostic_echo")
autocmd("CursorHold", {
    group = diag_echo,
    callback = function()
        local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
        local diagnostics = vim.diagnostic.get(0, { lnum = lnum })
        if #diagnostics == 0 then
            return
        end
        table.sort(diagnostics, function(a, b)
            return a.severity < b.severity
        end)
        local msg = diagnostics[1].message:gsub("\n", " ")
        if #msg > vim.v.echospace then
            msg = msg:sub(1, vim.v.echospace - 1) .. "…"
        end
        vim.api.nvim_echo({ { msg } }, false, {})
        echoed = true
    end,
})
autocmd({ "CursorMoved", "InsertEnter" }, {
    group = diag_echo,
    callback = function()
        if echoed then
            vim.api.nvim_echo({ { "" } }, false, {})
            echoed = false
        end
    end,
})
