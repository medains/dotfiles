" Vundle
filetype off

let g:vundle_default_git_proto = 'git'
set rtp+=~/.vim/bundle/vundle
call vundle#rc()

" Bundles
Bundle 'jlanzarotta/bufexplorer'
Bundle 'altercation/vim-colors-solarized'
Bundle 'kien/ctrlp.vim'
Bundle 'Lokaltog/vim-powerline'

" Check out these bundles
" Bundle 'tpope/vim-fugitive'
" Bundle 'sjl/gundo.vim'
" Bundle 'godlygeek/tabular'
" Bundle 'benmills/vimux'
" Bundle 'scrooloose/nerdtree'
" Bundle 'TomNomNom/xoria256.vim'
" Bundle 'tomasr/molokai'
" Bundle 'rking/ag.vim'
" Bundle 'jpalardy/vim-slime'
" Bundle 'neochrome/todo.vim'
" Bundle 'justinmk/vim-sneak'

" Filetype on
filetype plugin on
" Highlighting
syntax on

set encoding=utf-8



