" ===== 基本 =====
set nocompatible
set encoding=utf-8
scriptencoding utf-8
set fileencodings=utf-8,cp932,euc-jp,iso-2022-jp,latin1
set fileformats=unix,dos,mac
set formatoptions+=mM
autocmd FileType * setlocal formatoptions-=ro
" set ambiwidth=double  " ターミナル設定に応じて有効化
set number relativenumber
set cursorline
set mouse=a
set termguicolors
set title
set hidden

" 検索
set ignorecase smartcase
set incsearch hlsearch
nnoremap <Esc> :nohlsearch<CR><Esc>

" インデント/タブ
set expandtab
set shiftwidth=2
set tabstop=2
set smartindent

" スクロールと描画
set scrolloff=4
set signcolumn=yes
set updatetime=300

" クリップボード（WSL/Win/Mac でシステム共有）
set clipboard=unnamedplus

" Undo/backup
set undofile
set undodir=~/.cache/vim/undo//
set backupdir=~/.cache/vim/backup//
set directory=~/.cache/vim/swap//

" 分割の向き＆移動
set splitright splitbelow
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" よく使うショートカット
let mapleader=" "
nnoremap <leader>w :write<CR>
nnoremap <leader>q :quit<CR>
inoremap jk <Esc>
nnoremap ; :

" ファイルタイプ/シンタックス
syntax on
filetype plugin indent on

" 便利トグル
nnoremap <leader>n :set invnumber invrelativenumber<CR>
nnoremap <leader>p :set invpaste paste?<CR>

" ===== ペースト対策（Bracketed Paste） =====
if &term =~ "xterm" || &term =~ "screen" || &term =~ "tmux"
  let &t_SI .= "\e[?2004h"
  let &t_EI .= "\e[?2004l"
  inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()
  function! XTermPasteBegin()
    set pastetoggle=<Esc>[201~
    set paste
    return ""
  endfunction
endif

" カラースキーム（入ってれば）
silent! colorscheme desert

