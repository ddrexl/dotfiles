-- Formatting, replaces vim-autoformat. Unlike before (format everything
-- on every write), only filetypes listed here are formatted on save.
-- The taplo entry also replaces the old Cargo.toml lint autocmd.
return {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    keys = {
        {
            "<leader>.q",
            -- stylua: ignore
            function() require("conform").format({ async = true, lsp_format = "fallback" }) end,
            desc = "Format buffer",
        },
    },
    opts = function()
        local formatters_by_ft = {
            c = { "clang_format" },
            cpp = { "clang_format" },
            lua = { "stylua" },
            python = { "ruff_format" },
            sh = { "shfmt" },
            toml = { "taplo" },
        }
        -- formatters needing a language toolchain, which only
        -- devcontainers have
        if vim.fn.executable("node") == 1 then
            formatters_by_ft.javascript = { "prettier" }
            formatters_by_ft.typescript = { "prettier" }
        end
        if vim.fn.executable("rustfmt") == 1 then
            formatters_by_ft.rust = { "rustfmt" }
        end
        return {
            formatters_by_ft = formatters_by_ft,
            format_on_save = { timeout_ms = 1000, lsp_format = "never" },
        }
    end,
}
