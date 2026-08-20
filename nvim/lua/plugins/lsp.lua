-- Native LSP. Servers are installed by mason (:Mason), enabled by
-- mason-lspconfig. Keymaps and diagnostics reproduce the vim-lsp block
-- from the old vimrc.
--
-- The host is kept free of language runtimes (development happens in
-- devcontainers), so servers that need node or dotnet only register
-- where that runtime exists — e.g. inside a devcontainer.
local has_node = vim.fn.executable("node") == 1
local has_dotnet = vim.fn.executable("dotnet") == 1
local has_rust = vim.fn.executable("rustc") == 1

local servers = { "basedpyright", "ruff", "lua_ls" }
if has_node then
    vim.list_extend(servers, { "vtsls", "bashls" })
end
if has_rust then
    table.insert(servers, "rust_analyzer")
end

-- installed servers auto-enable even without their runtime, block those
local no_auto_enable = { "stylua" } -- formatter, not an LSP (see format.lua)
if not has_rust then
    table.insert(no_auto_enable, "rust_analyzer")
end

-- stylua: ignore
local mason_tools = {
    -- language servers (mason package names)
    "basedpyright", "ruff", "lua-language-server",
    -- formatters (see format.lua)
    "stylua", "shfmt", "taplo", "clang-format",
    -- parser compiler for nvim-treesitter
    "tree-sitter-cli",
}
if has_node then
    vim.list_extend(mason_tools, { "vtsls", "bash-language-server", "prettier" })
end
if has_dotnet then
    table.insert(mason_tools, "roslyn")
end
if has_rust then
    table.insert(mason_tools, "rust-analyzer")
end

return {
    {
        "mason-org/mason.nvim",
        opts = {
            registries = {
                "github:mason-org/mason-registry",
                "github:Crashdummyy/mason-registry", -- provides roslyn (C#)
            },
        },
    },
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
        opts = {
            ensure_installed = servers,
            automatic_enable = { exclude = no_auto_enable },
        },
    },
    {
        -- installs everything else and gives install.sh a synchronous
        -- :MasonToolsInstallSync for bootstrapping
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = { "mason-org/mason.nvim" },
        opts = {
            ensure_installed = mason_tools,
        },
    },
    {
        -- nvim API completion and docs when editing this config
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
    {
        -- C#: the Roslyn language server (the one VS Code uses),
        -- self-attaching, not managed by mason-lspconfig
        "seblyng/roslyn.nvim",
        enabled = has_dotnet,
        ft = "cs",
        opts = {},
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            -- completion capabilities from blink.cmp for all servers
            local ok, blink = pcall(require, "blink.cmp")
            if ok then
                vim.lsp.config("*", { capabilities = blink.get_lsp_capabilities() })
            end

            -- basedpyright and ruff share python buffers:
            -- basedpyright types/hover, ruff lint/imports
            vim.lsp.config("basedpyright", {
                settings = { basedpyright = { disableOrganizeImports = true } },
            })
            vim.lsp.config("ruff", {
                on_attach = function(client)
                    client.server_capabilities.hoverProvider = false
                end,
            })

            -- diagnostics like vim-lsp had them: signs with these glyphs,
            -- no virtual text, no floats (echo handled in autocmds.lua)
            vim.diagnostic.config({
                virtual_text = false,
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "✗",
                        [vim.diagnostic.severity.WARN] = "‼",
                        [vim.diagnostic.severity.INFO] = "ℹ",
                        [vim.diagnostic.severity.HINT] = "➤",
                    },
                },
                update_in_insert = false,
                severity_sort = true,
            })

            -- the gr* defaults would delay our gr (references) below
            for _, lhs in ipairs({ "grn", "grr", "gra", "gri", "grt" }) do
                pcall(vim.keymap.del, "n", lhs)
            end
            pcall(vim.keymap.del, "x", "gra")

            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("lsp_buffer_enabled", { clear = true }),
                callback = function(args)
                    local function map(mode, lhs, rhs)
                        vim.keymap.set(mode, lhs, rhs, { buffer = args.buf, silent = true })
                    end

                    -- 'tagfunc' is set automatically, F7/F8 use the server now
                    vim.opt_local.signcolumn = "number"

                    map("n", "gd", vim.lsp.buf.definition)
                    map("n", "gs", "<Cmd>Telescope lsp_document_symbols<CR>")
                    map("n", "gS", "<Cmd>Telescope lsp_dynamic_workspace_symbols<CR>")
                    map("n", "gr", "<Cmd>Telescope lsp_references<CR>")
                    map("n", "gi", vim.lsp.buf.implementation)
                    map("n", "gt", vim.lsp.buf.type_definition)
                    map("n", "<leader>m", vim.lsp.buf.rename)
                    -- stylua: ignore start
                    map("n", "[g", function() vim.diagnostic.jump({ count = -1, float = false }) end)
                    map("n", "]g", function() vim.diagnostic.jump({ count = 1, float = false }) end)
                    -- stylua: ignore end
                    map("n", "K", vim.lsp.buf.hover)
                    map({ "n", "x" }, "<leader>d", vim.lsp.buf.code_action)
                    -- <leader>.q formats, defined globally in format.lua
                end,
            })
        end,
    },
}
