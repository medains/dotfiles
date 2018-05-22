" Plugin Management
" -----------------
set nocompatible
filetype off

let g:vundle_default_git_proto = 'git'
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Vundle manages itself
Plugin 'VundleVim/Vundle.vim'

" Buffers, File management
Plugin 'jlanzarotta/bufexplorer'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'FelikZ/ctrlp-py-matcher'
Plugin 'bogado/file-line'

" Syntax and colours
Plugin 'altercation/vim-colors-solarized'
"Plugin 'cakebaker/scss-syntax.vim' " SCSS/SASS
"Plugin 'groenewege/vim-less'       " LESS

" Linting
Plugin 'w0rp/ale'
" Plugin 'scrooloose/syntastic'  " Use this prior to vim 8

" Status line
Plugin 'bling/vim-airline'

" git helper
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'

" Autocompletion
Plugin 'ervandew/supertab'          " Allow tabs for autocomplete and insert of tab
Plugin 'shawncplus/phpcomplete.vim' " PHP autocompletion
Plugin 'SirVer/ultisnips'           " Snippet engine
Plugin 'honza/vim-snippets'         " Standard snippets

" Misc functions
Plugin 'godlygeek/tabular'  " lining up text
Plugin 'neochrome/todo.vim' " Todo manage
Plugin 'sjl/gundo.vim' " undo visualisation
Plugin 'plasticboy/vim-markdown'     " Markdown syntax highlighting and other details

" Apply per-repo editor config
Plugin 'editorconfig/editorconfig-vim'

" Trying stuff out
Plugin 'lukaszkorecki/workflowish'  " Workflowy-like todo list

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
" Always show statusline (airline)
set laststatus=2

" TAB behaviour - always use spaces, 4 chars
set tabstop=4
set softtabstop=4
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

let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
if has('gui_running')
    set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 10
endif
set noshowmode

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

" Always keep the w0rp/ale syntax gutter open
let g:ale_sign_column_always = 1
" Set PHPCS standard file
let g:ale_php_phpcs_standard = '~/.phpcs/rules.xml'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_linters = {'javascript': ['eslint'], 'java': ['javac'] }

" Supertab should use ctrl-x ctrl-o for completion (omnifunc)
" still falls back to the ctrl-n behaviour for non-omnifunc files
let g:SuperTabDefaultCompletionType = "<c-x><c-o>"

" Set omnifunc for php files
autocmd FileType php setlocal omnifunc=phpcomplete#CompletePHP

set completeopt=longest,menuone

" Snippet configuration
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<c-b>"
let g:UltiSnipsRemoveSelectModeMappings = 0
let g:UltiSnipsListSnippets="<s-tab>"

" Gundo configuration
let g:gundo_close_on_revert=1
nnoremap <F5> :GundoToggle<CR>

" Ctrl matcher
let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
let g:ctrlp_user_command = 'ag %s --ignore-case --hidden --nocolor --nogroup
    \ --ignore ".git/"
    \ --ignore "build/"
    \ --ignore "node_modules"
    \ -g ""'
let g:ctrlp_lazy_update=100

" YAML tabstop smaller
autocmd Filetype yaml setlocal ts=2 sts=2 sw=2

" Vimflowy setup commands
autocmd BufWinLeave *.wofl mkview
autocmd BufWinEnter *.wofl silent loadview

" syntax based text hiding
set conceallevel=2

" turn off folding in markdown, it's annoying
let g:vim_markdown_folding_disabled=1
