set nocompatible        " Must be first line
set background=dark         " Assume a dark background
filetype plugin indent on   " Automatically detect file types.
syntax on                   " Syntax highlighting
set mouse=a                 " Automatically enable mouse usage
set mousehide               " Hide the mouse cursor while typing

" autopep8 shortcut mapping
autocmd FileType python noremap <buffer> <F8> :call Autopep8()<CR>
" option to ignore certin pep8 rules
 "let g:autopep8_ignore="E501,W293"

scriptencoding utf-8

if has('clipboard')
   if has('unnamedplus')  " When possible use + register for copy-paste
      set clipboard=unnamed,unnamedplus
   else         " On mac and Windows, use * register for copy-paste
      set clipboard=unnamed
   endif
endif

" Most prefer to automatically switch to the current file directory when
" a new buffer is opened; to prevent this behavior
autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif
set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
set virtualedit=onemore             " Allow for cursor beyond last character
set history=1000                    " Store a ton of history (default is 20)
set hidden                          " Allow buffer switching without saving
set iskeyword-=.                    " '.' is an end of word designator
set iskeyword-=#                    " '#' is an end of word designator
set iskeyword-=-                    " '-' is an end of word designator
set shortmess=aoOtIFT               " Abbrev. of messages (avoids 'hit enter')

" Instead of reverting the cursor to the last position in the buffer, we
" set it to the first line when editing a git commit message
au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

" http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
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

" Setting up the directories {
set backup                  " Backups are nice ...
if has('persistent_undo')
    set undofile                " So is persistent undo ...
    set undolevels=1000         " Maximum number of changes that can be undone
    set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
endif

" Add exclusions to mkview and loadview
" eg: *.*, svn-commit.tmp
let g:skipview_files = [
     \ '\[example pattern\]'
     \ ]

set tabpagemax=15               " Only show 15 tabs
set showmode                    " Display the current mode


if has('statusline')
    set laststatus=2
    " Broken down into easily includeable segments
    set statusline=%<%f\                     " Filename
    set statusline+=%w%h%m%r                 " Options
    set statusline+=%{fugitive#statusline()} " Git Hotness
    set statusline+=\ [%{&ff}/%Y]            " Filetype
    set statusline+=\ [%{getcwd()}]          " Current dir
    set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
endif

set backspace=indent,eol,start  " Backspace for dummies
set linespace=0                 " No extra spaces between rows
set nu                          " Line numbers on
set showmatch                   " Show matching brackets/parenthesis
set incsearch                   " Find as you type search
set hlsearch                    " Highlight search terms
set winminheight=0              " Windows can be 0 line high
set ignorecase                  " Case insensitive search
set smartcase                   " Case sensitive when uc present
set wildmenu                    " Show list instead of just completing
set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
set scrolljump=5                " Lines to scroll when cursor leaves screen
set scrolloff=3                 " Minimum lines to keep above and below cursor
set foldenable                  " Auto fold code
set list
set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace

set autoindent                  " Indent at the same level of the previous line
set shiftwidth=4                " Use indents of 4 spaces
set expandtab                   " Tabs are spaces, not tabs
set tabstop=4                   " An indentation every four columns
set softtabstop=4               " Let backspace delete indent
set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
set splitright                  " Puts new vsplit windows to the right of the current
set splitbelow                  " Puts new split windows to the bottom of the current
" Remove trailing whitespaces and ^M chars
" To disable the stripping of whitespace, add the following to your
autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,perl autocmd BufWritePre <buffer> call StripTrailingWhitespace()


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

" End/Start of line motion keys act relative to row/wrap width in the
" presence of `:set wrap`, and relative to line for `:set nowrap`.
" Same for 0, home, end, etc
function! WrapRelativeMotion(key, ...)
    let vis_sel=""
    if a:0
        let vis_sel="gv"
    endif
    if &wrap
        execute "normal!" vis_sel . "g" . a:key
    else
        execute "normal!" vis_sel . a:key
    endif
endfunction

" Map g* keys in Normal, Operator-pending, and Visual+select
noremap $ :call WrapRelativeMotion("$")<CR>
noremap <End> :call WrapRelativeMotion("$")<CR>
noremap 0 :call WrapRelativeMotion("0")<CR>
noremap <Home> :call WrapRelativeMotion("0")<CR>
noremap ^ :call WrapRelativeMotion("^")<CR>
" Overwrite the operator pending $/<End> mappings from above
" to force inclusive motion with :execute normal!
onoremap $ v:call WrapRelativeMotion("$")<CR>
onoremap <End> v:call WrapRelativeMotion("$")<CR>
" Overwrite the Visual+select mode mappings from above
" to ensure the correct vis_sel flag is passed to function
vnoremap $ :<C-U>call WrapRelativeMotion("$", 1)<CR>
vnoremap <End> :<C-U>call WrapRelativeMotion("$", 1)<CR>
vnoremap 0 :<C-U>call WrapRelativeMotion("0", 1)<CR>
vnoremap <Home> :<C-U>call WrapRelativeMotion("0", 1)<CR>
vnoremap ^ :<C-U>call WrapRelativeMotion("^", 1)<CR>

" The following two lines conflict with moving to top and
" bottom of the screen
map <S-H> gT
map <S-L> gt

" Stupid shift key fixes
if has("user_commands")
    command! -bang -nargs=* -complete=file E e<bang> <args>
    command! -bang -nargs=* -complete=file W w<bang> <args>
    command! -bang -nargs=* -complete=file Wq wq<bang> <args>
    command! -bang -nargs=* -complete=file WQ wq<bang> <args>
    command! -bang Wa wa<bang>
    command! -bang WA wa<bang>
    command! -bang Q q<bang>
    command! -bang QA qa<bang>
    command! -bang Qa qa<bang>
endif

cmap Tabe tabe

" Yank from the cursor to the end of the line, to be consistent with C and D.
nnoremap Y y$

" Code folding options
nmap <leader>f0 :set foldlevel=0<CR>
nmap <leader>f1 :set foldlevel=1<CR>
nmap <leader>f2 :set foldlevel=2<CR>
nmap <leader>f3 :set foldlevel=3<CR>
nmap <leader>f4 :set foldlevel=4<CR>
nmap <leader>f5 :set foldlevel=5<CR>
nmap <leader>f6 :set foldlevel=6<CR>
nmap <leader>f7 :set foldlevel=7<CR>
nmap <leader>f8 :set foldlevel=8<CR>
nmap <leader>f9 :set foldlevel=9<CR>

" Most prefer to toggle search highlighting rather than clear the current
" search results. 
nmap <silent> <leader>/ :set invhlsearch<CR>





" Visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

" Allow using the repeat operator with a visual selection (!)
" http://stackoverflow.com/a/8064607/127816
vnoremap . :normal .<CR>

" For when you forget to sudo.. Really Write the file.
cmap w!! w !sudo tee % >/dev/null

" Adjust viewports to the same size
map <Leader>= <C-w>=

" Map <Leader>ff to display all lines with keyword under cursor
" and ask which one to jump to
nmap <Leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>


" Misc {
    if isdirectory(expand("~/.vim/bundle/nerdtree"))
        let g:NERDShutUp=1
    endif
" }

    " Ctags {
    set tags=./tags;/,~/.vimtags

    " Make tags placed in .git/tags file available in all levels of a repository
    let gitroot = substitute(system('git rev-parse --show-toplevel'), '[\n\r]', '', 'g')
    if gitroot != ''
        let &tags = &tags . ',' . gitroot . '/.git/tags'
    endif
" }

noremap <C-_> :call NERDComment(0,"toggle")<C-m>

 "NerdTree {
    if isdirectory(expand("~/.vim/bundle/nerdtree"))
        map <C-e> <plug>NERDTreeTabsToggle<CR>
        map <leader>e :NERDTreeFind<CR>
        nmap <leader>nt :NERDTreeFind<CR>

        let NERDTreeShowBookmarks=1
        let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
        let NERDTreeChDirMode=0
        let NERDTreeQuitOnOpen=1
        let NERDTreeMouseMode=2
        let NERDTreeShowHidden=1
        let NERDTreeKeepTreeInNewTab=1
        let g:nerdtree_tabs_open_on_gui_startup=0
    endif
" }
set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor
   
" agvim
    let g:ack_mappings = { 
                \ "i": "<C-W><CR><C-W>K",
                \ "s": "<C-W><CR><C-W>H<C-W>b<C-W>J<C-W>t"}

" Fugitive {
    if isdirectory(expand("~/.vim/bundle/vim-fugitive/"))
        nnoremap <silent> <leader>gs :Gstatus<CR>
        nnoremap <silent> <leader>gd :Gdiff<CR>
        nnoremap <silent> <leader>gc :Gcommit<CR>
        nnoremap <silent> <leader>gb :Gblame<CR>
        nnoremap <silent> <leader>gl :Glog<CR>
        nnoremap <silent> <leader>gp :Git push<CR>
        nnoremap <silent> <leader>gr :Gread<CR>
        nnoremap <silent> <leader>gw :Gwrite<CR>
        nnoremap <silent> <leader>ge :Gedit<CR>
        " Mnemonic _i_nteractive
        nnoremap <silent> <leader>gi :Git add -p %<CR>
        nnoremap <silent> <leader>gg :SignifyToggle<CR>
    endif
"}


" UndoTree {
    if isdirectory(expand("~/.vim/bundle/undotree/"))
        nnoremap <Leader>u :UndotreeToggle<CR>
        " If undotree is opened, it is likely one wants to interact with it.
        let g:undotree_SetFocusWhenToggle=1
    endif
" }

" Wildfire {
let g:wildfire_objects = {
            \ "*" : ["i'", 'i"', "i)", "i]", "i}", "ip"],
            \ "html,xml" : ["at"],
            \ }
" }



" Functions {

    " Initialize directories {
    function! InitializeDirectories()
        let parent = $HOME
        let prefix = 'vim'
        let dir_list = {
                    \ 'backup': 'backupdir',
                    \ 'views': 'viewdir',
                    \ 'swap': 'directory' }

        if has('persistent_undo')
            let dir_list['undo'] = 'undodir'
        endif
        let common_dir = parent . '/.' . prefix

        for [dirname, settingname] in items(dir_list)
            let directory = common_dir . dirname . '/'
            if exists("*mkdir")
                if !isdirectory(directory)
                    call mkdir(directory)
                endif
            endif
            if !isdirectory(directory)
                echo "Warning: Unable to create backup directory: " . directory
                echo "Try: mkdir -p " . directory
            else
                let directory = substitute(directory, " ", "\\\\ ", "g")
                exec "set " . settingname . "=" . directory
            endif
        endfor
    endfunction
    call InitializeDirectories()
    " }

    " Initialize NERDTree as needed {
    function! NERDTreeInitAsNeeded()
        redir => bufoutput
        buffers!
        redir END
        let idx = stridx(bufoutput, "NERD_tree")
        if idx > -1
            NERDTreeMirror
            NERDTreeFind
            wincmd l
        endif
    endfunction
    " }

    " Strip whitespace {
    function! StripTrailingWhitespace()
        " Preparation: save last search, and cursor position.
        let _s=@/
        let l = line(".")
        let c = col(".")
        " do the business:
        %s/\s\+$//e
        " clean up: restore previous search history, and cursor position
        let @/=_s
        call cursor(l, c)
    endfunction
    " }

    " Shell command {
    function! s:RunShellCommand(cmdline)
        botright new

        setlocal buftype=nofile
        setlocal bufhidden=delete
        setlocal nobuflisted
        setlocal noswapfile
        setlocal nowrap
        setlocal filetype=shell
        setlocal syntax=shell

        call setline(1, a:cmdline)
        call setline(2, substitute(a:cmdline, '.', '=', 'g'))
        execute 'silent $read !' . escape(a:cmdline, '%#')
        setlocal nomodifiable
        1
    endfunction

    command! -complete=file -nargs=+ Shell call s:RunShellCommand(<q-args>)
    " e.g. Grep current file for <search_term>: Shell grep -Hn <search_term> %
    " }

" }
"

set t_Co=256

let g:airline_powerline_fonts=1

"misc other
set gdefault
nmap <F5> :setlocal spell! spelllang=en_us<CR>
set nospell
"python with virtualenv support
py << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
  project_base_dir = os.environ['VIRTUAL_ENV']
  activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
  execfile(activate_this, dict(__file__=activate_this))
EOF

"jedi vim
autocmd FileType python setlocal completeopt-=preview
"let g:jedi#goto_assignments_command = "<leader>g"
"let g:jedi#goto_definitions_command = "<leader>d"
"let g:jedi#usages_command = "<leader>n"
"let g:jedi#completions_command = "<C-Space>"
"let g:jedi#rename_command = "<leader>r"
let g:jedi#popup_on_dot = 0
let g:jedi#completions_enabled = 0
let g:ycm_server_python_interpreter = '/usr/bin/python3'
let g:ycm_semantic_triggers = {'python': ['re!from\s+\S+\s+import\s']}
"let g:deoplete#sources#jedi#python_path = '/usr/bin/python3'
"let g:ycm_python_binary_path = '/usr/bin/python3'

" Point YCM to the Pipenv created virtualenv, if possible
" At first, get the output of 'pipenv --venv' command.
let pipenv_venv_path = system('pipenv --venv')
" The above system() call produces a non zero exit code whenever
" a proper virtual environment has not been found.
" So, second, we only point YCM to the virtual environment when
" the call to 'pipenv --venv' was successful.
" Remember, that 'pipenv --venv' only points to the root directory
" of the virtual environment, so we have to append a full path to
" the python executable.
if shell_error == 0
  let venv_path = substitute(pipenv_venv_path, '\n', '', '')
  let g:ycm_python_binary_path = venv_path . '/bin/python'
else
  let g:ycm_python_binary_path = 'python'
endif

autocmd Filetype python nnoremap <leader>b oimport ipdb; ipdb.set_trace()<Esc>
autocmd Filetype ruby nnoremap <leader>b orequire 'byebug'; byebug<Esc>

au BufRead,BufNewFile *.md setlocal textwidth=80
au BufRead,BufNewFile *.markdown setlocal textwidth=80


let g:ackprg = 'ag --nogroup --nocolor --column'
let g:ag_working_path_mode = 'r'

set noswapfile
set norelativenumber

"remap ,w to :w
nmap <leader>w <Esc>:w<Enter>
nmap <leader>j <Esc>:q<Enter>
nmap <leader>a :Ack!

"resize window alias
nmap + <C-w>+
nmap - <C-w>-

" autowrite on buffer focus lost"
let g:airline_section_z = '%t'
let g:airline_section_c = ''


set wrap
set linebreak
set nolist  " list disables linebreak
set textwidth=0
set wrapmargin=0


filetype plugin indent on
syntax enable


let test#python#runner = 'pytest'
let test#strategy = "dispatch"
nmap <silent> <leader>T :TestNearest --pdb<CR>
nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>f :TestFile<CR>
nmap <silent> <leader>F :TestFile --pdb<CR>
nmap <silent> <leader>s :TestSuite<CR>
nmap <silent> <leader>S :TestSuite --pdb<CR>
nmap <silent> <leader>l :TestLast<CR>
nmap <silent> <leader>G :TestVisit<CR>

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

set nocompatible              " be iMproved, required
filetype off                  " required

"clostag.vim
" filenames like *.xml, *.html, *.xhtml, ...
let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*.html.erb,*.xml"

"mypy for ale
let g:ale_python_mypy_options = '--ignore-missing-imports'

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
    " alternatively, pass a path where Vundle should install plugins
    "call vundle#begin('~/some/path/here')
    Plugin 'VundleVim/Vundle.vim'
    Plugin 'xolox/vim-misc'
    Plugin 'christoomey/vim-tmux-navigator'
    Plugin 'stephpy/vim-yaml'
    Plugin 'Vimjas/vim-python-pep8-indent'
    Plugin 'othree/html5.vim'
    Plugin 'valloric/matchtagalways'
    Plugin 'alvan/vim-closetag'
    Plugin 'davidhalter/jedi-vim'
    Plugin 'mustache/vim-mustache-handlebars'
    Plugin 'vim-ruby/vim-ruby'
    Plugin 'vim-airline/vim-airline-themes'
    Plugin 'Valloric/YouCompleteMe'
    Plugin 'tpope/vim-obsession'
    Plugin 'airblade/vim-rooter'
    Plugin 'janko-m/vim-test'
    Plugin 'tpope/vim-dispatch'
    Plugin 'vim-airline/vim-airline'
    Plugin 'flazz/vim-colorschemes'
    Plugin 'airblade/vim-gitgutter'
    Plugin 'scrooloose/nerdtree'
    Plugin 'mileszs/ack.vim'
    Plugin 'gmarik/vundle'
    Plugin 'mbbill/undotree'
    Plugin 'tpope/vim-fugitive'
    Plugin 'tpope/vim-rails'
    "Plugin 'tpope/vim-markdown'
    Plugin 'gcmt/wildfire.vim'
    Plugin 'altercation/vim-colors-solarized'
    Plugin 'zaiste/tmux.vim'
    Plugin 'jistr/vim-nerdtree-tabs'
    Plugin 'scrooloose/nerdcommenter'
    Plugin 'edkolev/tmuxline.vim'
    Plugin 'chun-yang/auto-pairs'
    Plugin 'kchmck/vim-coffee-script'
    Plugin 'tpope/vim-surround'
    Plugin 'pangloss/vim-javascript'
    Plugin 'othree/javascript-libraries-syntax.vim'
    Plugin 'mxw/vim-jsx'
    Plugin 'jmcantrell/vim-virtualenv'
    Plugin 'tmux-plugins/vim-tmux-focus-events'
    Plugin 'tell-k/vim-autopep8'
    Plugin 'junegunn/fzf'
    Plugin 'junegunn/fzf.vim'
    Plugin 'w0rp/ale'
    Plugin 'Xuyuanp/nerdtree-git-plugin'
    Plugin 'plasticboy/vim-markdown'
call vundle#end()            " required
let g:deoplete#enable_at_startup = 1
filetype plugin indent on    " required

" http://stackoverflow.com/a/21687112
let loaded_netrwPlugin=1           
let NERDTreeIgnore=['\.o$', '\~$', '__pycache__[[dir]]', '.pytest_cache[[dir]]', '.idea', '.mypy_cache[[dir]]',  '.git[[dir]]']
"autorefresh nerdtree https://askubuntu.com/questions/523822/vim-nerdtree-auto-fresh-the-directory-pane
"autocmd CursorHold,CursorHoldI * call NERDTreeFocus() | call g:NERDTree.ForCurrentTab().getRoot().refresh() | call g:NERDTree.ForCurrentTab().render() | wincmd w

if filereadable(expand("~/.vim/bundle/vim-colors-solarized/colors/solarized.vim"))
    let g:solarized_termcolors=256
    let g:solarized_termtrans=1
    let g:solarized_contrast="normal"
    let g:solarized_visibility="normal"
endif
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

" ocaml
set rtp+=/home/cyniphile/.opam/4.02.3/share/merlin/vim
"let g:syntastic_ocaml_checkers = ['merlin']
let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
execute "set rtp+=" . g:opamshare . "/merlin/vim"
" end ocaml

autocmd Filetype html setlocal tabstop=2 shiftwidth=2 expandtab
autocmd Filetype ruby setlocal tabstop=2 shiftwidth=2 expandtab
autocmd Filetype javascript setlocal tabstop=2 shiftwidth=2 expandtab
autocmd InsertEnter,InsertLeave * set cul!

set showcmd                 " Show partial commands in status line and


autocmd ColorScheme * hi Visual ctermfg=NONE ctermbg=DarkGrey
autocmd ColorScheme * hi Normal ctermbg=234 cterm=NONE
autocmd ColorScheme * hi LineNr ctermfg=102 ctermbg=235
autocmd ColorScheme * hi Normal ctermbg=none
autocmd ColorScheme * set cursorline                  " Highlight current line
autocmd ColorScheme * hi CursorLine   cterm=NONE ctermbg=234
autocmd ColorScheme * highlight clear SignColumn      " SignColumn should match background
autocmd ColorScheme * hi Search ctermfg=102 ctermbg=LightGrey 
autocmd ColorScheme * hi Comment ctermfg=DarkGrey
"max charwidth indicator
let &colorcolumn=join(range(81,81),",")
autocmd ColorScheme * hi ColorColumn ctermbg=235
colorscheme seoul256
"colorscheme monokain
