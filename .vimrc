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

call vundle#end()

" Filetype on
filetype plugin indent on
" Highlighting
syntax on

set encoding=utf-8



