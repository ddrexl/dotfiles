-- Treesitter parsers to install. Own module so install.sh can install
-- them headlessly with the same list (see configure_neovim).
-- stylua: ignore
return {
    "bash", "c", "c_sharp", "cmake", "cpp", "css", "diff", "dockerfile",
    "git_rebase", "gitcommit", "html", "javascript", "json", "lua", "make",
    "markdown", "markdown_inline", "python", "query", "rust", "toml", "tsx",
    "typescript", "vim", "vimdoc", "xml", "yaml",
}
