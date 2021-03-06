" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

set modelines=0

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set nobackup		" do not keep a backup file, use versions instead
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time

" Don't use Ex mode, use Q for formatting
map Q gq

inoremap jj <esc>
" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>
inoremap <up>    <nop>
inoremap <down>  <nop>
inoremap <left>  <nop>
inoremap <right> <nop>
nnoremap <up>    <nop>
nnoremap <down>  <nop>
nnoremap <left>  <nop>
nnoremap <right> <nop>
nnoremap j gj
nnoremap k gk

nnoremap / /\v
vnoremap / /\v

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set number
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set whichwrap=<,>,h,l
"
" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

if &term == "xterm"
    set t_kb=
    fixdel
endif

set wrap

set wildmenu
set wildmode=list:longest
set visualbell
set cursorline

set dictionary=/usr/share/dict/words

" Removes trailing spaces
function! TrimTrailingWhiteSpace()
    %s/\s\+$//e
endfunction

nnoremap <silent> <Leader>rts :call TrimTrailingWhiteSpace()<CR>

if v:progname !~ "vimdiff"
    autocmd FileWritePre    * :call TrimTrailingWhiteSpace()
    autocmd FileAppendPre   * :call TrimTrailingWhiteSpace()
    autocmd FilterWritePre  * :call TrimTrailingWhiteSpace()
    autocmd BufWritePre     * :call TrimTrailingWhiteSpace()
"    autocmd BufWinEnter     * :match ErrorMsg '.\{81,\}'
    autocmd BufWinEnter     * :match ErrorMsg '\%>80v.\+'
    "autocmd BufWinLeave     * :call clearmatches()
endif

execute pathogen#infect()

python3 from powerline.vim import setup as powerline_setup
python3 powerline_setup()
python3 del powerline_setup
set rtp+=/usr/local/lib/python3.5/dist-packages/powerline/bindings/vim
set laststatus=2
silent! so .vimlocal
