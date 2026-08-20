-- Auto-completion, replaces asyncomplete with the same feel:
-- popup opens while typing, Tab/S-Tab cycle, Enter accepts.
-- Deliberately no snippet library (UltiSnips was never really used).
return {
    "saghen/blink.cmp",
    version = "1.*", -- pinned: ships a prebuilt fuzzy-matcher binary
    event = "InsertEnter",
    opts = {
        keymap = {
            preset = "none",
            ["<Tab>"] = { "select_next", "fallback" },
            ["<S-Tab>"] = { "select_prev", "fallback" },
            ["<CR>"] = { "accept", "fallback" },
        },
        completion = {
            list = { selection = { preselect = false, auto_insert = true } },
            documentation = { auto_show = true },
        },
        sources = {
            default = { "lsp", "path", "buffer" },
        },
        cmdline = { enabled = false }, -- keep the classic wildmenu
        fuzzy = { implementation = "prefer_rust_with_warning" },
    },
}
