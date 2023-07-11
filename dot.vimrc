" ------------------------------
" Plugin Section
" ------------------------------
" Install vim-plug if it isn't present
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

" Define plugin list
call plug#begin('~/.vim/plugged')

" Status line
Plug 'vim-airline/vim-airline'
" Linter
Plug 'dense-analysis/ale'
" Colours
Plug 'lifepillar/vim-solarized8'
" Git Helpers
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
" Markdown support
Plug 'preservim/vim-markdown'
" Pay attention to editorconfig files
Plug 'editorconfig/editorconfig-vim'
" Terraform niceties
Plug 'hashivim/vim-terraform'

" completion plugin
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Fuzzy files
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'statox/vim-compare-lines'

call plug#end()
" End of plugins section
" ------------------------------

" Deactivate backwards compatibility
set nocompatible

" Filetype plugins + indenting
filetype plugin indent on

" Activate colour scheme
set termguicolors
set background=light
autocmd vimenter * ++nested colorscheme solarized8_high

" Default to UTF-8
set encoding=utf-8
" Always show statusline (airline)
set laststatus=2

" Default TAB behaviour - always use spaces, 4 chars
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set shiftround

" Show line numbers
set number
" Make tabs show visibly
set list
set listchars=tab:\|.
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

let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tabline = 1
let g:airline_powerline_fonts = 1
set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 10
set noshowmode
" 'wild' menu for tab completion in vim command mode
set wildmenu

" Ctrl-L cancels search-highlighting
if maparg('<C-L>', 'n') ==# ''
    nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

" I like 'displayed' non-text (line endings for instance) to have a different
" background
highlight NonText term=bold cterm=bold ctermfg=11 gui=bold guifg=Blue ctermbg=16

" Always keep the ale syntax gutter open
let g:ale_sign_column_always = 1
" Set PHPCS standard file
" let g:ale_php_phpcs_standard = '~/.phpcs/rules.xml'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_linters = {'javascript': ['eslint'], 'java': ['javac'] }
let g:ale_disable_lsp = 1
" Shortcut keys for errors
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" turn off folding in markdown, it's annoying
let g:vim_markdown_folding_disabled=1

" COC completion on tab

" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

" FZF bindings
nnoremap <silent> <leader>f :GFiles<CR>
nmap <leader>b :Buffers<CR>

" FZF + ripgrep for project wide search
fun! s:openFileAtLocation(result)
  if len(a:result) == 0
    return
  endif
  let filePos = split(a:result, ':')
  exec 'edit +' . l:filePos[1] . ' ' . l:filePos[0]
endfun

let rgsearchfiles = 'rg --line-number --hidden --glob "!*.terraform" --glob "!*.class" --glob "!.idea/*" --glob "!**/.idea/*" --glob "!.git/*" --glob "!**/.git/*" --glob "!*.swp" ''.*'''
command! -bang -nargs=* FuzzySearchFiles call fzf#run(fzf#wrap({
 \ 'source': rgsearchfiles,
 \ 'options': '--delimiter :',
 \ 'sink': function('<sid>openFileAtLocation')
 \ }))
nnoremap <silent> <Leader>s :FuzzySearchFiles<CR>

nmap <silent> <leader>n<CR> :tab drop notes.md<CR>
