" Turn on line numbering. Turn it off with "set nonu", on with "set nu"
set nonu

" Set syntax on
syntax on

" Indent automatically depending on filetype
filetype indent plugin on
set autoindent

" Highlight search
set hls

" Wrap text instead of being on one line
set lbr

" One of te most important options to active. Allows you to switch from an
" unsaved buffer without saving it first. Also allows you to keep an undo
" history for multiple files. Vim will complain if you try to quit without
" saving, and swap files wll keep you safe if your computer crashes.
set hidden

" Display the cursor position on the last line of the screen or in the status
" line of a window
set ruler

" Indentation settings for using hard tabs for indent. Display tabs as
" two characters wide.
set shiftwidth=2
set tabstop=2
set expandtab

" Highlight matching braces!
set showmatch

" Highlight current line
set cursorline
