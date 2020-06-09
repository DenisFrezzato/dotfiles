packadd minpac

call minpac#init()

call minpac#add('Shougo/vimproc.vim')
call minpac#add('airblade/vim-gitgutter')
call minpac#add('editorconfig/editorconfig-vim')
call minpac#add('junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' })
call minpac#add('junegunn/fzf.vim')
call minpac#add('neoclide/coc.nvim')
call minpac#add('terryma/vim-multiple-cursors')
call minpac#add('tpope/vim-commentary')
call minpac#add('tpope/vim-fugitive')
call minpac#add('tpope/vim-markdown')
call minpac#add('tpope/vim-sensible')
call minpac#add('tpope/vim-surround')
call minpac#add('vim-airline/vim-airline')

call minpac#add('rakr/vim-one')

call minpac#add('neovimhaskell/haskell-vim')

call minpac#add('pangloss/vim-javascript')
call minpac#add('leafgarland/typescript-vim')
call minpac#add('MaxMEllon/vim-jsx-pretty')
call minpac#add('peitalin/vim-jsx-typescript')

call minpac#add('glacambre/firenvim', { 'type': 'opt', 'do': 'packadd firenvim | call firenvim#install(0)'})
if exists('g:started_by_firenvim')
  packadd firenvim
endif

packloadall

command! PackUpdate packadd minpac | source $MYVIMRC | call minpac#update('', {'do': 'call minpac#status()'})
command! PackClean  packadd minpac | source $MYVIMRC | call minpac#clean()
command! PackStatus packadd minpac | source $MYVIMRC | call minpac#status()

set encoding=utf8 
set number relativenumber
set ignorecase
set smartcase
set hlsearch
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4
set scrolloff=8

set background=light
let g:one_allow_italics = 1
let g:airline_theme = 'one'
colorscheme one

set cmdheight=2

let mapleader = ";"
let g:mapleader = ";"


" Let 'tl' toggle between this and the last accessed tab.
let g:lasttab = 1
nmap <leader>tl :exe "tabn ".g:lasttab<cr>
au TabLeave * let g:lasttab = tabpagenr()

map <leader>ss :setlocal spell!<cr> 
map <leader>fz :FZF<cr>
map <leader>ag :Ag<cr>

" Quickly move current line.
nnoremap [e :<c-u>execute 'move -1-'. v:count1<cr>
nnoremap ]e :<c-u>execute 'move +'. v:count1<cr>

nmap <leader>w :w<cr>
nmap <leader>q :q<cr>
map <silent> <leader><cr> :noh<cr>

" Clipboard functionality (paste from system).
vnoremap <leader>y "+y
nnoremap <leader>y "+y
nnoremap <leader>p "+p
vnoremap <leader>p "+p


" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)
" Show all diagnostics.
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest Coc list.
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
" Toggle CocExplorer
:nmap <leader>e :CocCommand explorer<CR>


let g:markdown_fenced_languages = ['html', 'python', 'bash=sh']

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved' 
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = '☰'
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.dirty='⚡' 
