" Modeline and Notes {
" vim: set sw=4 ts=4 sts=4 et tw=78 fmr={,} fdl=0 fdm=marker spell:
"
"   Everything is free for you to use.
"   If you just want to customize a few things, I recommend putting it in
"   ~/.vimrc.local
"   If you want to pick something out, make sure you understand what you do.
" }

" Environment {
    set nocompatible    " Must be first line
    filetype off
    set shell=/bin/bash
" }

" Functions {
    scriptencoding utf-8

    " StripTrailingWhitespace {
        function! StripTrailingWhitespace()
            if exists('b:noStripTrailingWhitespace')
                return
            endif

            " save last search, and cursor position.
            let _s=@/
            let l = line(".")
            let c = col(".")

            " strip whitespace
            %s/\s\+$//e

            " restore last search, and cursor position
            let @/=_s
            call cursor(l, c)
        endfunction
    " }

    " VisualSearch {
        " Search visual selection with * and #
        function! VisualSearch(direction) range
            let l:saved_reg = @"
            execute "normal! vgvy"

            let l:pattern = escape(@", '\\/.*$^~[]')
            let l:pattern = substitute(l:pattern, "\n$", "", "")

            if a:direction == 'f'
                execute "normal /" . l:pattern . "^M"
            elseif a:direction == 'b'
                execute "normal ?" . l:pattern . "^M"
            endif

            let @/ = l:pattern
            let @" = l:saved_reg
        endfunction

        vnoremap <silent> * :call VisualSearch('f')<CR>
        vnoremap <silent> # :call VisualSearch('b')<CR>
    " }

    " InstallVimPlugOnce {
        function! s:InstallVimPlugOnce()
            if empty(glob("~/.vim/autoload/plug.vim"))
                echo "Installing plug.vim..\n"
                silent execute "!mkdir -p ~/.vim/plugged"
                silent execute "!curl -fLo ~/.vim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim --create-dirs"
            endif
        endfunction
    " }

    " InstallPowerlineSymbolsOnce {
        function! s:InstallPowerlineSymbolsOnce()
            let l:font_dir = "~/.local/share/fonts/"
            let l:url = "https://github.com/powerline/powerline/raw/develop/font/"

            if empty(glob(l:font_dir . "PowerlineSymbols.otf"))
                echo "Installing powerline symbols..\n"
                silent execute "!curl -fLo    " . l:font_dir . "PowerlineSymbols.otf " . l:url . "PowerlineSymbols.otf --create-dirs"
                silent execute "!fc-cache -vf " . l:font_dir
                silent execute "!curl -fLo ~/.config/fontconfig/conf.d/10-powerline-symbols.conf " . l:url . "10-powerline-symbols.conf --create-dirs"
            endif
        endfunction
    " }
" }

" Plugins {
    " First Time Only Installs {
        call s:InstallVimPlugOnce()
        call s:InstallPowerlineSymbolsOnce()
    " }

    if filereadable(expand("~/.vim/autoload/plug.vim"))
        call plug#begin('~/.vim/plugged')

        Plug 'Olical/vim-enmasse'               " Virtual quickfix list file!
        Plug 'altercation/vim-colors-solarized' " Colorscheme
        Plug 'christoomey/vim-tmux-navigator'   " Seamless vim and tmux split navigation
        Plug 'ctrlpvim/ctrlp.vim'               " Fuzzy file opener
        Plug 'easymotion/vim-easymotion'        " Speed of light motion
        Plug 'godlygeek/tabular'                " Text alignment
        Plug 'vim-autoformat/vim-autoformat'    " Auto formatting
        Plug 'michaeljsmith/vim-indent-object'  " Indent object
        Plug 'scrooloose/nerdtree'              " File browser sidebar
        Plug 'sirver/ultisnips' | Plug 'honza/vim-snippets' " Code snippets
        Plug 'tpope/vim-abolish'                " Search, substitute and coerce declinations
        Plug 'tpope/vim-commentary'             " Code commenting
        Plug 'tpope/vim-fugitive'               " Git in Vim!!
        Plug 'tpope/vim-repeat'                 " Repeatable tpope commands
        Plug 'tpope/vim-surround'               " Parenthesis commands
        Plug 'tpope/vim-unimpaired'             " Pairs of handy bracket mappings
        Plug 'prabirshrestha/vim-lsp' | Plug 'mattn/vim-lsp-settings'                       " Language server
        Plug 'prabirshrestha/asyncomplete.vim' | Plug 'prabirshrestha/asyncomplete-lsp.vim' " Auto-completion
        Plug 'vim-airline/vim-airline'          " Statusline
        Plug 'vim-airline/vim-airline-themes'   " Solarized theme for airline
        Plug 'andymass/vim-matchup'             " Improve % operation
        Plug 'vimwiki/vimwiki'                  " Notes and todo lists in vim
        Plug 'wellle/targets.vim'               " Various text objects
        Plug 'tpope/vim-dispatch', {'for': 'rust'}    " Async cargo commands for rust
        Plug 'cespare/vim-toml', { 'branch': 'main' } " Included in Vim 8.2.3519

        call plug#end()

    endif
" }

" General {
    filetype plugin indent on       " Automatically detect file types.
    syntax enable                   " Syntax highlighting

    highlight clear SignColumn      " SignColumn should match background
    highlight clear LineNr          " Current line number row will have same background color in relative mode

    set autoread                    " Refresh buffers automatically
    set backspace=indent,eol,start  " Allow backspace in insert mode
    set cursorline                  " Highlight current line
    set display+=lastline           " No legacy vi display
    set encoding=utf-8              " Use UTF-8, required for YCM
    set foldenable                  " Auto fold code
    set foldlevel=99                " Don't fold by default
    set hidden                      " Allow buffer switching without saving
    set history=1000                " Store a ton of history (default is 20)
    set hlsearch                    " Highlight search terms
    set ignorecase                  " Case insensitive search
    set incsearch                   " Find as you type search
    set iskeyword-=#                " '#' is an end of word designator
    set iskeyword-=-                " '-' is an end of word designator
    set iskeyword-=.                " '.' is an end of word designator
    set laststatus=2                " Last window always has a statusline
    set linespace=0                 " No extra spaces between rows
    set list                        " Show “invisible” characters
    set listchars=tab:▸\ ,trail:•,extends:>,precedes:<,nbsp:.
    set mouse=a                     " Enable mouse in all modes
    set nobackup                    " Dont create backup files
    set noerrorbells                " Disable error bells
    set nospell                     " Spell checking off
    set noswapfile                  " Dont create swap files
    set nrformats-=octal            " Dont increment octals
    set number                      " Show line numbers
    set scrolljump=5                " Lines to scroll when cursor leaves screen
    set scrolloff=1                 " Minimum lines to keep above and below cursor
    set sessionoptions-=options     " Dont save everything of the session
    set shortmess+=filmnrxoOtTIc    " Abbrev. of messages (avoids 'hit enter')
    set showmatch                   " Show matching brackets/parenthesis
    set smartcase                   " Case sensitive when search contains upper case
    set smarttab                    " Tab handles whitespace correctly
    set title                       " Show the filename in the window titlebar
    set ttyfast                     " Optimize for fast terminal connections
    set virtualedit=onemore         " Allow for cursor beyond last character
    set whichwrap=b,s,<,>,[,]       " Cursor keys wrap too
    set wildmenu                    " Show list instead of just completing
    set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
    set winminheight=0              " Allow windows to be squashed to just a status bar

    " Conditional Settings {
        if has("clipboard")
            set clipboard=unnamed,unnamedplus " Connect clipboard registers * and + to default register
        else
            echoerr "Your vim has no clipboard support!"
        endif

        if has("mksession")
            set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
        endif

        if v:version > 703 || v:version == 703 && has("patch541")
          set formatoptions+=j          " Delete comment character when joining commented lines
        endif

        if has("patch-8.1-1365")
            set modeline
            set modelineexpr
        else
            set nomodeline              " security issue without this patch
            set nomodelineexpr
        endif

        if has('path_extra')
          setglobal tags^=./.git/tags;
        endif

        if !empty(&viminfo)
          set viminfo^=!
        endif

        if has('persistent_undo')
            set undodir=~/.vim/undo     " Centralized undo
            set undofile                " Persistent undo
            set undolevels=1000         " Maximum number of changes that can be undone
            set undoreload=10000        " Maximum number lines to save for undo on a buffer reload

            silent execute "!mkdir -p " . &undodir
        endif

        " check if better grep alternatives are available
        if executable('rg')
            " search hidden files too
            set grepprg=rg\ -uu\ --color=never\ --vimgrep\ --no-heading
            set grepformat=%f:%l:%c:%m,%f:%l:%m
        elseif executable('ag')
            set grepprg=ag\ --vimgrep\ --smart-case\ $*
            set grepformat=%f:%l:%c:%m
        endif
    " }

    augroup git_commit
        " Instead of reverting the cursor to the last position in the buffer, we
        " set it to the first line when editing a git commit message
        autocmd!
        autocmd FileType gitcommit autocmd! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])
    augroup END

    augroup remap_filetypes
        autocmd!
        autocmd BufNewFile,BufRead *.atom,*.launch,*.rss setfiletype xml
    augroup END
" }

" Colorscheme Solarized {
    set background=dark

    if filereadable(expand("~/.vim/plugged/vim-colors-solarized/colors/solarized.vim"))
        let g:solarized_termcolors=16
        let g:solarized_termtrans=1
        let g:solarized_contrast="normal"
        let g:solarized_visibility="normal"
        colorscheme solarized
    endif

    " colors for vimdiff
    highlight DiffText cterm=none ctermfg=White ctermbg=Red gui=none guifg=White guibg=Red
" }

" Formatting {
    set nowrap                      " Do not wrap long lines
    set autoindent                  " Indent at the same level of the previous line
    set shiftwidth=4                " Use indents of 4 spaces
    set expandtab                   " Tabs are spaces, not tabs
    set tabstop=4                   " An indentation every four columns
    set softtabstop=4               " Let backspace delete indent
    set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
    set splitright                  " Puts new vsplit windows to the right of the current
    set splitbelow                  " Puts new split windows to the bottom of the current
    set matchpairs+=<:>             " Match, to be used with %
    set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)
    set fileformat=unix             " <NL> line endings

    " Remove trailing whitespaces and ^M chars
    augroup strip_whitespace
        autocmd!
        autocmd FileType c,cpp,python,xml,yml autocmd BufWritePre <buffer> call StripTrailingWhitespace()
        autocmd FileType markdown let b:noStripTrailingWhitespace=1
    augroup END

    " Cargo.toml
    augroup cargo_toml_formatting
        autocmd!
        if executable('taplo')
            autocmd BufRead,BufNewFile Cargo.toml autocmd BufWritePost <buffer> silent execute "!taplo lint -S Cargo.toml"
        endif
    augroup END

    augroup special_tabs
        autocmd!
        autocmd FileType cmake,yaml setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
        autocmd FileType make setlocal tabstop=8 softtabstop=8 shiftwidth=8 noexpandtab
    augroup END

    let python_highlight_all = 1
" }

" Key Mappings {
    " the default leader is '\', but I prefer ','
    let mapleader = ','
    let maplocalleader = '_'

    " F keys
    noremap <F2> :w<CR>
    noremap <F3> :close<CR>
    noremap <F4> :bd<CR>
    noremap <F5> :bp<CR>
    noremap <F6> :bn<CR>
    noremap <S-F5> :cp<CR>
    noremap <S-F6> :cn<CR>

    " tags
    noremap <F7> <C-T>
    noremap <F8> <C-]>
    noremap <C-F8> <C-W><C-]>

    " window movement
    nnoremap <C-H> <C-W><C-H>
    nnoremap <C-L> <C-W><C-L>
    nnoremap <C-J> <C-W><C-J>
    nnoremap <C-K> <C-W><C-K>

    " Wrapped lines goes down/up to next row, rather than next line in file.
    noremap j gj
    noremap k gk

    " tab movement
    noremap <S-H> :tabprevious<CR>
    noremap <S-L> :tabnext<CR>

    " Yank from the cursor to the end of the line, to be consistent with C and D.
    nnoremap Y y$

    " Folding with the spacebar
    nnoremap <space> za

    " toggle search highlighting
    nmap <silent> <leader>/ :nohlsearch<CR>

    " Shortcuts
    " Change Working Directory to that of the current file
    cmap cwd lcd %:p:h
    cmap cd. lcd %:p:h

    " Visual shifting (does not exit Visual mode)
    vnoremap < <gv
    vnoremap > >gv

    " Allow using the repeat operator with a visual selection (!)
    " http://stackoverflow.com/a/8064607/127816
    vnoremap . :normal .<CR>

    " For when you forget to sudo.. Really Write the file.
    cmap w!! w !sudo tee % >/dev/null

    " Adjust viewports to the same size
    nnoremap <Leader>= <C-w>=

    " Easier horizontal scrolling
    nnoremap zl zL
    nnoremap zh zH

    " Open  quickfix window
    nnoremap <silent> <leader>q :copen<CR>
    " Clear  quickfix window
    nnoremap <silent> <leader>cq :cexpr []<CR>
" }

" Plugin Settings/Mappings {
    " Commentary {
        if isdirectory(expand("~/.vim/plugged/vim-commentary"))
            augroup comment_string
                autocmd!
                autocmd FileType c,cpp,cs,java setlocal commentstring=//\ %s
            augroup END
        endif
    " }

    " NerdTree {
        if isdirectory(expand("~/.vim/plugged/nerdtree"))
            nnoremap <silent> <C-n> :NERDTreeToggle<CR>
            nmap <leader>n :NERDTreeFind<CR>

            let NERDTreeShowBookmarks=1
            let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
            let NERDTreeChDirMode=0
            let NERDTreeQuitOnOpen=1
            let NERDTreeMouseMode=2
            let NERDTreeShowHidden=1
            let g:NERDTreeWinSize=60
        endif
    " }

    " Tabularize {
        if isdirectory(expand("~/.vim/plugged/tabular"))
            nmap <Leader>a& :Tabularize /&<CR>
            vmap <Leader>a& :Tabularize /&<CR>
            nmap <Leader>a= :Tabularize /^[^=]*\zs=<CR>
            vmap <Leader>a= :Tabularize /^[^=]*\zs=<CR>
            nmap <Leader>a=> :Tabularize /=><CR>
            vmap <Leader>a=> :Tabularize /=><CR>
            nmap <Leader>a: :Tabularize /:<CR>
            vmap <Leader>a: :Tabularize /:<CR>
            nmap <Leader>a:: :Tabularize /:\zs<CR>
            vmap <Leader>a:: :Tabularize /:\zs<CR>
            nmap <Leader>a, :Tabularize /,<CR>
            vmap <Leader>a, :Tabularize /,<CR>
            nmap <Leader>a,, :Tabularize /,\zs<CR>
            vmap <Leader>a,, :Tabularize /,\zs<CR>
            nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
            vmap <Leader>a<Bar> :Tabularize /<Bar><CR>
        endif
    " }

    " Easy Motion {
        if isdirectory(expand("~/.vim/plugged/vim-easymotion"))
            map s <Plug>(easymotion-prefix)
        endif
    " }

    " CtrlP {
        if isdirectory(expand("~/.vim/plugged/ctrlp.vim/"))
            let g:ctrlp_working_path_mode = 'ra'
            nnoremap <leader>f :CtrlP<CR>
            nnoremap <leader>b :CtrlPBuffer<CR>
            nnoremap <leader>t :CtrlPTag<CR>
            nnoremap <leader>r :CtrlPMRU<CR>
            nnoremap <leader>u :CtrlPUndo<CR>

            let g:ctrlp_custom_ignore = {
                \ 'dir':  '\.git$\|\.hg$\|\.svn$',
                \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$' }

            if executable('rg')
                let g:ctrlp_user_command = 'rg %s --color=never --files --glob ""'
                let g:ctrlp_use_caching = 0
            elseif executable('ag')
                let g:ctrlp_user_command = 'ag %s --nocolor -l -g ""'
                let g:ctrlp_use_caching = 0
            else
                let s:ctrlp_fallback = 'find %s -type f'
                let g:ctrlp_user_command = {
                    \ 'types': {
                        \ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
                        \ 2: ['.hg', 'hg --cwd %s locate -I .'],
                    \ },
                    \ 'fallback': s:ctrlp_fallback
                \ }
            endif
        endif
    "}

    " TagBar {
        if isdirectory(expand("~/.vim/plugged/tagbar/"))
            nnoremap <silent> <leader>tt :TagbarToggle<CR>
            let g:tagbar_autofocus = 1
        endif
    "}

    " Vim LSP {
        if isdirectory(expand("~/.vim/plugged/vim-lsp/"))
            let g:lsp_diagnostics_enabled = 1
            let g:lsp_diagnostics_signs_enabled = 1
            let g:lsp_diagnostics_echo_cursor = 1
            let g:lsp_diagnostics_float_cursor = 0
            let g:lsp_diagnostics_signs_error = {'text': '✗'}
            let g:lsp_diagnostics_signs_warning = {'text': '‼'}
            let g:lsp_diagnostics_signs_insert_mode_enabled = 0
            let g:lsp_hover_conceal = 0 " disable in terminal
            let g:lsp_semantic_enabled = 1

            function! s:on_lsp_buffer_enabled() abort
                setlocal omnifunc=lsp#complete
                setlocal signcolumn=number
                if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
                nmap <buffer> gd <Plug>(lsp-definition)
                nmap <buffer> gs <Plug>(lsp-document-symbol-search)
                nmap <buffer> gS <Plug>(lsp-workspace-symbol-search)
                nmap <buffer> gr <Plug>(lsp-references)
                nmap <buffer> gi <Plug>(lsp-implementation)
                nmap <buffer> gt <Plug>(lsp-type-definition)
                nmap <buffer> <leader>m <Plug>(lsp-rename)
                nmap <silent> <buffer> [g <Plug>(lsp-previous-diagnostic)
                nmap <silent> <buffer> ]g <Plug>(lsp-next-diagnostic)
                nmap <buffer> K <Plug>(lsp-hover)
                nmap <buffer> <leader>d <Plug>(lsp-code-action)
                vmap <buffer> <leader>d :LspCodeAction<CR>
                " vmap <buffer> <leader>d <Plug>(lsp-code-action)
                nmap <buffer> <leader>.q <Plug>(lsp-document-format)

                " autoformating currently done with vim-codefmt, see below
                " let g:lsp_format_sync_timeout = 1000
                " autocmd! BufWritePre *.rs,*.py call execute('LspDocumentFormatSync')
            endfunction

            augroup lsp_install
                au!
                " call s:on_lsp_buffer_enabled only for languages that has the server registered.
                autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
            augroup END
        endif
    " }

    " Asyncomplete {
        if isdirectory(expand("~/.vim/plugged/asyncomplete.vim/"))
            inoremap <silent><expr> <TAB>
              \ pumvisible() ? "\<C-n>" :
              \ <SID>check_back_space() ? "\<TAB>" :
              \ asyncomplete#force_refresh()
            inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
            inoremap <expr> <CR>    pumvisible() ? asyncomplete#close_popup() : "\<CR>"

            function! s:check_back_space() abort
                let col = col('.') - 1
                return !col || getline('.')[col - 1]  =~ '\s'
            endfunction

            " remap Ultisnips to not use tab
            let g:UltiSnipsExpandTrigger = '<C-j>'
            let g:UltiSnipsJumpForwardTrigger = '<C-j>'
            let g:UltiSnipsJumpBackwardTrigger = '<C-k>'

            let g:asyncomplete_auto_popup = 1

            " enable preview window
            " let g:asyncomplete_auto_completeopt = 0
            " set completeopt=menuone,noinsert,noselect,preview
        endif
    " }

    " Airline {
        " Set configuration options for the statusline plugin vim-airline.
        " Use the symbols , , , , , , and .in the statusline
        " If the previous symbols do not render for you then install a
        " powerline enabled font.

        " See `:echo g:airline_theme_map` for some more choices
        if isdirectory(expand("~/.vim/plugged/vim-airline-themes/"))
            let g:airline_theme = 'solarized'
            let g:airline_powerline_fonts = 1
        endif

        if isdirectory(expand("~/.vim/plugged/vim-airline-themes/"))
            let g:airline#extensions#ycm#enabled = 1
            let g:airline#extensions#ycm#error_symbol = 'E:'
            let g:airline#extensions#ycm#warning_symbol = 'W:'
        endif

    " }

    " UltiSnips {
        if isdirectory(expand("~/.vim/plugged/ultisnips/"))
            let g:snips_author = 'Dominik Drexl'
        endif
    " }

    " Vimwiki {
        if isdirectory(expand("~/.vim/plugged/vimwiki/"))
            let g:vimwiki_listsyms = ' .oO✓'
            let g:vimwiki_folding = 'expr'
        endif
    " }

    " Autoformat {
        if isdirectory(expand("~/.vim/plugged/vim-autoformat/"))

            let g:autoformat_autoindent = 0
            let g:autoformat_retab = 0
            let g:autoformat_remove_trailing_spaces = 0 " todo enable, but solve markdown issue
            let g:autoformat_verbosemode=0

            augroup autoformat_settings
              autocmd BufWrite * :Autoformat
            augroup END

        endif
    " }

    " Vim-Dispatch {
        if isdirectory(expand("~/.vim/plugged/vim-dispatch/"))
            augroup vim_dispatch_rust
              autocmd BufRead,BufNewFile Cargo.toml,Cargo.lock,*.rs compiler cargo
              autocmd BufRead,BufNewFile Cargo.toml,Cargo.lock,*.rs setlocal makeprg=cargo
              autocmd FileType rust nnoremap <leader>cb :Dispatch cargo build<CR>
              autocmd FileType rust nnoremap <leader>cc :Dispatch cargo check<CR>
              autocmd FileType rust nnoremap <leader>cr :terminal cargo run<CR>
              autocmd FileType rust nnoremap <leader>ct :Dispatch cargo test<CR>
              autocmd FileType rust nnoremap <leader>cd :Dispatch cargo doc --open<CR>
            augroup END
        endif
    " }

    " Fugitive {
        if isdirectory(expand("~/.vim/plugged/vim-fugitive/"))
            nnoremap <silent> <leader>gs :Git<CR>
            nnoremap <silent> <leader>gd :Gvdiffsplit<CR>
            nnoremap <silent> <leader>gc :Git commit<CR>
            nnoremap <silent> <leader>gb :Git blame<CR>
            nnoremap <silent> <leader>gl :Git --paginate log --graph --pretty=format:'%h %d %s <%an> [%ad]' --abbrev-commit --date=relative -30<CR>
            "nnoremap <silent> <leader>gp :Git push<CR>
            nnoremap <silent> <leader>gr :Gread<CR>
            nnoremap <silent> <leader>gw :Gwrite<CR>
            nnoremap <silent> <leader>ge :Gedit<CR>

            augroup fugitive_buffers
                autocmd!
                autocmd BufReadPost fugitive://* set bufhidden=delete
            augroup END

            " this matches the <leader>gl mapping above
            function s:git_log_syntax()
                syn match gitLgLine     /^[_\*|\/\\ ]\+\(\<\x\{4,40\}\>.*\)\?$/
                syn match gitLgGraph    /^[_\*|\/\\ ]\+/ contained containedin=gitLgLine nextgroup=gitHashAbbrev skipwhite
                syn match gitLgDate     /\[.*\]/ contained containedin=gitLgLine
                syn match gitLgRefs     /(.*)/ contained containedin=gitLgLine
                syn match gitLgCommit   /^[^-]\+- / contained containedin=gitLgLine nextgroup=gitLgIdentity skipwhite
                syn match gitLgIdentity /<.*>/ contained containedin=gitLgLine
                hi def link gitLgGraph    Comment
                hi def link gitLgDate     gitDate
                hi def link gitLgRefs     gitReference
                hi def link gitLgIdentity gitIdentity
            endfunction

            augroup git_log_syntax
                autocmd!
                autocmd Syntax git call s:git_log_syntax()
            augroup end

        endif
    "}
" }

" GVim Settings {
    if has('gui_running')
        set guifont=Ubuntu\ Mono\ 12
        set linespace=8             " Better line-height
        set guioptions-=T           " Remove the toolbar
        set lines=40                " 40 lines of text instead of 24
    endif
" }

" Source local vimrc if available {
    if filereadable(expand("~/.vimrc.local"))
        source ~/.vimrc.local
    endif
" }
