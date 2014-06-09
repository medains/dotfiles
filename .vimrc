" Vundle
set nocompatible
filetype off

let g:vundle_default_git_proto = 'git'
set rtp+=~/.vim/bundle/vundle
call vundle#begin()

" Bundles
Plugin 'jlanzarotta/bufexplorer'
Plugin 'altercation/vim-colors-solarized'
Plugin 'kien/ctrlp.vim'
Plugin 'Lokaltog/vim-powerline'
Plugin 'neochrome/todo.vim' " Todo manage
Plugin 'hallison/vim-markdown' " Markdown syntax highlighting

" Check out these bundles
" Bundle 'tpope/vim-fugitive' - git wrapper
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
else
	set background=dark
endif
colorscheme solarized

set encoding=utf-8
" Always show statusline (powerline)
set laststatus=2



