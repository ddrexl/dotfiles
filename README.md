# A set of dotfiles for vim, tmux, git and zsh

## Install

Clone the repository.
```bash
git clone https://github.com/ddrexl/dotfiles.git
```

Run the install script.
```bash
cd dotfiles # enter the repo dir
./install.bash
```

Select the things you want, separated by commas or whitespace.

## Your private configuration

The following files are reserved for your private local configuration:
 - `~/.vimrc.local`
 - `~/.gitconfig`

They won't be overwritten if they exist.

## Vim Cheatsheet

### Key Mappings

I try to avoid conflicts with vanilla vim as much as possible.
`,` is my `<Leader>`.

| **fuzzy find** |                         | **traverse**           | `[`: previous , `]`: next
| -              | -                       | -                      | -
| `,b`           | buffers                 | `]b`                   | buffer
| `,f`           | files                   | `]f`                   | file (of same directory)
| `,r`           | recent files            | `]a`                   | arglist
| `,t`           | tags                    | `]t`                   | tags
| `,u`           | undo history            | `]q`                   | quickfix list
| `<c-j>`        | move selection down     | `]l`                   | location list
| `<c-k>`        | move selection up       | `]n`                   | conflict marker
| `<c-n>`        | prompt history next     | **indentation object** |
| `<c-p>`        | prompt history previous | `ii`                   | inner indentation
| `<c-z>`        | mark a file             | `ai`                   | an indentation and line above
| `<F5>`         | refresh match window    | `aI`                   | an indentation and lines above/below
| `<F7>`         | wipe list/delete bufs   | **argument object**    |
| **git**        |                         | `ia`                   | inner argument
| `,gw  `        | add (write)             | `aa`                   | an argument
| `,gr  `        | checkout (read)         | **alignment**          |
| `,gl  `        | log                     | `,a<d>`                | see below for `<d>`
| `,gb  `        | blame                   | **completion**         |
| `,gc  `        | commit                  | `,d`                   | show detailed diagnostic
| `,gd  `        | diff                    | `,.r`                  | go to references
| `,gs  `        | status                  | `,.f`                  | fix it
| **vimwiki**    |                         | `,.g`                  | GoTo
| `,ww`          | open wiki index         | **easy motion**        |
| `,ws`          | select wiki             | `sw`                   | jump forward words
| `,whh`         | show in browser         | `sb`                   | jump backwards words
| `,wh`          | convert to html         | `sf`                   | jump forward character
| `,wr`          | rename link             | **misc**               |
| `,wd`          | delete link             | `<c-n>`                | toggle file tree
| `,w,w`         | make diary note         | `,tt  `                | toggle tagbar
| `,wi`          | diary index             | `,q   `                | open quickfix list
| `,w,i`         | diary generate links    | `,cq  `                | clear quickfix list
| **modify case**|                         | `,/   `                | clear  search highlight
| `cr<x>`        | see below for `<x>`     |                        |

#### Alignment

`,a<delim>` where _<delim>_ is one of `| , ,, : => = &`

#### Modify Case
`cr` followed by one of these characters modifies the word under the cursor, see `:h cr`

| char       | change to       | char      | change to  irreversible
| -          | -               | -         | -
| `c`        | camelCase       | `-      ` | dash-case
| `m`        | MixedCase       | `.      ` | dot.case
| `s` or `_` | snake_case      | `<space>` | space case
| `u` or `U` | SNAKE_UPPERCASE | `t      ` | Title Case


###  Snippets

| cpp    | |
| -      | -
| once   | include guard
| ns     | namespace
| cl     | class
| cl6    | class (rule of 6)
| in     | interface
| hdr    | cpp header
| cpp    | cpp source
| vfun   | virtual function
| vfund  | virtual function declaration
| for    | for loop (auto&)
| forc   | for loop (const auto&)
| assert | gmock ASSERT_THAT
| test   | gtest TEST
| testf  | gtest TEST_F
| tests  | gtest suite

bazel | |
-     | -
ccb   | cc_binary
ccl   | cc_library
cct   | cc_test


## Feedback

Feel free to leave your [suggestions/improvements](https://github.com/ddrexl/dotfiles/issues)!

## Thanks to…

* [Mathias Bynens](https://mathiasbynens.be/); his [dotfiles repository](https://github.com/mathiasbynens/dotfiles) was my starting point
* [Tim Pope](https://tpo.pe/) for a ton of awesome vim plugins!!

