call plug#begin('~/.vim/plugins')
Plug 'airblade/vim-gitgutter'
Plug 'scrooloose/nerdtree'
call plug#end()

set nocompatible           " Disable any vi-compatibility
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'hashivim/vim-terraform'
call vundle#end()
filetype plugin indent on

set ruler                  " Always show line/col# stats
set number                 " Display line numbers
set hlsearch               " Highlight the latest search pattern
set nolbr                  " Don't wrap line on word boundaries
set nolist                 " Hide special (unprintable) characters
set ls=2                   " Always show filename
set ignorecase             " For searching
set smartcase              " If search contains a capital letter, check case
set mouse=a                " Enables mouse integration
set foldmethod=syntax      " Fold based on syntax
set foldlevel=99           " Unfold all by default
set backspace=indent,eol,start " Backspace over everything

set tabstop=4              " Visible width of tab character
set shiftwidth=4           " Width of indent/unindent
set expandtab              " Use spaces
set smartindent            " Smarter than 'autoindent'

" Colors
colorscheme desert

" No/transparent background
highlight Normal guibg=NONE ctermbg=NONE

" Highlight uwanted spaces
"highlight ExtraWhitespace ctermbg=darkgray guibg=darkgray
" Trailing whitespace | Tabs
"match ExtraWhitespace /\s\+$\|\t\+/
" Trailing whitespace | Tabs in middle of line
"match ExtraWhitespace /\s\+$\|[^\t]\zs\t\+/

highlight TrailingWhitespace ctermbg=darkred guibg=darkred
match TrailingWhitespace /\s\+$/

highlight TabsWhitespace ctermbg=darkgray guibg=darkgray
2match TabsWhitespace /\t\+/

if exists('+colorcolumn')
    set colorcolumn=81
endif

" Disable F1 Help Menu
map <F1> <nop>
imap <F1> <nop>

" Open on startup
"autocmd vimenter * NERDTree
