" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
"call plug#begin('~/.vim/plugged')

"Plug 'ntk148v/vim-horizon'

" Initialize plugin system
"call plug#end()

" setup Vundle (run :PluginInstall to install plugins)
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" enable NERD tree - allows you to explore your filesystem
" and to open files and directories.
Plugin 'scrooloose/nerdtree.git'

" enable linuxsty - Linux Kernel Coding Style
Plugin 'vivien/vim-addon-linux-coding-style'

Plugin 'ntk148v/vim-horizon'

" end of Vundle initialization
call vundle#end()
filetype plugin indent on
filetype on


autocmd vimenter * NERDTree
colorscheme horizon
set number relativenumber
set nu rnu
execute pathogen#infect()
call pathogen#helptags()
autocmd! VimEnter * NERDTree | wincmd w
" close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif


" MyNext() and MyPrev(): Movement between tabs OR buffers
function! MyNext()
    if exists( '*tabpagenr' ) && tabpagenr('$') != 1
        " Tab support && tabs open
        normal gt
    else
        " No tab support, or no tabs open
        execute ":bnext"
    endif
endfunction
function! MyPrev()
    if exists( '*tabpagenr' ) && tabpagenr('$') != '1'
        " Tab support && tabs open
        normal gT
    else
        " No tab support, or no tabs open
        execute ":bprev"
    endif
endfunction

" use indentation of previous line
set autoindent

" use intelligent indentation for C
set smartindent

" configure tabwidth and insert spaces instead of tabs
set tabstop=4        " tab width is 4 spaces
set shiftwidth=4     " indent also with 4 spaces
set expandtab        " expand tabs to spaces

" turn syntax highlighting on
syntax on

" enhanced tab completion on commands
" set wildmenu
" set wildmode=longest:list,full

" Search
set hlsearch     " highlight matches
set incsearch    " incremental searching
set ignorecase   " searches are case insensitive...
set smartcase    " ... unless they contain at least one capital letter


" MAPPINGS

nnoremap L <ESC>:call MyNext()<CR>
nnoremap H <ESC>:call MyPrev()<CR>

" (CTRL-O) open nerd tree
nnoremap <C-o> <ESC>:NERDTreeToggle<CR>

