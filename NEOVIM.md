# From vim to neovim — field guide

The vimrc lives on in this repo, but `~/.config/nvim` (→ `nvim/` here) is
home now. This is the map for the transition: what got absorbed into
Neovim itself, what your fingers already know, what's genuinely new, and
what to do when something feels off.

## The config at a glance

| I want to change... | Edit |
|---|---|
| a setting (`set ...`) | `nvim/lua/options.lua` |
| a general key mapping | `nvim/lua/keymaps.lua` |
| an autocommand | `nvim/lua/autocmds.lua` |
| a plugin or its keys | its file in `nvim/lua/plugins/` |
| LSP behavior/keymaps | `nvim/lua/plugins/lsp.lua` |
| something on this machine only | `~/.nvim.local.lua` (the new `~/.vimrc.local`) |

Management commands, each opens a UI:

- `:Lazy` — plugin manager (replaces vim-plug). `S` syncs. Versions are
  pinned by `nvim/lazy-lock.json`, which is committed — a fresh machine
  gets exactly these plugin versions.
- `:Mason` — installs language servers and formatters (`i` to install,
  `X` to remove).
- `:checkhealth` — first stop when anything misbehaves.

## Deleted from the config because it's built-in now

These reflexes keep working with zero config carried over:

- `Y` yanks to end of line (was `nnoremap Y y$`).
- `*`/`#` search the visual selection (the old `VisualSearch()` function
  is a Neovim default since 0.8).
- **`gcc` comments a line, `gc` a motion/selection** — vim-commentary is
  in the box now, same keys.
- Persistent undo across sessions — no `undodir` juggling, it's on by
  default under `~/.local/state/nvim/undo`.
- Sane defaults: `hidden`, `autoread`, `hlsearch`, `incsearch`,
  `wildmenu`, `backspace`, `laststatus=2`, `smarttab`, no backup files.
- Bracketed paste: **`<F12>` pastetoggle is gone** — the option was
  removed from Neovim because pasting just works. Paste away.
- `q` closes quickfix/help windows.

## Muscle memory: what your fingers already know

Everything below is the same key as before — only the engine changed.

| Keys | Still does | Engine now |
|---|---|---|
| `<F2>` / `<F3>` / `<F4>` | save / close window / delete buffer | — |
| `<F5>` / `<F6>` | previous/next buffer | bufferline (visual order, top bar) |
| `<S-F5>` / `<S-F6>` | quickfix prev/next | — |
| `<F7>` / `<F8>` / `<C-F8>` | tag-stack pop / jump / jump in split | **LSP** when attached (`tagfunc`), ctags fallback |
| `<C-h/j/k/l>` | window & tmux pane navigation | vim-tmux-navigator |
| `,f` `,b` `,r` `,u` | find files / buffers / recent / undo | Telescope (was CtrlP) |
| `,t` | symbol search | LSP workspace symbols (was ctags) |
| `,/` | clear search highlight | — |
| `s` | jump anywhere | flash.nvim (was easymotion) — `s` + 2 chars + label |
| `<Space>` | toggle fold | folds come from treesitter now |
| `,q` / `,cq` | open / clear quickfix | — |
| `,=`, `zl`/`zh`, visual `<`/`>`, visual `.` | as before | — |
| `,gs` `,gd` `,gc` `,gb` `,gl` `,gp` `,gr` `,gw` `,ge` | fugitive, unchanged | — |
| `ys` / `cs` / `ds` | surround | nvim-surround (same maps) |
| `Tab`/`S-Tab`/`CR` in popup | cycle / accept completion | blink.cmp (was asyncomplete) |
| tpope suite | unimpaired `[`/`]`, abolish `:S`, targets, indent-object, matchup `%` | unchanged |

**Changed on purpose:** `S-H`/`S-L` now cycle **buffers** (they cycled tab
pages before; you said tabs never stuck). With the bufferline along the
top you can finally see what F5/F6/S-H/S-L are walking through.

## The LSP spec you wrote years ago is finally on

The vim-lsp block in the vimrc was fully configured but commented out.
Those exact keymaps now activate per buffer whenever a language server
attaches (watch for the sign column glyphs `✗ ‼ ℹ ➤`):

| Keys | Action |
|---|---|
| `gd` | go to definition (`<C-o>` / `<F7>` to come back) |
| `gr` | references (Telescope list) |
| `gi` / `gt` | implementation / type definition |
| `gs` / `gS` | document / workspace symbols |
| `K` | hover docs (press again to enter the float, `q` closes) |
| `,m` | rename symbol project-wide |
| `,d` | code action (normal & visual) |
| `[g` / `]g` | previous/next diagnostic; message echoes below when the cursor rests |
| `,.q` | format buffer (works everywhere conform has a formatter) |

Servers on this host: **Python** (basedpyright + ruff) and **Lua**
(lua_ls, so editing this very config gets API completion).

**The devcontainer rule:** servers needing a language runtime register
only where that runtime exists. On the lean host, TypeScript (vtsls),
bash (bashls), C# (roslyn), Rust (rust-analyzer) and prettier/rustfmt
stay dormant. Run `nvim` inside a devcontainer that has node / dotnet /
rustc, and they install & attach automatically — same dotfiles, no
edits. (First use in a container: `:MasonToolsInstall`.)

## Genuinely new tricks

- **`-` opens oil.nvim**: the parent directory as an *editable buffer*.
  Rename files by editing lines, `dd` to delete, `o` + type a name to
  create (end with `/` for a directory), then `:w` applies it all —
  with a confirmation preview. This is the one truly new paradigm; give
  it a week.
- **`,a` live-greps the project** (ripgrep behind Telescope), `,*` greps
  the word under the cursor. In any Telescope picker, `<C-q>` sends the
  results to the quickfix list — that plus `:cdo s/old/new/g | update`
  replaces the vim-enmasse workflow.
- **gitsigns**: changed lines are marked in the sign column. `]c`/`[c`
  hop between hunks, `,hs` stages a hunk, `,hr` reverts it, `,hp`
  previews it. Fugitive still owns commits and log.
- **`:terminal`** — a real terminal in a buffer. The escape hatch is
  `<C-\><C-n>` (back to normal mode); `i` re-enters. This replaces the
  dropped `,c*` cargo-dispatch maps: split, `:term cargo test`, done.
- **Format-on-save is opt-in per filetype now** (conform.nvim): lua,
  python, sh, toml, c/cpp get formatted; everything else is left alone —
  no more "why did saving mangle this file". `,.q` formats on demand.

## Gaps — dropped without direct replacement

| Gone | If you miss it |
|---|---|
| `w!!` sudo-write | broken by design in nvim; use `sudoedit file` from the shell |
| vimwiki | `~/obsidian/notes` edits fine as plain markdown; `obsidian.nvim` if links/dailies are missed |
| Tabular `,a=` etc. | `,a` is live-grep now; add `mini.align` if alignment is missed |
| vim-enmasse | Telescope `<C-q>` → editable quickfix via `:cdo` (or add `quicker.nvim`) |
| `,c*` cargo maps | `:term cargo build` etc.; add `overseer.nvim` for fancier task running |
| UltiSnips | intentionally none; blink.cmp supports snippets if wanted later |
| `:Vifm` | vifm still on the shell (`vicmd` is nvim now); in-editor browsing = neo-tree/oil |

## Things to check on first interactive run

1. **Colors**: start `nvim` inside a *new* tmux session (tmux.conf gained
   truecolor overrides — old sessions don't have them). Expect solarized
   with your terminal's transparent background. Washed out? `:echo &termguicolors`
   should be 1; check the tmux lines `terminal-features ",*-256color:RGB"`.
2. **Shift-F5/F6**: in insert mode press `<C-v><S-F5>` — if it prints
   `<F17>`, you're covered (both are mapped). If it prints something
   else, add that keycode in `keymaps.lua`.
3. **Clipboard**: yank a line, paste in Windows; copy in Windows, `p` in
   nvim. Goes through WSLg's `wl-copy` (verified working headless).

## Troubleshooting

- `:checkhealth` — start here. Known cosmetic noise at current pins:
  nvim-treesitter health says the parser dir is "not in runtimepath"
  (trailing-slash comparison bug — parsers demonstrably load, ignore it).
- `:LspInfo` (`:checkhealth vim.lsp`) — which servers attached and why.
- `:Lazy log` — what plugin updates pulled in.
- `:ConformInfo` — which formatter a buffer would use.
- **Saving a lua file reformats it**: stylua runs on write (`format.lua`),
  pinned by `nvim/.stylua.toml` to 4-wide space indent, 120 columns and
  double quotes (`AutoPreferDouble`, stylua's own default). Without that
  file stylua would also convert the indentation to tabs — ~990 lines.
  Hand-aligned comment columns and compact multi-item lists carry
  `-- stylua: ignore` markers, so **their quoting is not maintained by
  stylua** — match the surrounding double quotes yourself when editing
  those blocks. `stylua --check --search-parent-directories nvim/` should
  report nothing to change.
- LSP log: `~/.local/state/nvim/lsp.log`.
- nvim-treesitter is **pinned** to the last Neovim-0.11-compatible commit
  (`90cd6580`). When neovim ≥ 0.12 lands in apt: remove the `commit` pin
  in `plugins/treesitter.lua` and `:Lazy sync`.

## Growing the config

New language, the checklist (see `plugins/lsp.lua` for gating patterns):

1. Server: add to `servers` + `mason_tools` in `plugins/lsp.lua`.
2. Formatter: add to `formatters_by_ft` in `plugins/format.lua`.
3. Parser: add to `lua/treesitter-parsers.lua`, run `:TSInstall <lang>`.

New plugin: drop a file in `nvim/lua/plugins/` returning a lazy spec —
`{ 'author/name', opts = {} }` is the minimal form; add `keys`/`ft`/`cmd`
to lazy-load. `:Lazy sync` and commit the lockfile change.
