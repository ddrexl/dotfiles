-- Plugin-independent key mappings. Plugin mappings live in the `keys`
-- field of their spec under lua/plugins/, LSP mappings in plugins/lsp.lua.
-- Gone since vim: Y (y$ is default now), visual * and # (default now),
-- <F12> pastetoggle (option removed, bracketed paste just works),
-- w!! sudo-write (broken in nvim, use sudoedit), <C-h/j/k/l> window
-- movement (provided by vim-tmux-navigator).

local map = vim.keymap.set

-- F keys
map({ 'n', 'x' }, '<F2>', '<Cmd>w<CR>')
map({ 'n', 'x' }, '<F3>', '<Cmd>close<CR>')
map({ 'n', 'x' }, '<F4>', '<Cmd>bd<CR>')
-- <F5>/<F6> cycle buffers, defined in plugins/bufferline.lua
-- some terminals send shifted F5/F6 as F17/F18, map both
map({ 'n', 'x' }, '<S-F5>', '<Cmd>cprevious<CR>')
map({ 'n', 'x' }, '<F17>', '<Cmd>cprevious<CR>')
map({ 'n', 'x' }, '<S-F6>', '<Cmd>cnext<CR>')
map({ 'n', 'x' }, '<F18>', '<Cmd>cnext<CR>')

-- tags: with an attached LSP these use the language server ('tagfunc'),
-- otherwise the ctags file from the git_template hooks
map({ 'n', 'x' }, '<F7>', '<C-T>')
map({ 'n', 'x' }, '<F8>', '<C-]>')
map({ 'n', 'x' }, '<C-F8>', '<C-W><C-]>')

-- Wrapped lines goes down/up to next row, rather than next line in file.
map({ 'n', 'x', 'o' }, 'j', 'gj')
map({ 'n', 'x', 'o' }, 'k', 'gk')

-- buffer movement (tab movement before the switch to neovim),
-- also defined in plugins/bufferline.lua

-- Folding with the spacebar
map('n', '<Space>', 'za')

-- toggle search highlighting
map('n', '<leader>/', '<Cmd>nohlsearch<CR>', { silent = true })

-- Change Working Directory to that of the current file
-- map('ca', 'cwd', 'lcd %:p:h')
-- map('ca', 'cd.', 'lcd %:p:h')

-- Visual shifting (does not exit Visual mode)
map('x', '<', '<gv')
map('x', '>', '>gv')

-- Allow using the repeat operator with a visual selection (!)
-- http://stackoverflow.com/a/8064607/127816
map('x', '.', ':normal .<CR>', { silent = true })

-- Adjust viewports to the same size
map('n', '<leader>=', '<C-w>=')

-- Easier horizontal scrolling
map('n', 'zl', 'zL')
map('n', 'zh', 'zH')

-- Open quickfix window
map('n', '<leader>q', '<Cmd>copen<CR>', { silent = true })
-- Clear quickfix window
map('n', '<leader>cq', '<Cmd>cexpr []<CR>', { silent = true })
