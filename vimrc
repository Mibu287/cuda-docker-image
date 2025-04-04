"Basic setting
set expandtab tabstop=4 shiftwidth=4 softtabstop=4
set autoindent
set textwidth=120
syntax on
inoremap jj <Esc>
set number
let g:netrw_bufsettings = 'noma nomod nu nowrap ro nobl'
set hlsearch
nnoremap <silent> <C-l> :nohl<CR><C-l>
set viminfo='100,<1000,s100,h

"switch between different tabs width
let mapleader = ","
noremap <leader>8 :set expandtab tabstop=8 shiftwidth=8 softtabstop=8<CR>
noremap <leader>4 :set expandtab tabstop=4 shiftwidth=4 softtabstop=4<CR>
noremap <leader>2 :set expandtab tabstop=2 shiftwidth=2 softtabstop=2<CR>

"Plugin
call plug#begin('~/.vim/plugged')
Plug 'junegunn/goyo.vim'
Plug 'tell-k/vim-autopep8'
Plug 'Chiel92/vim-autoformat'
Plug 'tarekbecker/vim-yaml-formatter'
Plug 'mattn/vim-goimports'
Plug 'mattn/emmet-vim'
Plug 'google/vim-maktaba'
Plug 'bazelbuild/vim-bazel'
Plug 'keith/swift.vim'
Plug 'rizzatti/dash.vim'
Plug 'hashivim/vim-terraform'
Plug 'rust-lang/rust.vim'
Plug 'jparise/vim-graphql'
Plug 'udalov/kotlin-vim'
Plug 'google/vim-codefmt'
Plug 'vim-python/python-syntax'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

"YAMLFormatter
noremap <C-Y> :YAMLFormat<cr>
let g:yaml_formatter_indent_collection=1
autocmd FileType y?ml setlocal ts=2 sts=2 sw=2 expandtab

"Kotlin Formatter
noremap <C-C> :FormatCode ktfmt<cr>

"Python Formatter
let g:formatdef_py_black = '"black - 2>/dev/null"'
let g:formatters_python = ['py_black']

"Python syntax highlight
let g:python_highlight_all = 1

"CSharp Formatter
let g:formatdef_custom_csharp = '"clang-format --assume-filename=main.cs --style=file"'
let g:formatters_cs = ['custom_csharp']

"Scala Formatter
let g:formatdef_custom_scala = '"scalafmt --config $HOME/.scalafmt.conf --stdin --stdout"'
let g:formatters_scala = ['custom_scala']
let g:formatters_sbt = ['custom_scala']

"SQL Formatter
let g:formatdef_custom_sql = '"sqlformat -k upper - | sql-formatter"'
let g:formatters_sql = ['custom_sql']

"Bazel build files
let g:formatdef_custom_bzl = '"buildifier -type default"'
let g:formatters_bzl = ['custom_bzl']

"Rust source formatter
let g:formatdef_custom_rust = '"rustfmt --force"'
let g:formatters_swift = ['custom_rust']

"Swift source formatter
let g:formatdef_custom_swift = '"swift-format --configuration $PWD/.swift-format"'
let g:formatters_swift = ['custom_swift']

"XML Formatter
let g:formatdef_libxml2 = '"xmllint --format -"'
let g:formatters_xml = ['libxml2']

"Hashicorp Packer Formatter
let g:formatdef_hcl = '"packer format -"'
let g:formatters_hcl = ['hcl']


"Setup CoC tools
hi CocInlayHint guibg=DarkGrey guifg=DarkGreen ctermbg=DarkGrey ctermfg=DarkGreen
inoremap <silent><expr> <c-@> coc#refresh()
noremap <C-I> :CocCommand document.toggleInlayHint<cr>
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Coc extensions
call coc#add_extension(
  \ 'coc-rust-analyzer',
\ )

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

"let g:rustfmt_autosave = 1
"let g:rust_cargo_use_clippy = 1

"Autoformat
noremap <C-K> :Autoformat<cr>
inoremap <C-K> :Autoformat<cr>

command! -nargs=? -range=% -complete=filetype -bar MAutoformat
            \ let mm_winview=winsaveview() |
            \ <line1>,<line2>s/#pragma omp/\/\/#pragma omp/e |
            \ <line1>,<line2>s/#pragma simd/\/\/#pragma simd/e |
            \ <line1>,<line2> Autoformat |
            \ <line1>,<line2>s/\/\/ *#pragma simd/#pragma simd/e |
            \ <line1>,<line2>s/\/\/ *#pragma omp/#pragma omp/e |
            \ call winrestview(mm_winview)

noremap <F3> :MAutoformat<cr>

"Setting for sepecial cases
au BufNewFile,BufRead *.py* set foldmethod=indent nofoldenable
"autocmd FileType c,cc,cpp,h,hpp set foldmethod=syntax nofoldenable
autocmd FileType c,cc,cpp,h,hpp hi Macro cterm=NONE ctermfg=yellow ctermbg=NONE
au BufNewFile,BufRead *.dump set syntax=asm
au BufNewFile,BufRead Makefile set noexpandtab
au BufNewFile,BufRead Makefile hi Identifier cterm=NONE ctermfg=green ctermbg=NONE
au BufNewFile,BufRead *.ii set syntax=cpp
au BufNewFile,BufRead *.i set syntax=cpp
au BufRead,BufNewFile *.g set filetype=antlr3
au BufRead,BufNewFile *.g4 set filetype=antlr4
