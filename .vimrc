" Set syntax on
syntax on
" Indent automatically depending on filetype
filetype indent plugin on
" Autoindent code blocks
set autoindent
" Use the OS clipboard by default (on versions compiled with `+clipboard`)
set clipboard=unnamed
" Highlight current line
set cursorline
" Insert spaces when tab is pressed.
set expandtab
" One of the most important options to active. Allows you to switch from an
" unsaved buffer without saving it first. Also allows you to keep an undo
" history for multiple files. Vim will complain if you try to quit without
" saving, and swap files wll keep you safe if your computer crashes.
set hidden
" Highlight search
set hls
" Highlight matching braces!
set showmatch
" Highlight dynamically as pattern is typed
set incsearch
" Wrap text instead of being on one line
set lbr
" Make Vim more useful
set nocompatible
" Disable error bells
set noerrorbells
" Turn off line numbering with "set nonu", on with "set nu"
set nonu
" Show cursor position on the last line of the screen or in the status line.
set ruler
" Number of spaces used for indentation.
set shiftwidth=2
" Don’t show the intro message when starting Vim
set shortmess=atI
" Number of spaces to insert for a tab.
set tabstop=2
" Show the filename in the window titlebar
set title
" Enable 256 colors in Vim
set t_Co=256
" Enhance command-line completion
set wildmenu
" Select colorscheme
colorscheme lucius
LuciusBlackLowContrast
" Add comment keys
source ~/.vim/comments.vim
