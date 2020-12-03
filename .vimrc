"set autochdir

set listchars=tab:→\ ,nbsp:•,trail:·,precedes:«,extends:»
set list

set expandtab
set ts=4 sts=4 sw=4
set smarttab
set autoindent
set cindent
set tw=80
set wrap

set autoread
set autowriteall
set ignorecase
set smartcase
set hlsearch
set incsearch
syntax enable
filetype plugin indent on

set undodir=~/.vim/undodir
set undofile
set undolevels=5000
set undoreload=50000

let mapleader = '_'

set formatoptions-=t

nnoremap <F1> :make <CR>
nnoremap <F2> :!xclip -sel clipboard % <CR> :redraw! <CR>
nnoremap <F4> :bprev <CR>
nnoremap <F5> :bnext <CR>
nnoremap <F8> :cprev <CR>
nnoremap <F9> :cnext <CR>
nnoremap <S-F8> :lprev <CR>
nnoremap <F20> :lprev <CR>
nnoremap <S-F9> :lnext <CR>
nnoremap <F21> :lnext <CR>
nnoremap <F12> :TagbarToggle<CR>
nnoremap <BS> :b# <CR>

let g:base_directory = getcwd()
nnoremap <Leader>e :next <C-R>=g:base_directory<CR>/

nnoremap <Leader>/ :nohl<CR>
nnoremap <Leader>u :UndotreeToggle<CR>

" RipGrep
let g:rg_derive_root = 1
let g:rg_highlight = 1
let &grepprg = 'rg --vimgrep'

set statusline=
set statusline+=%#PmenuSel#
"set statusline+=%{FugitiveStatusLine()}
set statusline+=%#LineNr#
set statusline+=\ %f
set statusline+=%m\
set statusline+=%=
set statusline+=%#CursorColumn#
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
set statusline+=\ %p%%
set statusline+=\ %l:%c
set statusline+=\ 

" display diff in a vertical split when commiting
function! OpenCommitMessageDiff()
  " Save the contents of the z register
  let old_z = getreg("z")
  let old_z_type = getregtype("z")

  try
    call cursor(1, 0)
    let diff_start = search("^diff --git")
    if diff_start == 0
      " There's no diff in the commit message; generate our own.
      let @z = system("git diff --cached -M -C")
    else
      " Yank diff from the bottom of the commit message into the z register
      :.,$yank z
      call cursor(1, 0)
    endif

    " Paste into a new buffer
    vnew
    normal! V"zP
  finally
    " Restore the z register
    call setreg("z", old_z, old_z_type)
  endtry

  " Configure the buffer
  set filetype=diff noswapfile nomodified readonly
  silent file [Changes\ to\ be\ committed]

  " Get back to the commit message
  wincmd p
endfunction

" Syntastic
set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0

augroup Perso
    au!
    au BufWrite,BufEnter,BufWritePost,BufLeave .vimrc* source %
    au CursorHold,CursorHoldI * checktime
    au FocusGained,BufEnter * checktime

    au BufEnter *.cpp,*.c,*.cc,*.hh,*.h,*.py,*.sh,*.rs set number

    au BufEnter *.sh let &l:makeprg='./%'
    au BufEnter Cargo.toml,Cargo.lock compiler cargo

    " BufRead seems more appropriate here but for some reason the final `wincmd p` doesn't work if we do that.
    autocmd VimEnter COMMIT_EDITMSG call OpenCommitMessageDiff()

    "autocmd BufEnter *.rs,*.toml nnoremap <buffer> <F1> :silent make clippy --tests <CR> : redraw! <CR>
    autocmd BufEnter *.rs,*.toml nnoremap <buffer> <F1> :silent make clippy --tests <CR> : redraw! <CR>
    autocmd BufEnter *.rs,*.toml nnoremap <buffer> <S-F1> :silent make test <CR> : redraw! <CR>
    autocmd BufEnter *.rs,*.toml nnoremap <buffer> [1;2P :silent make test <CR> : redraw! <CR>
    "autocmd BufWrite *.rs silent make check | redraw!
    "autocmd BufEnter *.rs let &l:tags = systemlist("git rev-parse --show-toplevel")[0] . "/rusty-tags.vi"
    "autocmd BufWritePost *.rs silent! exec "!rusty-tags vi --quiet --start-dir='" . systemlist("git rev-parse --show-toplevel")[0] . "' &" | redraw!
augroup END


if filereadable("/home/rmoussu/.vimrc.local")
    source /home/rmoussu/.vimrc.local
endif
