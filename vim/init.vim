set nocompatible
filetype off

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

syntax on
filetype plugin indent on

colorscheme miro8

let mapleader = ","
autocmd BufWritePre * %s/\s\+$//e " Deletes trailing whitespace on save
set autoindent                    " Copies indentation from previous line
set encoding=utf-8
set wildmenu
set nobackup
set nowritebackup
set noswapfile
set ignorecase
set relativenumber
set number
set wildignore+=*/node_modules/*,*/target/*,*/.out,*/.git/*,*.swp

set scrolloff=3                   " Leave n lines of buffer when scrolling
set sidescrolloff=5               " Same for horizontal
set cursorline
set colorcolumn=110
highlight ColorColumn ctermbg=238

set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set backspace=indent,eol,start

" Basic commands mapping
noremap <leader>w :w<CR>
noremap <leader>q :q!<CR>
nnoremap Y y$
setglobal pastetoggle=<F3>
inoremap <C-C> <Esc>`^
inoremap {<CR> {<CR>}<Esc>O
noremap <silent> <leader>n :bnext<CR>

" <Ctrl-l> redraws the screen and removes any search highlighting.
nnoremap <silent> <leader>L :nohl<CR><C-l>

" Copy/Paste to system clipboard
" * and + are sys clipboards
" * is PRIMARY or on select (pasted with mid mouse button)
" + is CLIPBOARD, ^C (pasted with ctrl+c)
" Clipboard access is needed :help clipboard
noremap <Leader>y "+y
noremap <Leader>p "+p

" vim-commentary
autocmd FileType c,cpp,cs,java        setlocal commentstring=//\ %s
autocmd FileType sql                  setlocal commentstring=--\ %s

" fzf
nnoremap <leader>s :Files<CR>
nnoremap <leader>S :Buffers<CR>
nnoremap <leader>ag :Ag<CR>
nnoremap <leader>A :History<CR>

" coc
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
let g:coc_global_extensions = [
  \ 'coc-rls',
  \ 'coc-go',
  \ 'coc-tsserver',
  \ 'coc-json',
  \ ]

" airline
let g:airline_theme = 'jellybeans'
