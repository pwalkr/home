set nocompatible           " Disable any vi-compatibility
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
set noexpandtab            " Use tabs
set smartindent            " Smarter than 'autoindent'

filetype plugin on

" Colors
colorscheme desert
syntax on

" Highlight uwanted spaces
highlight ExtraWhitespace ctermbg=darkred guibg=darkred
" Trailing whitespace | Tabs
"match ExtraWhitespace /\s\+$\|\t\+/
" Trailing whitespace | Tabs in middle of line
match ExtraWhitespace /\s\+$\|[^\t]\zs\t\+/

" Highlight 81st column
highlight ColorColumn ctermbg=black guibg=black
if exists('+colorcolumn')
    set colorcolumn=81
else
    match ColorColumn /\%81v.\+/
endif
