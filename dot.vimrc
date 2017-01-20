" Vundle
set nocompatible
filetype off

let g:vundle_default_git_proto = 'git'
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Bundles
Plugin 'VundleVim/Vundle.vim'
Plugin 'jlanzarotta/bufexplorer'
Plugin 'altercation/vim-colors-solarized'
Plugin 'kien/ctrlp.vim'
Bundle 'bling/vim-airline'
Plugin 'neochrome/todo.vim' " Todo manage
Plugin 'hallison/vim-markdown' " Markdown syntax highlighting
Plugin 'tpope/vim-fugitive'
Plugin 'scrooloose/syntastic'

" Check out these bundles
" Bundle 'sjl/gundo.vim' - undo visualisation
" Bundle 'godlygeek/tabular' - lining up text
" Bundle 'benmills/vimux' - tmux integration
" Bundle 'scrooloose/nerdtree' - file tree
" Bundle 'TomNomNom/xoria256.vim' - another colorscheme
" Bundle 'tomasr/molokai' - another colorscheme
" Bundle 'rking/ag.vim' - silver searcher plugin
" Bundle 'jpalardy/vim-slime' - screen/tmux integration
" Bundle 'justinmk/vim-sneak' - adds a search motion similar to f/t

call vundle#end()

" Filetype on
filetype plugin indent on
" Highlighting
syntax on
" Use light for gvim, dark for terminal
if has('gui_running')
    set background=light
    set guioptions-=T
else
    set t_Co=256
    set background=dark
endif
colorscheme solarized

set encoding=utf-8
" Always show statusline (powerline)
set laststatus=2

" TAB behaviour - always use spaces, 4 chars
set ts=4
set shiftwidth=4
set expandtab
set shiftround
" Make tabs show visibly
set list
set listchars=tab:\|.
" Display line numbers
set number
" Search behaviour
set ignorecase
set smartcase
set incsearch
set hlsearch
" No linewrapping
set nowrap
" Display lines wrapped though
set linebreak
set showbreak=}
" auto indent where possible
set autoindent
" make backspace work naturally in insert mode
set backspace=indent,eol,start

" set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ["eslint"]
let g:syntastic_php_checkers = ["phpcs","phpmd"]
let g:syntastic_php_phpcs_args="--report=csv --standard=/home/cameigh/PHPCS-PEAR.xml"
let g:syntastic_php_phpmd_post_args="cleancode,codesize,naming,unusedcode"
let g:syntastic_aggregate_errors=1
let g:syntastic_id_checkers=1
let g:syntastic_html_tidy_exec= 'tidy'
let g:syntastic_html_checkers = ["tidy"]

let g:airline_powerline_fonts = 1
if has('gui_running')
    set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 10
endif
set noshowmode


function! GitWindow()
    let dir = fugitive#extract_git_dir(expand('%:p'))
    if dir !=# ''
        execute 'Gstatus'
    endif
endfun

" 'wild' menu for tab completion in vim command mode
set wildmenu

" Re-read vimrc if it is written
autocmd! BufWritePost .vimrc nested :source $MYVIMRC

" CTRL-L un-highlights a search result without changing the search buffer
if maparg('<C-L>', 'n') ==# ''
    nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

" I like 'displayed' non-text (line endings for instance) to have a different
" background
highlight NonText term=bold cterm=bold ctermfg=11 gui=bold guifg=Blue ctermbg=16


