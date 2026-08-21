set nowrap
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
noremap <silent> j gj
noremap <silent> k gk

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
	map <F2> chadtree_settings.
        map <silent> <C-e> :CHADopen<CR>
        "map <leader>e :NERDTreeFind<CR>
	"
	let g:chadtree_settings = {
			\'theme.text_colour_set': "nord",
			\'theme.icon_colour_set': "github",
			\'keymap.rename': ["<F2>"]
		  \ }

"make git commands work with gitgui
let g:neoterm_autoinsert=1
set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor
        nnoremap <silent> <leader>gs :Gstatus<CR>
        "nnoremap <silent> <leader>gd :Gdiff<CR>
        nnoremap <silent> <leader>gc :T gs<CR>
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


" Prose: soft-wrap at word boundaries, continuing at the line's own indent
" (list items align under their text) plus a marker so a wrap reads as a wrap.
" Reflowing with gq/gw falls back to a hard 79-column cap when 'textwidth' is 0,
" so track the window's text area instead. 't' comes out of 'formatoptions' so
" typing still only soft-wraps; nothing hard-wraps until an explicit gq.
let s:prose_filetypes = ['markdown', 'vimwiki', 'text']

function! s:ProseTextwidth() abort
    if index(s:prose_filetypes, &filetype) < 0
        return
    endif
    " winwidth() counts the number/sign/fold gutters; textoff is their width.
    let l:info = getwininfo(win_getid())
    let l:gutter = empty(l:info) ? 0 : get(l:info[0], 'textoff', 0)
    let &l:textwidth = max([40, winwidth(0) - l:gutter])
endfunction

augroup prose_wrap
    autocmd!
    autocmd FileType markdown,vimwiki,text setlocal wrap linebreak breakindent breakindentopt=list:-1,shift:2,sbr
    autocmd FileType markdown,vimwiki,text setlocal formatoptions-=t formatoptions-=a
    autocmd FileType markdown,vimwiki,text let &l:showbreak = '↳ '
    autocmd FileType markdown,vimwiki,text let &l:formatlistpat = '^\s*[-*+]\s\+\|^\s*\d\+[.)]\s\+'
    " Hide link plumbing: [text](url) collapses to text, and a bare URL keeps its
    " first g:markdown_url_keep characters then '…' (nvim/after/syntax/markdown.vim).
    " 'concealcursor' stays empty, so the line under the cursor reveals the raw text.
    autocmd FileType markdown,vimwiki setlocal conceallevel=2 concealcursor=
    autocmd FileType markdown,vimwiki,text call s:ProseTextwidth()
    autocmd VimResized,WinEnter,BufWinEnter * call s:ProseTextwidth()
augroup END

" agvim/ripgrep
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

"close windows like in vscode
nmap <C-w> <Esc>:q<Enter>
" nvim 0.10+ ships default <C-w>d / <C-w><C-d> diagnostic-float mappings; they
" share the <C-w> prefix, making the map above wait out 'timeoutlen' (1s).
" Diagnostics come from coc here, so drop the defaults to close instantly.
silent! nunmap <C-w>d
silent! nunmap <C-w><C-d>

" VS Code parity: Cmd+Opt+C yanks the file's full path (copyFilePath).
" A terminal has no Cmd key of its own, so iTerm2's Hotkey profile maps the
" chord to the escape sequence "[99;11u" - CSI-u for 'c' (99) held with
" super+alt (1+8+2) - which nvim decodes as <D-M-c>. Send further Cmd chords
" the same way rather than as hex codes: a hex code spends a Ctrl key that
" nvim then cannot use for anything else.
function! s:CopyPath(modifier) abort
    if empty(bufname('%'))
        echohl WarningMsg | echo 'No file name' | echohl NONE
        return
    endif
    let l:path = expand('%' . a:modifier)
    let @+ = l:path
    let @* = l:path
    echo l:path
endfunction

nnoremap <silent> <D-M-c> :call <SID>CopyPath(':p')<CR>
inoremap <silent> <D-M-c> <C-o>:call <SID>CopyPath(':p')<CR>

" Cmd+Opt+Shift+C yanks the path relative to the working directory
" (copyRelativeFilePath). vim-rooter holds that at the project root, so it
" reads like VS Code's workspace-relative path. nvim folds Shift into the
" letter's case, so this chord is <D-M-C>, never <D-M-S-c>.
nnoremap <silent> <D-M-C> :call <SID>CopyPath(':.')<CR>
inoremap <silent> <D-M-C> <C-o>:call <SID>CopyPath(':.')<CR>

" Cmd+S writes the buffer, and from insert mode leaves you still typing.
nnoremap <silent> <D-s> :w<CR>
inoremap <silent> <D-s> <C-o>:w<CR>

" Cmd+F searches the buffer; Cmd+Shift+F searches the tree with Ack.
nnoremap <D-f> /
inoremap <D-f> <Esc>/
nnoremap <D-F> :Ack!<Space>



" autowrite on buffer focus lost"
let g:airline_section_z = '%t'
let g:airline_section_c = ''

" sane find and replace and select all shortcut
nnoremap <leader>h yiw:%s/\<<C-r>"\>//gc<left><left><left>
nnoremap <C-A> %y

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
let $FZF_DEFAULT_COMMAND = 'fd --type f --hidden --follow --exclude .git'

noremap <C-p> :FZF<CR>

call plug#begin('~/.vim/plugged')
    Plug 'kassio/neoterm'
    Plug 'numToStr/Comment.nvim'

    "Plug 'dccsillag/magma-nvim', { 'do': ':UpdateRemotePlugins' }
    " Use release branch (recommend)
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'junegunn/seoul256.vim'
    "Plug 'xolox/vim-misc'
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'airblade/vim-rooter'
    Plug 'vim-airline/vim-airline'
    if has('nvim') || has('patch-8.0.902')
	 Plug 'mhinz/vim-signify'
    else
	 Plug 'mhinz/vim-signify', { 'branch': 'legacy' }
    endif
    Plug 'github/copilot.vim'
    Plug 'godlygeek/tabular'
    Plug 'preservim/vim-markdown'
    Plug 'mileszs/ack.vim'
    Plug 'mbbill/undotree'
    Plug 'tpope/vim-fugitive'
    Plug 'gcmt/wildfire.vim'
    Plug 'zaiste/tmux.vim'
    Plug 'edkolev/tmuxline.vim'
    Plug 'tpope/vim-surround'
    Plug 'tmux-plugins/vim-tmux-focus-events'
    Plug 'junegunn/fzf'
    Plug 'junegunn/fzf.vim'
    Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}
    Plug 'ryanoasis/vim-devicons'
    Plug '3rd/image.nvim' 
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'HakonHarnes/img-clip.nvim'


call plug#end()

" map a key to paste from the clipboard
nnoremap <leader>p :PasteImage<CR>


" Somewhere after plug#end()

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



" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

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

set termguicolors
au ColorScheme * hi Normal ctermbg=none guibg=none
autocmd ColorScheme * hi Visual ctermfg=NONE ctermbg=DarkGrey
autocmd ColorScheme * hi Visual guifg=NONE guibg=DarkGrey
autocmd ColorScheme * hi Normal ctermbg=234 cterm=NONE
autocmd ColorScheme * hi Normal guibg=234 cterm=NONE
autocmd ColorScheme * hi LineNr ctermfg=102 ctermbg=235 guifg=Grey40 guibg=none
autocmd ColorScheme * set cursorline                  " Highlight current line
autocmd ColorScheme * hi CursorLine   cterm=NONE ctermbg=234
autocmd ColorScheme * hi clear SignColumn      " SignColumn should match background
autocmd ColorScheme * highlight SignifySignAdd    ctermfg=green  guifg=#00ff00 cterm=NONE guibg=NONE
autocmd ColorScheme * highlight SignifySignDelete ctermfg=red    guifg=#ff0000 cterm=NONE guibg=NONE
autocmd ColorScheme * highlight SignifySignChange ctermfg=yellow guifg=#ffff00 cterm=NONE guibg=NONE

noremap <C-_>  <Plug>(comment_toggle_linewise_current)

" image.nvim config (Lua) — use ueberzug++ for iTerm2
lua << EOF
require('Comment').setup()

require("image").setup({
  backend = "kitty",                 -- use Kitty Graphics Protocol (iTerm2 understands it)
  processor = "magick_cli",          -- use ImageMagick CLI; no LuaRocks needed
  integrations = {
    markdown = {
      enabled = true,                -- render ![alt](path) inline
      clear_in_insert_mode = false,
      download_remote_images = true, -- fetch http(s) images on the fly
      only_render_image_at_cursor = true, -- set true if you want a lighter mode
      only_render_image_at_cursor_mode = "inline",
      filetypes = { "markdown", "vimwiki" },
    },
  },
  max_height_window_percentage = 50, -- scale to half the window height
  hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
})


require('img-clip').setup({
  default = {
    dir_path = function()
      local dir = vim.fn.expand('~/Downloads/md-images')
      vim.fn.mkdir(dir, 'p')
      return dir
    end,
    use_absolute_path = true,     -- make image.nvim path resolution simple
    prompt_for_file_name = false, -- auto-name by timestamp
    verbose = false,              -- keep messages quiet
  },
  filetypes = {
    markdown = {
      url_encode_path = true,     -- so spaces/() are safe in Markdown
      template = "![$CURSOR]($FILE_PATH)",
    },
  },
})

-- Detect if system clipboard currently contains an image (macOS).
-- We check Pasteboard types via AppleScript: 'clipboard info' lists flavors such as
-- 'TIFF picture', 'JPEG picture', and «class PNGf».
local function clipboard_has_image()
  -- macOS only; return false on other OSes
  if vim.loop.os_uname().sysname ~= 'Darwin' then return false end
  local ok, out = pcall(vim.fn.systemlist, {'osascript', '-e', 'clipboard info'})
  if not ok then return false end
  local s = table.concat(out or {}, ' ')
  -- Common image flavors on macOS Pasteboard
  return s:find('TIFF picture') or s:find('JPEG picture') or s:find('GIF picture') or s:find('PNGf')
end

-- Smart paste:
-- If clipboard has an image AND we are in Markdown-like buffers, use img-clip.
-- Otherwise, fall back to the normal paste handler.
-- This overrides bracketed-paste (e.g., ⌘V in iTerm2).
local markdown_like = { markdown = true, mdx = true, vimwiki = true }
vim.paste = (function(overridden)
  return function(lines, phase)
    if (phase == -1 or phase == 1) and markdown_like[vim.bo.filetype] and clipboard_has_image() then
      local ok, imgclip = pcall(require, 'img-clip')
      if ok then
        imgclip.paste_image()         -- uses our setup() defaults
        -- Cancel the default text paste; this is the documented behavior of vim.paste.
        -- See :h vim.paste (“return false if client should cancel the paste”).
        return false
      end
    end
    return overridden(lines, phase)
  end
end)(vim.paste)


EOF

colorscheme seoul256

"use register 1, a little easier to type than just typing "1
map <leader>f "1

" set fold color so as not to confuse with window border
hi Folded ctermbg=16
hi Folded ctermfg=DarkGrey

au FileType python let b:coc_root_patterns = ['.git', '.env', 'venv', '.venv', 'setup.cfg', 'setup.py', 'pyrightconfig.json']

"max charwidth indicator
highlight ColorColumn ctermbg=235
call matchadd('ColorColumn', '\%81v', 100)

set rtp^="/Users/luke/.opam/default/share/ocp-indent/vim"


" Visual mode: Tab to indent, Shift-Tab to unindent, and stay in Visual mode
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

"  overwrite `s` to mean “surround the word under cursor”
nnoremap s <Plug>Ysurroundiw

" In visual mode, Space moves to the end of the current line
vnoremap <Space> $h
