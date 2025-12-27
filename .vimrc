" Author: Verdant<i@glowisle.me>
" Date: 2025-06-27
" Version: 1.0.1
" License: MIT

" 基础配置
set nu			" 开启行号
set tabstop=4		" Tab宽度=4空格
set shiftwidth=4	" 自动缩进宽度
"set termguicolors	" 开启真彩色
set encoding=utf-8          " Vim内部编码
set termencoding=utf-8 " 终端输出使用 UTF-8
set fileencoding=utf-8      " 文件保存编码
set fileencodings=utf-8,gbk,cp936,latin1  " 打开文件时的自动检测顺序
set wrap			" 自动换行
" set linebreak		" 整词换行

set hlsearch		" 搜索逐字符高亮和实时搜索
set incsearch
set showmatch		"显示括号配对情况

set nobackup       " 不需要备份文件
set noswapfile     " 不创建交换文件
set nowritebackup  " 编辑的时候不要备份文件
set noundofile     " 不创建撤销文件

syntax on
set hlsearch
" colorscheme desert
set nocompatible
set backspace=indent,eol,start


filetype plugin indent on

" gVim配置
set guioptions-=T	" 隐藏工具栏
set guioptions-=L	" 隐藏左侧滚动条
set guioptions-=r	" 隐藏右侧滚动条
set guioptions-=b	" 隐藏底部滚动条
set guioptions-=m

set guifont=Consolas:h20

" 加载默认配置（包括高亮等基础设置）
" source $VIMRUNTIME/defaults.vim


" 插件
call plug#begin('~/vimfiles/plugged')
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'preservim/nerdtree'			" 文件管理
Plug 'Chiel92/vim-autoformat'		" 代码格式化
Plug 'ziglang/zig.vim'
Plug 'catppuccin/vim'
call plug#end()

" colorscheme catppuccin_macchiato

" 键位设置
let mapleader=" "
" NERDTree
nnoremap <leader>e :NERDTreeToggle<CR>
nnoremap <leader>nq :NERDTreeClose<CR>
let g:NERDTreeWinSize = 30  " 设置宽度为30字符（默认31）

" 标签页
nnoremap <S-l> gt
nnoremap <S-h> gT

nnoremap <leader>bd :tabc<CR>

" Autocmd
" 不在换行时自动补全注释
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

autocmd TextYankPost * call system('xclip -selection clipboard', @")

" coc config
let g:coc_global_extensions = [
  \ 'coc-snippets',
  \ 'coc-pairs',
  \ 'coc-tsserver',
  \ 'coc-eslint', 
  \ 'coc-prettier', 
  \ 'coc-json', 
  \ 'coc-html',
  \ 'coc-clangd',
  \ 'coc-java',
  \ ]
" from readme
" if hidden is not set, TextEdit might fail.
set hidden " Some servers have issues with backup files, see #649 set nobackup set nowritebackup " Better display for messages set cmdheight=2 " You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=10

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <F2> <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
"set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

nnoremap y y
vnoremap y y
nnoremap p p
vnoremap p p


inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

" 自定义命令
:command ConfigFile :vsp $HOME/.vimrc
:command Wq :wq
:command Wqa :wqa
:command W :w
:command Q :q

set clipboard=unnamedplus  " Linux/Win (使用 + 寄存器)

" 补全框颜色设置

" 补全框（弹出菜单）颜色设置
" Pmenu：补全框整体背景和文字颜色
highlight Pmenu ctermbg=238 ctermfg=252  " 终端：背景深灰，文字浅灰
highlight Pmenu guibg=#3a3a3a guifg=#e0e0e0  " GUI：背景深灰，文字浅灰

" PmenuSel：补全框中选中项的背景和文字颜色
highlight PmenuSel ctermbg=240 ctermfg=255  " 终端：背景中灰，文字白色
highlight PmenuSel guibg=#4a4a4a guifg=#ffffff  " GUI：背景中灰，文字白色

" PmenuSbar：补全框滚动条背景（如果内容过长）
highlight PmenuSbar ctermbg=238 guibg=#3a3a3a

" PmenuThumb：补全框滚动条滑块颜色
highlight PmenuThumb ctermbg=245 guibg=#666666
