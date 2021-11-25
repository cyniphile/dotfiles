set encoding=utf-8
set hidden

set mouse=a                 " Automatically enable mouse usage
set ignorecase                  " Case insensitive search
set nu                          " Line numbers on

if has('clipboard')
   if has('unnamedplus')  " When possible use + register for copy-paste
      set clipboard=unnamed,unnamedplus
   else         " On mac and Windows, use * register for copy-paste
      set clipboard=unnamed
   endif
endif


noremap <C-_> :call NERDComment(0,"toggle")<C-m>

let mapleader = ','

" Easier moving in tabs and windows
    map <C-J> <C-W>j<C-W>_
    map <C-K> <C-W>k<C-W>_
    map <C-L> <C-W>l<C-W>_
    map <C-H> <C-W>h<C-W>_
    map ` gt
    map ~ gT
    map <C-y> <C-r> 
" Wrapped lines goes down/up to next row, rather than next line in file.
noremap j gj
noremap k gk

" Yank from the cursor to the end of the line, to be consistent with C and D.
nnoremap Y y$

" Visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

nmap <Space> bysw

" For when you forget to sudo.. Really Write the file.
cmap w!! w !sudo tee % >/dev/null

nmap zo zO

"NerdTree/CHADTree {
        "map <C-e> <plug>NERDTreeTabsToggle<CR>
        map <silent> <C-e> :CHADopen<CR>
        "map <leader>e :NERDTreeFind<CR>
"
set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor
   " Fugitive {
        nnoremap <silent> <leader>gs :Gstatus<CR>
        "nnoremap <silent> <leader>gd :Gdiff<CR>
        nnoremap <silent> <leader>gc :Gcommit<CR>
        nnoremap <silent> <leader>gb :Gblame<CR>
        nnoremap <silent> <leader>gl :Glog<CR>
        nnoremap <silent> <leader>gp :Git push<CR>
"}


" UndoTree {
        nnoremap <Leader>u :UndotreeToggle<CR>
        " If undotree is opened, it is likely one wants to interact with it.
        let g:undotree_SetFocusWhenToggle=1
" }



let g:airline_powerline_fonts=1

nmap <F5> :setlocal spell! spelllang=en_us<CR>
set nospell




au BufRead,BufNewFile *.md setlocal textwidth=80
au BufRead,BufNewFile *.markdown setlocal textwidth=80


" agvim
let g:ackprg = 'rg --vimgrep --no-heading'
let g:ag_working_path_mode = 'r'
nmap <leader>a :Ack!
    let g:ack_mappings = { 
                \ "i": "<C-W><CR><C-W>K",
                \ "s": "<C-W><CR><C-W>H<C-W>b<C-W>J<C-W>t"}


set noswapfile
set norelativenumber

"remap ,w to :w
nmap <leader>w <Esc>:w<Enter>

nmap <C-w> <Esc>:q<Enter>

" autowrite on buffer focus lost"
let g:airline_section_z = '%t'
let g:airline_section_c = ''



" sane find and replace and select all shortcut
nnoremap <leader>h yiw:%s/\<<C-r>"\>//gc<left><left><left>
nnoremap <C-A> %y

"let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1

" ripgrep 
if executable('rg')
   "Use ag over grep
  set grepprg=ag
endif


" This is the default extra key bindings
let g:fzf_action = {
  \ 'ctrl-n': 'tab split',
  \ 'ctrl-i': 'split',
  \ 'ctrl-s': 'vsplit' }
let $FZF_DEFAULT_COMMAND = 'rg --files --no-ignore --hidden --follow --glob "!.git/*"'

noremap <C-p> :FZF<CR>

call plug#begin('~/.vim/plugged')
  " Use release branch (recommend)
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'junegunn/seoul256.vim'
    "Plug 'xolox/vim-misc'
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'airblade/vim-rooter'
    Plug 'vim-airline/vim-airline'
    Plug 'airblade/vim-gitgutter'
    Plug 'mileszs/ack.vim'
    Plug 'mbbill/undotree'
    Plug 'tpope/vim-fugitive'
    Plug 'gcmt/wildfire.vim'
    Plug 'zaiste/tmux.vim'
    Plug 'scrooloose/nerdcommenter'
    Plug 'edkolev/tmuxline.vim'
    Plug 'tpope/vim-surround'
    Plug 'tmux-plugins/vim-tmux-focus-events'
    Plug 'junegunn/fzf'
    Plug 'junegunn/fzf.vim'
    Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}
    Plug 'ryanoasis/vim-devicons'
call plug#end()


" remap search key
nmap <silent> <leader>dd :call CocAction('jumpDefinition', 'tab drop')<CR>
nmap <silent> <leader>ds :call CocAction('jumpDefinition', 'vsplit')<CR>
" Symbol renaming.
nmap <leader>r <Plug>(coc-rename)
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent><F8> <Plug>(coc-diagnostic-next)

" Use K to show documentation in preview window.
nnoremap <silent>gh :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction


" Remap <C-i> and <C-u> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-i> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-i>"
  nnoremap <silent><nowait><expr> <C-u> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-u>"
  inoremap <silent><nowait><expr> <C-i> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-u> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-i> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-i>"
  vnoremap <silent><nowait><expr> <C-u> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-u>"
endif



"Use <Tab> and <S-Tab> to navigate the completion list:
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

"To make <cr> select the first completion item and confirm the completion when no item has been selected:
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Restore cursor to file position in previous editing session
function! ResCur()
        if line("'\"") <= line("$")
            normal! g`"
                return 1
        endif
   endfunction

augroup resCur
    autocmd!
    autocmd BufWinEnter * call ResCur()
augroup END


let NERDTreeIgnore=['\.o$', '\~$', '__pycache__[[dir]]', '.pytest_cache[[dir]]', '.idea', '.mypy_cache[[dir]]',  '.git[[dir]]']

" See `:echo g:airline_theme_map` for some more choices
" Default in terminal vim is 'dark'
if isdirectory(expand("~/.vim/bundle/vim-airline/"))
    if !exists('g:airline_theme')
        let g:airline_theme = 'solarized'
    endif
    if !exists('g:airline_powerline_fonts')
        " Use the default set of separators with a few customizations
        let g:airline_left_sep='›'  " Slightly fancier than '>'
        let g:airline_right_sep='‹' " Slightly fancier than '<'
    endif
endif
let g:airline#extensions#tmuxline#enabled = 0


" cursor shape adjuster for iterm: https://gist.github.com/andyfowler/1195581
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

autocmd ColorScheme * hi Visual ctermfg=NONE ctermbg=DarkGrey
autocmd ColorScheme * hi Normal ctermbg=234 cterm=NONE
autocmd ColorScheme * hi LineNr ctermfg=102 ctermbg=235
autocmd ColorScheme * hi Normal ctermbg=none
autocmd ColorScheme * set cursorline                  " Highlight current line
autocmd ColorScheme * hi CursorLine   cterm=NONE ctermbg=234
autocmd ColorScheme * highlight clear SignColumn      " SignColumn should match background
autocmd ColorScheme * hi Search ctermfg=102 ctermbg=LightGrey 
autocmd ColorScheme * hi Comment ctermfg=DarkGrey


colorscheme seoul256

"use register 1, a little easier to type than just typing "1
map <leader>f "1

" set fold color so as not to confuse with window border
hi Folded ctermbg=16
hi Folded ctermfg=DarkGrey

"max charwidth indicator
highlight ColorColumn ctermbg=235
call matchadd('ColorColumn', '\%81v', 100)
