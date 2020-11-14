" curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
" https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"
call plug#begin('$HOME/.vim/plugged')

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" GLOBAL

scriptencoding utf-8
nmap <Space> <Leader>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" EDIT HELPERS

set nospell

inoremap <C-s> <Esc>mm[s1z=`mi
nnoremap <C-s> [s1z=<C-o>
nnoremap <Leader>- mmvip:s/^\(\s*\)/\1- /<CR>`m
nnoremap <Leader>_ mmvip:s/^\(\s*\)- /\1/<CR>`m
nnoremap <Leader>q :quit<CR>
nnoremap <Leader>tS mmvip:sort!<CR>`m
nnoremap <Leader>ts mmvip:sort<CR>`m
nnoremap K i<CR><Esc>
vnoremap < <gv
vnoremap > >gv
vnoremap Y myY`y
vnoremap y myy`y
xnoremap p pgvy

function! Trim()
  let s:pos=getpos('.')
  execute '%s/\s\+$//ge'
  execute '%s/\($\n\s*\)\+\%$//e'
  execute '%s/\.\s\{2,\}/. /ge'
  call setpos('.', s:pos)
endfunction
nnoremap <Leader>tt :call Trim()<CR>
augroup Trim
  autocmd! BufWrite *.md,*.md.asc call Trim()
augroup END

function! RemoveFancyCharacters()
  let l:typo={'–': '--', '—': '---', '…': '...', '‘': '''', '’': '''', '“': '"', '”': '"'}
  execute ':%s/'.join(keys(l:typo), '\|').'/\=typo[submatch(0)]/ge'
endfunction
command! RemoveFancyCharacters call RemoveFancyCharacters()

set textwidth=72 nowrap linebreak formatoptions=cronqBj nojoinspaces autoindent shiftround expandtab shiftwidth=2 softtabstop=2 tabstop=2
set smartcase ignorecase incsearch
Plug 'junegunn/vim-easy-align'
Plug 'terryma/vim-expand-region'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
  vmap v <Plug>(expand_region_expand)
  vmap <C-v> <Plug>(expand_region_shrink)

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" COMPLETION

Plug 'shougo/neocomplete.vim'

  let g:neocomplete#sources#omni#input_patterns={}
  let g:neocomplete#force_omni_input_patterns={}
  let g:neocomplete#enable_auto_select=1
  let g:neocomplete#enable_at_startup=1
  let g:neocomplete#enable_smart_case=1

  augroup NeoComplete
    autocmd! FileType css setlocal omnifunc=csscomplete#CompleteCSS
    autocmd! FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd! FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  augroup END

  inoremap <expr><Tab> pumvisible() ? "\<C-y>" : "\<Tab>"
  inoremap <expr><CR> neocomplete#smart_close_popup()."\<CR>"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" INTEGRATION TOOLS

set clipboard=unnamed
set nobackup nowritebackup noswapfile
set undofile undolevels=1000 undoreload=3000 undodir=$HOME/.vim/undo/

set viminfo='10,\"100,:20,%,n$HOME/.vim/viminfo
augroup LastPositionJump
  autocmd! BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

" Search and files

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
let $FZF_DEFAULT_COMMAND = 'ag -g ""'
set path=.,**
set wildcharm=<C-z>
set wildignore+=*.gif,*.ico,*.jpg,*.png,node_modules/*,.git/**/*,_site/*,tags,*.tar.*
set wildmenu wildignorecase
command! -nargs=+ Grep execute 'vim <args> *' | copen
nnoremap <Leader>/ :Ag<Space>
nnoremap <Leader>a :Files<CR>

" Buffers

set hidden
nnoremap <Leader>b :Buffers<CR>

Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-eunuch'
  nnoremap <Leader>w :W<CR>
Plug 'tpope/vim-fugitive'
  nnoremap <Leader>d :Gdiff<CR>
  nnoremap <Leader>g :Gstatus<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" FILE TYPE SPECIFIC

" Formatters

Plug 'ianks/vim-tsx', { 'for': ['tsx'] }
Plug 'leafgarland/typescript-vim', { 'for': ['tsx', 'ts'] }

" Linters

Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \ 'branch': 'release/1.x',
  \ 'for': [ 'javascript', 'typescript', 'css', 'json', 'markdown', 'yaml', 'html', 'graphql' ] }
  nnoremap <Leader>pp :Prettier<CR>
  " let g:prettier#autoformat = 1
  " augroup Prettier
  "   autocmd!
  "   autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.scss,*.json,*.graphql,*.md,*.yaml,*.html PrettierAsync
  " augroup END


let g:prettier#autoformat = 0
" autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.scss,*.json,*.graphql,*.md,*.yaml,*.html PrettierAsync

Plug 'w0rp/ale', {'for': ['sql', 'vim', 'bash', 'sh', 'javascript', 'typescript' ]}
  let g:ale_lint_on_text_changed='normal'


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" DECORATIONS

Plug 'jparise/vim-graphql'
Plug 'slim-template/vim-slim'
Plug 'tpope/vim-markdown'
let g:markdown_fenced_languages=['sh', 'vim', 'javascript', 'json', 'html', 'sass', 'css']
set background=dark
set cursorline
set number
set ruler

syntax on
highlight clear

highlight CursorColumn ctermfg=NONE    ctermbg=236  cterm=NONE
highlight CursorLine   ctermfg=NONE    ctermbg=236  cterm=NONE
highlight CursorLineNr ctermfg=7       ctermbg=236  cterm=NONE
highlight DiffAdd      ctermfg=2       ctermbg=NONE cterm=NONE
highlight DiffChange   ctermfg=2       ctermbg=NONE cterm=NONE
highlight DiffDelete   ctermfg=1       ctermbg=NONE cterm=NONE
highlight DiffText     ctermfg=2       ctermbg=236  cterm=NONE
highlight FoldColumn   ctermfg=248     ctermbg=NONE cterm=italic
highlight Folded       ctermfg=248     ctermbg=NONE cterm=italic
highlight LineNr       ctermfg=238     ctermbg=NONE cterm=NONE
highlight MatchParen   cterm=underline ctermbg=NONE cterm=NONE
highlight NonText      ctermfg=236     ctermbg=NONE cterm=NONE
highlight Normal       ctermfg=NONE    ctermbg=NONE cterm=NONE
highlight Pmenu        ctermfg=15      ctermbg=236  cterm=NONE
highlight PmenuSbar    ctermfg=7       ctermbg=NONE cterm=NONE
highlight PmenuSel     ctermfg=236     ctermbg=2    cterm=NONE
highlight PmenuThumb   ctermfg=7       ctermbg=NONE cterm=NONE
highlight SignColumn   ctermfg=NONE    ctermbg=NONE cterm=NONE
highlight SpellBad     ctermfg=NONE    ctermbg=NONE cterm=underline
highlight SpellCap     ctermfg=NONE    ctermbg=NONE cterm=underline
highlight Error        ctermfg=1       ctermbg=NONE cterm=underline
highlight StatusLine   ctermfg=15      ctermbg=236  cterm=bold
highlight StatusLineNC ctermfg=245     ctermbg=0    cterm=NONE
highlight VertSplit    ctermfg=236     ctermbg=236  cterm=NONE
highlight Visual       ctermfg=NONE    ctermbg=238  cterm=NONE
highlight WildMenu     ctermfg=236     ctermbg=2    cterm=NONE
highlight qfFileName   ctermfg=245     ctermbg=NONE cterm=italic
highlight qfLineNr     ctermfg=238     ctermbg=NONE cterm=NONE
highlight qfSeparator  ctermfg=0       ctermbg=NONE cterm=NONE

highlight Comment        ctermfg=248 ctermbg=NONE cterm=NONE
highlight String         ctermfg=10  ctermbg=NONE cterm=NONE
highlight htmlH1         ctermfg=15  ctermbg=NONE cterm=bold
highlight htmlItalic     ctermfg=7   ctermbg=NONE cterm=italic
highlight htmlItalicBold ctermfg=15  ctermbg=NONE cterm=italic
highlight htmlBoldItalic ctermfg=15  ctermbg=NONE cterm=bold

" function! HighlightItem()
"   return synIDattr(synID(line('.'),col('.'),1),'name')
" endfunction
" set statusline=%{HighlightItem()}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

call plug#end()
