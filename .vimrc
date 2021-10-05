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

augroup Complete
  autocmd! FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd! FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd! FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
augroup END

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
Plug 'psf/black', { 'branch': 'stable' }
  " autocmd BufWritePre *.py execute ':Black'
  autocmd FileType python nnoremap <buffer> <Leader>pp :Black<CR>

Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \ 'branch': 'release/1.x',
  \ 'for': [ 'javascript', 'typescript', 'css', 'json', 'markdown', 'yaml', 'html', 'graphql' ] }
  nnoremap <Leader>pp :Prettier<CR>
" let g:prettier#autoformat = 0
" autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.scss,*.json,*.graphql,*.md,*.yaml,*.html PrettierAsync

Plug 'w0rp/ale', {'for': ['sql', 'vim', 'bash', 'sh', 'javascript', 'typescript', 'python' ]}
  let g:ale_lint_on_text_changed='normal'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" DECORATIONS

Plug 'jparise/vim-graphql'
Plug 'slim-template/vim-slim'
Plug 'tpope/vim-markdown'
let g:markdown_fenced_languages=['sh', 'vim', 'javascript', 'json', 'html', 'sass', 'css']
set cursorline
set number
set ruler
syntax on
syntax reset
highlight clear

set background=light
" set background=dark

if &background == "light"
  highlight CursorColumn ctermbg=7
  highlight LineNr       ctermfg=7
  highlight CursorLineNr ctermfg=8
  highlight Comment      ctermfg=8
  highlight ColorColumn  ctermfg=8  ctermbg=7
  highlight Folded       ctermfg=8  ctermbg=7
  highlight FoldColumn   ctermfg=8  ctermbg=7
  highlight Pmenu        ctermfg=0  ctermbg=7
  highlight PmenuSel     ctermfg=7  ctermbg=0
  highlight StatusLine   ctermfg=0  ctermbg=15   cterm=bold
  highlight StatusLineNC ctermfg=7  ctermbg=NONE cterm=NONE
  highlight VertSplit    ctermfg=15 ctermbg=NONE cterm=NONE
else
  highlight CursorColumn ctermbg=8
  highlight LineNr       ctermfg=8
  highlight CursorLineNr ctermfg=7
  highlight Comment      ctermfg=8
  highlight ColorColumn  ctermfg=7  ctermbg=8
  highlight Folded       ctermfg=7  ctermbg=8
  highlight FoldColumn   ctermfg=7  ctermbg=8
  highlight Pmenu        ctermfg=15 ctermbg=8
  highlight PmenuSel     ctermfg=8  ctermbg=15
  highlight StatusLine   ctermfg=15 ctermbg=8    cterm=bold
  highlight StatusLineNC ctermfg=8  ctermbg=0    cterm=NONE
  highlight VertSplit    ctermfg=8  ctermbg=NONE cterm=NONE
endif

highlight SignColumn     ctermfg=NONE    ctermbg=NONE cterm=NONE
highlight SpellCap       ctermfg=NONE    ctermbg=NONE cterm=underline
highlight String         ctermfg=10      ctermbg=NONE cterm=NONE
highlight htmlH1         ctermfg=15      ctermbg=NONE cterm=bold
highlight htmlItalic     ctermfg=7       ctermbg=NONE cterm=italic
highlight htmlItalicBold ctermfg=15      ctermbg=NONE cterm=italic
highlight htmlBoldItalic ctermfg=15      ctermbg=NONE cterm=bold
highlight SpecialKey     ctermfg=4
highlight TermCursor     cterm=reverse
highlight NonText        ctermfg=12
highlight Directory      ctermfg=4
highlight ErrorMsg       ctermfg=15      ctermbg=1
highlight IncSearch      cterm=reverse
highlight MoreMsg        ctermfg=2
highlight ModeMsg        cterm=bold
highlight Question       ctermfg=2
highlight Title          ctermfg=5
highlight WarningMsg     ctermfg=1
highlight WildMenu       ctermfg=0       ctermbg=11
highlight Conceal        ctermfg=7       ctermbg=7
highlight SpellBad       cterm=underline ctermfg=NONE ctermbg=NONE
highlight SpellRare      ctermbg=13
highlight SpellLocal     ctermbg=14
highlight PmenuSbar      ctermbg=8
highlight PmenuThumb     ctermbg=0
highlight TabLine        cterm=underline ctermfg=0    ctermbg=7
highlight TabLineSel     cterm=bold
highlight TabLineFill    cterm=reverse
highlight CursorLine     cterm=underline
highlight MatchParen     ctermbg=14
highlight Constant       ctermfg=1
highlight Special        ctermfg=5
highlight Identifier     cterm=NONE      ctermfg=6
highlight Statement      ctermfg=3
highlight PreProc        ctermfg=5
highlight Type           ctermfg=2
highlight Underlined     cterm=underline ctermfg=5
highlight Ignore         ctermfg=15
highlight Error          ctermfg=15      ctermbg=9
highlight Todo           ctermfg=0       ctermbg=11
highlight Visual         ctermfg=NONE    ctermbg=NONE cterm=inverse
highlight Search         ctermfg=0       ctermbg=11
highlight DiffAdd        ctermfg=0       ctermbg=2
highlight DiffChange     ctermfg=0       ctermbg=3
highlight DiffDelete     ctermfg=0       ctermbg=1
highlight DiffText       ctermfg=0       ctermbg=11   cterm=bold

let g:fzf_colors =                                                                         
  \ { 'fg':      ['fg', 'Normal'],                                                           
    \ 'bg':      ['bg', 'Normal'],                                                           
    \ 'hl':      ['fg', 'Comment'],                                                          
    \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],                             
    \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],                                       
    \ 'hl+':     ['fg', 'Statement'],                                                        
    \ 'info':    ['fg', 'PreProc'],                                                          
    \ 'border':  ['fg', 'Ignore'],                                                           
    \ 'prompt':  ['fg', 'Conditional'],                                                      
    \ 'pointer': ['fg', 'Exception'],                                                        
    \ 'marker':  ['fg', 'Keyword'],                                                          
    \ 'spinner': ['fg', 'Label'],                                                            
    \ 'header':  ['fg', 'Comment'] } 

" function! HighlightItem()
"   return synIDattr(synID(line('.'),col('.'),1),'name')
" endfunction
" set statusline=%{HighlightItem()}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

call plug#end()
