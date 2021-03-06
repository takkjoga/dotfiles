" NeoBundleInit
let $VIMBUNDLE = '~/.vim/bundle'
let $NEOBUNDLEPATH = $VIMBUNDLE . '/neobundle.vim'
if stridx(&runtimepath, $NEOBUNDLEPATH) != -1
" If the NeoBundle doesn't exist.
command! NeoBundleInit try | call s:neobundle_init()
            \| catch /^neobundleinit:/
                \|   echohl ErrorMsg
                \|   echomsg v:exception
                \|   echohl None
                \| endtry

function! s:neobundle_init()
    redraw | echo "Installing neobundle.vim..."
    if !isdirectory($VIMBUNDLE)
        call mkdir($VIMBUNDLE, 'p')
        echo printf("Creating '%s'.", $VIMBUNDLE)
    endif
    cd $VIMBUNDLE

    if executable('git')
        call system('git clone git://github.com/Shougo/neobundle.vim')
        if v:shell_error
            throw 'neobundleinit: Git error.'
        endif
    endif

    set runtimepath& runtimepath+=$NEOBUNDLEPATH
    call neobundle#rc($VIMBUNDLE)
    try
        echo printf("Reloading '%s'", $MYVIMRC)
        source $MYVIMRC
    catch
        echohl ErrorMsg
        echomsg 'neobundleinit: $MYVIMRC: could not source.'
        echohl None
        return 0
    finally
        echomsg 'Installed neobundle.vim'
    endtry

    echomsg 'Finish!'
endfunction

autocmd! VimEnter * redraw
            \ | echohl WarningMsg
            \ | echo "You should do ':NeoBundleInit' at first!"
            \ | echohl None
endif
" NeoBundleInit

if 0 | endif

if has('vim_starting')
  if &compatible
    set nocompatible               " Be iMproved
  endif

  " Required:
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" Required:
call neobundle#begin(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck

NeoBundle 'Shougo/unite.vim'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'kmnk/vim-unite-giti.git'
NeoBundle 'camelcasemotion'
NeoBundle 'Shougo/vimshell'
NeoBundle 'Shougo/vimfiler'

" status line
NeoBundle 'bling/vim-airline'

" color scheme
NeoBundle 'sjl/badwolf'

NeoBundle 'elixir-lang/vim-elixir'

" Swift syntax
NeoBundle 'toyamarinyon/vim-swift'
au BufNewFile,BufRead *.swift set filetype=swift

" use slim template
NeoBundle "slim-template/vim-slim"
au BufNewFile,BufRead *.slim set filetype=slim

" My Bundles here:
" Refer to |:NeoBundle-examples|.
" Note: You don't set neobundle setting in .gvimrc!

call neobundle#end()

" ------------------------------------
" colorscheme
" ------------------------------------
syntax on

set fileencodings=utf-8,iso-2022-jp,cp932,sjis,euc-jp

" unite
" 入力モードで開始する
let g:unite_enable_start_insert=1
let g:unite_enable_ignore_case=1
" grepの代わりにagを使う
let g:unite_source_grep_command = 'ag'
let g:unite_source_grep_default_opts = '--nocolor --nogroup'                                                                                              
let g:unite_source_grep_max_candidates = 200
let g:unite_source_grep_recursive_opt = ''
" バッファ一覧
noremap <C-P> :Unite buffer<CR>
" ファイル一覧
noremap <C-F> :Unite -buffer-name=file file<CR>
" 最近使ったファイルの一覧
noremap <C-Z> :Unite file_mru<CR>
" 現在のディレクトリ
noremap <C-I> :UniteWithBufferDir file<CR>
" 現在のファイルのoutline
noremap <C-Q> :Unite outline<CR>

" vim-unite-giti
nnoremap <silent>gl :Unite giti/log -no-start-insert -horizontal<CR>
nnoremap <silent>gP :Unite giti/pull_request/base -no-start-insert -horizontal<CR>
nnoremap <silent>gs :Unite giti/status -no-start-insert -horizontal<CR>
nnoremap <silent>gh :Unite giti/branch_all -no-start-insert<CR>

" ウィンドウを分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-J> unite#do_action('split')
au FileType unite inoremap <silent> <buffer> <expr> <C-J> unite#do_action('split')
" ウィンドウを縦に分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-K> unite#do_action('vsplit')
au FileType unite inoremap <silent> <buffer> <expr> <C-K> unite#do_action('vsplit')
" ESCキーを2回押すと終了する
au FileType unite nnoremap <silent> <buffer> <ESC><ESC> :q<CR>
au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>:q<CR>

" Camelcase の単語間移動を変更
map <silent> w <Plug>CamelCaseMotion_w
map <silent> b <Plug>CamelCaseMotion_b
map <silent> e <Plug>CamelCaseMotion_e

nmap <ESC><ESC> :nohl<CR><ESC>

set tabstop=2
set autoindent
set expandtab
set shiftwidth=2
set incsearch
set nowrapscan
set noundofile

" below tabline
" Anywhere SID.
function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

" Set tabline.
function! s:my_tabline()  "{{{
  let s = ''
  for i in range(1, tabpagenr('$'))
    let bufnrs = tabpagebuflist(i)
    let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
    let no = i  " display 0-origin tabpagenr.
    let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
    let title = fnamemodify(bufname(bufnr), ':t')
    let title = '[' . title . ']'
    let s .= '%'.i.'T'
    let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
    let s .= no . ':' . title
    let s .= mod
    let s .= '%#TabLineFill# '
  endfor
  let s .= '%#TabLineFill#%T%=%#TabLine#'
  return s
endfunction "}}}
let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
set showtabline=2 " 常にタブラインを表示

" The prefix key.
nnoremap    [Tag]   <Nop>
nmap    t [Tag]
" Tab jump
for n in range(1, 9)
  execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor
" t1 で1番左のタブ、t2 で1番左から2番目のタブにジャンプ

map <silent> [Tag]c :tablast <bar> tabnew<CR>
" tc 新しいタブを一番右に作る
map <silent> [Tag]x :tabclose<CR>
" tx タブを閉じる
map <silent> [Tag]n :tabnext<CR>
" tn 次のタブ
map <silent> [Tag]p :tabprevious<CR>
" tp 前のタブ

if exists("neovim_dot_app")
  source ~/.gvimrc
endif
