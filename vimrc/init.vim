set encoding=utf-8
scriptencoding utf-8

" setup vim-plug (run :PlugInstall to install plugins)
call plug#begin()
    " Colorscheme
    Plug 'dracula/vim', { 'as': 'dracula' }

    Plug 'majutsushi/tagbar'

    Plug 'kyazdani42/nvim-web-devicons' " optional, for file icons
    Plug 'kyazdani42/nvim-tree.lua'

    " Fuzzy finder
    Plug 'junegunn/fzf'
    Plug 'junegunn/fzf.vim'

    " Cscope script
    Plug 'joe-skb7/cscope-maps'

    " Linux Kernel Coding Style
    Plug 'vivien/vim-linux-coding-style'

    " Configure the LSP and some other plugins for code completion
    " source: https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion
    " More configs in after/plugin/nvim-lspconfig.lua
    Plug 'neovim/nvim-lspconfig'    " Collection of configurations for built-in LSP client
    Plug 'hrsh7th/nvim-cmp'         " Autocompletion plugin
    Plug 'hrsh7th/cmp-nvim-lsp'     " LSP source for nvim-cmp
    Plug 'hrsh7th/cmp-buffer'       " Get suggestion from buffer
    Plug 'saadparwaiz1/cmp_luasnip' " Snippets source for nvim-cmp
    Plug 'L3MON4D3/LuaSnip'         " Snippets plugin
" Initialize plugin system
call plug#end()

" Use deoplete.
let g:deoplete#enable_at_startup = 1
" disable netrw at the very start of your init.lua (strongly advised)
let g:loaded = 1
let g:loaded_netrwPlugin = 1


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

" Configure the colorscheme
set background=dark
colorscheme dracula
if (has("nvim"))
  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

"For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
"Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
" < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
if (has("termguicolors"))
  set termguicolors
endif
let g:palenight_terminal_italics=1

" Shows the line numbers
set number relativenumber
set nu rnu

" set UTF-8 encoding
set enc=utf-8
set fenc=utf-8
set termencoding=utf-8
" disable vi compatibility (emulation of old bugs)
set nocompatible
" use indentation of previous line
set autoindent
" use intelligent indentation for C
set smartindent
" configure tabwidth and insert spaces instead of tabs
set tabstop=4        " tab width is 4 spaces
set shiftwidth=4     " indent also with 4 spaces
set expandtab        " expand tabs to spaces
" turn syntax highlighting on
set t_Co=256
syntax on
" highlight matching braces
set showmatch
" intelligent comments
set comments=sl:/*,mb:\ *,elx:\ */
" Enables the mouse wheel and the use in visual mode
set mouse=a
" Enable clipboard copy paste. If it is not working
" just install gvim (even if you don't use it
" to install de dependencies
set clipboard=unnamedplus

set list
set listchars=tab:>.,trail:~,extends:>,precedes:<

" Fix the ctrl + arrow key problem in tmux
if &term =~ '^screen'
    " tmux will send xterm-style keys when its xterm-keys option is on
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif

" enhanced tab completion on commands
" set wildmenu
" set wildmode=longest:list,full

" Search
set hlsearch     " highlight matches
set incsearch    " incremental searching
set ignorecase   " searches are case insensitive...
set smartcase    " ... unless they contain at least one capital letter

" CTAGS
set tags=tags

" MAPPINGS
" fzf mappings
nnoremap <C-p> :GFiles<Cr>
nnoremap <C-f> :Lines<Cr>
nnoremap <C-g> :Ag<Cr>
nnoremap <silent><leader>l :Buffers<CR>

" Remove all trailing spaces
nnoremap <silent> <F4> :let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s <CR>
" (F5) Build tags of your own project
nnoremap <F5> <ESC>:!ctags -R --extra=+fq --c-kinds=+px --fields=+iaS .<CR><CR>
         \:!find . -iname '*.c' -o -iname '*.cpp' -o -iname '*.h' -o -iname '*.hpp' > cscope.files<CR>
         \:!cscope -b -i cscope.files -f cscope.out<CR>
         \:cs reset<CR>

" (F8) Open the Tagbar
nmap <F8> :TagbarToggle<CR>

map <C-Right> <ESC>:tabnext<CR>
map <C-Left> <ESC>:tabprev<CR>
nnoremap L <ESC>:call MyNext()<CR>
nnoremap H <ESC>:call MyPrev()<CR>

" (CTRL-A) open nerd tree
nnoremap <C-a> <ESC>:NvimTreeToggle<CR>

" Linux Coding Plugin Settings
let g:linuxsty_patterns = [ "/linux/", "/kernel/" ]
nnoremap <silent> <F3> :LinuxCodingStyle<CR>

