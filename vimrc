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
        Plug 'majutsushi/tagbar'                " Tags in sidebar
        Plug 'michaeljsmith/vim-indent-object'  " Indent object
        Plug 'rhysd/vim-clang-format', { 'for': 'cpp' }         " c++ formatting
        Plug 'scrooloose/nerdtree'              " File browser sidebar
        Plug 'sirver/ultisnips' | Plug 'honza/vim-snippets'     " Code snippets
        Plug 'tpope/vim-abolish'                " Search, substitute and coerce declinations
        Plug 'tpope/vim-commentary'             " Code commenting
        Plug 'tpope/vim-fugitive'               " Git in Vim!!
        Plug 'tpope/vim-repeat'                 " Repeatable tpope commands
        Plug 'tpope/vim-surround'               " Parenthesis commands
        Plug 'tpope/vim-unimpaired'             " Pairs of handy bracket mappings
        Plug 'valloric/youcompleteme'           " Code completion engine!!
        Plug 'vim-airline/vim-airline'          " Statusline
        Plug 'vim-airline/vim-airline-themes'   " Solarized theme for airline
        Plug 'vim-scripts/argtextobj.vim'       " Argument object
        Plug 'vim-scripts/matchit.zip'          " Improve % operation
        Plug 'vimwiki/vimwiki'                  " Notes and todo lists in vim

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
        else
            set nomodeline              " security issue without this patch
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
    noremap <C-H> <C-W><C-H>
    noremap <C-L> <C-W><C-L>
    noremap <C-J> <C-W><C-J>
    noremap <C-K> <C-W><C-K>

    " Wrapped lines goes down/up to next row, rather than next line in file.
    noremap j gj
    noremap k gk

    " tab movement
    noremap <S-H> gT
    noremap <S-L> gt

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
            nmap <C-n> :NERDTreeToggle<CR>
            nmap <leader>n :NERDTreeFind<CR>

            let g:NERDShutUp=1
            let NERDTreeShowBookmarks=1
            let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
            let NERDTreeChDirMode=0
            let NERDTreeQuitOnOpen=1
            let NERDTreeMouseMode=2
            let NERDTreeShowHidden=1
            let NERDTreeKeepTreeInNewTab=1
            let g:NERDTreeWinSize=60
            let g:nerdtree_tabs_open_on_gui_startup=0
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

    " Fugitive {
        if isdirectory(expand("~/.vim/plugged/vim-fugitive/"))
            nnoremap <silent> <leader>gs :Gstatus<CR>
            nnoremap <silent> <leader>gd :Gvdiff<CR>
            nnoremap <silent> <leader>gc :Gcommit<CR>
            nnoremap <silent> <leader>gb :Gblame<CR>
            nnoremap <silent> <leader>gl :Glog<CR>
            "nnoremap <silent> <leader>gp :Git push<CR>
            nnoremap <silent> <leader>gr :Gread<CR>
            nnoremap <silent> <leader>gw :Gwrite<CR>
            nnoremap <silent> <leader>ge :Gedit<CR>
            "nnoremap <silent> <leader>gg :SignifyToggle<CR> todo

            augroup fugitive_buffers
                autocmd!
                autocmd BufReadPost fugitive://* set bufhidden=delete
            augroup END
        endif
    "}

    " YouCompleteMe {
        if isdirectory(expand("~/.vim/plugged/youcompleteme/"))
            "let g:acp_enableAtStartup = 0

            " self explanatory af
            let g:ycm_collect_identifiers_from_tags_files = 1
            let g:ycm_autoclose_preview_window_after_completion = 1

            " remap Ultisnips for compatibility for YCM
            let g:ycm_use_ultisnips_completer = 1
            let g:UltiSnipsExpandTrigger = '<C-j>'
            let g:UltiSnipsJumpForwardTrigger = '<C-j>'
            let g:UltiSnipsJumpBackwardTrigger = '<C-k>'

            let g:ycm_show_diagnostics_ui = 0

            " Enable omni completion.
            augroup omni_complete
                autocmd!
                autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
                autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
                autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
                autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
            augroup END

            " python semantic completion
            let g:ycm_python_binary_path = '/usr/bin/python3'

            " c lang family completion
            let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
            let g:ycm_confirm_extra_conf = 1

            " YcmCompleter subcommand mappings
            noremap <leader>.g :YcmCompleter GoTo<CR>
            noremap <leader>.f :YcmCompleter FixIt<CR>
            noremap <leader>.r :YcmCompleter GoToReferences<CR>
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
    " }

    " Clang Format {
        if isdirectory(expand("~/.vim/plugged/vim-clang-format/"))
            let g:clang_format#detect_style_file = 1
            let g:clang_format#command = "clang-format-6.0"

            augroup clang_format
                autocmd!
                autocmd FileType cpp let g:clang_format#auto_format = 1
            augroup END
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
