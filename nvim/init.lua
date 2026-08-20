-- Neovim configuration, successor of the vimrc in this repo.
-- Layout:
--   lua/options.lua    settings ('set' equivalents)
--   lua/keymaps.lua    plugin-independent key mappings
--   lua/autocmds.lua   autocommands
--   lua/plugins/*.lua  one lazy.nvim spec per plugin/topic
-- Machine-local overrides go to ~/.nvim.local.lua (never overwritten,
-- like ~/.vimrc.local before).

-- Leaders must be set before lazy.nvim so <leader> in plugin `keys` specs
-- resolves to ',' and not the default '\'.
vim.g.mapleader = ","
vim.g.maplocalleader = "_"

require("options")
require("keymaps")
require("autocmds")

-- Bootstrap lazy.nvim on first start (replaces InstallVimPlugOnce)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    -- stylua: ignore
    vim.fn.system({
        "git", "clone", "--filter=blob:none", "--branch=stable",
        "https://github.com/folke/lazy.nvim.git", lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = { { import = "plugins" } },
    install = { colorscheme = { "solarized" } },
    checker = { enabled = false },
    change_detection = { notify = false },
    rocks = { enabled = false }, -- no plugin needs luarocks
    performance = {
        rtp = {
            -- lazy resets the rtp; keep the treesitter parser dir in it
            paths = { vim.fn.stdpath("data") .. "/site" },
        },
    },
})

-- Source local config if available
local local_config = vim.fn.expand("~/.nvim.local.lua")
if vim.uv.fs_stat(local_config) then
    dofile(local_config)
end
