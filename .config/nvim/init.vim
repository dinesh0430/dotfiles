"" vim-plug: Plugin repository lines
call plug#begin('~/.config/nvim/plugged')

" Colorscheme onehalf
Plug 'sonph/onehalf', {'rtp': 'vim/'}

" Colorscheme onedark
Plug 'joshdick/onedark.vim'

" Colorscheme dracula
Plug 'dracula/vim', { 'as': 'dracula' }

" Airline
Plug 'vim-airline/vim-airline'
" Airline Themes
Plug 'vim-airline/vim-airline-themes'

" Add nerd-font support to vim
Plug 'ryanoasis/vim-devicons'

" To improve syntax highlighting
Plug 'sheerun/vim-polyglot'

" To use completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" To use ctrl-space for tab, buffer and session management
Plug 'vim-ctrlspace/vim-ctrlspace'

" Quikscope
Plug 'unblevable/quick-scope'

" Sandwich vim
Plug 'machakann/vim-sandwich'

" Targets to give additional text objects
Plug 'wellle/targets.vim'

" Repeat for plugins
Plug 'tpope/vim-repeat'

" Plugin to efficiently move
Plug 'easymotion/vim-easymotion'

" Plugin to fuzzy search with incremental searching
Plug 'haya14busa/incsearch-fuzzy.vim'

" fzf
Plug 'junegunn/fzf',  { 'dir': '~/.fzf' }
Plug 'junegunn/fzf.vim'

" To show indent characters
Plug 'Yggdroot/indentLine'

" Plugin to use undo in a tree like structure
Plug 'simnalamburt/vim-mundo'

" Plugin to NERDTree
Plug 'preservim/nerdtree' , { 'on': 'NERDTreeToggle' }

" Plugin to use github commands in vim
Plug 'tpope/vim-fugitive'

" Compile single source files
Plug 'xuhdev/SingleCompile'

" Plugin to show git signs on gutter
"Plug 'mhinz/vim-signify'

" Plugin to integrate ripgrep searches with vim quickfix list
"Plug 'mileszs/ack.vim'

" Plugin to show git changes
Plug 'airblade/vim-gitgutter'

" Plugin to see key bindings in popup
Plug 'liuchengxu/vim-which-key'

" Plugin to use ranger in neovim
Plug 'kevinhwang91/rnvimr'

" Plugin to create github gists
Plug 'mattn/vim-gist'
Plug 'mattn/webapi-vim'

" Plugin to use multiple cursor
Plug 'mg979/vim-visual-multi'

" Plugin to use coc with fzf
Plug 'antoinemadec/coc-fzf'

" Plugin to use line text objects
Plug 'vim-utils/vim-line'

call plug#end()


"" general vim settings

"""" cursor-settings: for getting blink to work and changing cursor depending on the mode
autocmd VimEnter * silent !echo -ne "\e[3 q"
autocmd VimLeave * silent !echo -ne "\e[3 q"
autocmd VimLeave * let &t_me="\<Esc>]50;CursorShape=1\x7"
autocmd VimLeave * call system('printf "\e[5 q" > $TTY')

" Change the cursor behaviour
set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
            \,a:blinkwait700-blinkoff400-blinkon250-Cursor
            \,sm:block-blinkwait175-blinkoff150-blinkon175

" To set the cursor back to bar while exiting neovim
au VimLeave * set guicursor=a:ver25-blinkon250

" To remove trailing white spaces before writing the buffer to disk
autocmd BufWritePre * :%s/\s\+$//e
"}}}

"""" auto cmd settings
" To remove automatic insertion of comment in next line iff previous line starts with comment character
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

"Test autocmds grouping
" autocmd! (This prevents having the autocommands defined twice (e.g., after sourcing the .vimrc file again)).
augroup filetype_vim
    autocmd!
    " Command to create a plugin from github link in clipboard obtained from browser with help of SurfingKeys ( yy in surfingkeys on chrome copies link to clipboard )
    autocmd FileType vim nnoremap <silent> <buffer> <localleader>ap zRgg/plug#end()<cr>-o" Plugin to <CR>Plug '<C-r>=matchstr("<c-r>*",'\v[.a-zA-Z0-9-]+\/[.a-zA-Z0-9-]+$')<cr>'<cr><esc>:noh<cr>2kA
    autocmd FileType vim nnoremap <buffer> <localleader>p gg/plug#end()<CR>
    "autocmd FileType vim :iabbrev <buffer> pl " Plugin to<CR>Plug '<++>'<esc>kA
    autocmd FileType vim setlocal foldmethod=expr foldexpr=JSfold()
augroup END
"}}}

"""" insert-mode abbrevations
" Abbrevations for commonly misspelled words
iabbrev adn and
iabbrev teh the
iabbrev waht what
iabbrev tehn then
"}}}

"""" set and let settings
let mapleader = ","
let maplocalleader="\\"
set rnu nu
set hidden
set encoding=utf-8
set cursorline

" Colorscheme
colorscheme dracula
set termguicolors

" History
set history=10000
set updatetime=100

" To modify sessions saving defaults and to remove local options set during sesion
set sessionoptions-=options
set sessionoptions+=help

" Gutter( space beside line numbers ) width for seeing foldlines
set foldcolumn=2

" For removing annoying files automatically created by vim during saving files (*~)
set nobackup
set nowritebackup
set noswapfile

" To store the file revision changes to a temp file
set undodir=$HOME/.config/nvim/undo-dir
set undofile

" Useful in searching with words
set ignorecase
set smartcase

" Indentation rules for documents
set tabstop=2
set softtabstop=4
set shiftwidth=4
" expandtab to spaces
set expandtab

" To show invisible characters
set list
" To change the color of the invisible characters to be displayed
highlight SpecialKey ctermfg=8 guifg=DimGrey
" To configure the characters shown with enabling the list option
set listchars=trail:·,extends:>,precedes:<,tab:▸·
"}}}

"""" remaps
" keybinding to use system clipboard
noremap <leader>p "*p

" Remapping <Enter> so that the search pattern highlight is removed after the search is over
nnoremap <silent> <cr> :noh<CR>

" To replace placeholders in the document
noremap <M-j> <Esc>/<++><CR><Esc>cf>
noremap! <M-j> <Esc>/<++><CR><Esc>cf>
noremap <M-k> <Esc>?<++><CR><Esc>cf>
noremap! <M-k> <Esc>?<++><CR><Esc>cf>

" Keymap to quit vim discarding all changes
nnoremap  <Leader>Q :qa!<cr>

" To remove space functionality to use as leader key
nnoremap <Space> <Nop>
"}}}

"""" functions
" A command to redirect output of a command to buffer at current cursor position
" Usage : From normal mode, hit i<ctrl-r> =Exec('ls')
function! Exec(command)
    redir =>output
    silent exec a:command
    redir END
    return output
endfunction

function! JSfold()
    let line = getline(v:lnum)
    if match(line,'^""""') > -1
        return ">2"
    elseif match(line,'^""') > -1
        return ">1"
    else
        return "="
    endif
endfunction

"}}}

"}}}

"" Plugin settings
"""" Quickscope settings
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

"""" CtrlSpace Settings
let g:CtrlSpaceDefaultMappingKey = "<C-space> "
let g:CtrlSpaceGlobCommand = 'fd --type file --exclude .git'
let g:airline_exclude_preview = 1
let g:CtrlSpaceUseArrowsInTerm = 1
let g:CtrlSpaceSymbols ={
            \ "File": "📁",
            \ "CS":"⚡",
            \ "BM":"🔖",
            \ "Sin":"📄",
            \ "All":"🌟",
            \ "Vis":"👁️",
            \ "Tabs":"",
            \ "CTab":"",
            \ "NTM":"",
            \ "WLoad":"🔻",
            \ "WSave":"🔺",
            \ "Zoom":"🔍",
            \ "SLeft":"▶️",
            \ "SRight":"◀️",
            \ "Help":"❓",
            \ "IV":"",
            \ "IA":"",
            \ "IM":" ",
            \ "Dots":"",
            \  }

"""" Airline Settings
let g:airline#extensions#tabline#enabled = 1

" Powerline fonts config
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.crypt = '🔒'
let g:airline_symbols.linenr = '☰'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.maxlinenr = '㏑'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.spell = 'Ꞩ'
let g:airline_symbols.notexists = 'Ɇ'
let g:airline_symbols.whitespace = 'Ξ'

" powerline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = '☰ '
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.dirty='⚡'

"""" Vim-sandwich settings
let g:sandwich#recipes = deepcopy(g:sandwich#default_recipes)

" To create a keymaps which surrounds the whole line (both are required) --> sas ==> to select whole line for surround action
onoremap <SID>line :normal! ^vg_<CR>
nmap <silent> sas <Plug>(operator-sandwich-add)<SID>line

"""" Easymotion settings

" To remove default settings
let g:EasyMotion_do_mapping = 0

" <Leader>f{char} to move to {char}
map  <Leader>ef <Plug>(easymotion-bd-f)
nmap <Leader>ef <Plug>(easymotion-overwin-f)

" Move to line
map <Leader>eL <Plug>(easymotion-bd-jk)
nmap <Leader>eL <Plug>(easymotion-overwin-line)
nmap <Leader>l <Plug>(easymotion-overwin-line)
xmap <Leader>l <Plug>(easymotion-bd-jk)
omap <Leader>l <Plug>(easymotion-bd-jk)

" Move to word
map  <Leader>ew <Plug>(easymotion-bd-w)
nmap <Leader>ew <Plug>(easymotion-overwin-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)

" In-line motion
map <Leader>el <Plug>(easymotion-lineforward)
map <Leader>eh <Plug>(easymotion-linebackward)

" Sneak-like easymotion movement
map <Leader>es <Plug>(easymotion-s2)

" Smart case in easymotion: 'l' -> l & L ; 'L' -> only 'L'
let g:EasyMotion_smartcase = 1
" Smartsign (type `3` and match `3`&`#`)
let g:EasyMotion_use_smartsign_us = 1

"""" GitGutter Settings
nmap ghs <Plug>(GitGutterStageHunk)
nmap ghu <Plug>(GitGutterUndoHunk)
nmap ghp <Plug>(GitGutterPreviewHunk)
nmap ghf :GitGutterFold<cr>

"""" which-key settings

" Map leader to which_key
nnoremap <silent> <leader> :silent WhichKey '<leader>'<CR>
vnoremap <silent> <leader> :silent <c-u> :silent WhichKeyVisual '<leader>'<CR>

" To display bindings for localleader
nnoremap <localleader> :<c-u>WhichKey  '<localleader>'<CR>
vnoremap <localleader> :<c-u>WhichKeyVisual  '<localleader>'<CR>

" Change the colors if you want
highlight default link WhichKey          Operator
highlight default link WhichKeySeperator DiffAdded
highlight default link WhichKeyGroup     Identifier
highlight default link WhichKeyDesc      Function

"Create map to add keys to
let g:which_key_map =  {}
" Define a separator
let g:which_key_sep = '==>'

let g:which_key_map['p'] = [ '"*p', 'paste' ]

" f is for fzf.vim
" We can define "keybindings" here for all vimrc
let g:which_key_map.f = {
      \ 'name' : '+FZF.VIM' ,
      \ '/' : [':History/'     , 'history'],
      \ ';' : [':Commands'     , 'Commands of vim'],
      \ 'B' : [':BCommits'     , 'buffer commits'],
      \ 'C' : [':Commits'      , 'commits'],
      \ 'G' : [':GFiles?'      , 'modified git files'],
      \ 'M' : [':Maps'         , 'normal maps'] ,
      \ 'b' : [':BLines'       , 'current buffer'],
      \ 'c' : [':Colors'       , 'color schemes'],
      \ 'f' : [':Files'        , 'files'],
      \ 'g' : [':GFiles'       , 'git files'],
      \ 'h' : [':History'      , 'file history'],
      \ 'l' : [':Lines'        , 'lines'] ,
      \ 'm' : [':Marks'        , 'marks'] ,
      \ 'r' : [':Rg'           , 'text Rg'],
      \ 't' : [':BTags'        , 'buffer tags'],
      \ 'w' : [':Windows'      , 'search windows'],
      \ 'y' : [':Filetypes'    , 'file types'],
      \ 'z' : [':FZF'          , 'FZF'],
      \ }

" e for easymotion
" We can also only specify "labels" for keymaps
let g:which_key_map.e = {
      \ 'name' : '+easymotion' ,
      \ 'L' : 'select line',
      \ 'f' : 'select one character',
      \ 'h' : 'select till start of line',
      \ 'l' : 'select till end of line',
      \ 's' : 'sneak-mode',
      \ 'w' : 'select words',
      \ }
" Register which key map
call which_key#register(',', "g:which_key_map")

"""" FZF.vim settings

" tweak original Rg file to use preview window along side
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

" complete words from /usr/share/dict/words and lines from current buffers list and file system-paths
imap <c-x><c-k> <plug>(fzf-complete-word)
"imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-l> <plug>(fzf-complete-line)
inoremap <expr> <c-x><c-f> fzf#vim#complete#path('fd -H -a -E .git')
"inoremap <expr> <c-x><c-f> fzf#vim#complete#path('rg --files') ==> fd could be a better alternative to rg for querying file and directory names

" use lines from all files in current working directory to insert in buffer ==> use in " insert mode only "
inoremap <expr> <Leader>fR fzf#vim#complete(fzf#wrap({
  \ 'prefix': '^.*$',
  \ 'source': 'rg -n ^ --color always',
  \ 'options': '--ansi --delimiter : --nth 3..',
  \ 'reducer': { lines -> join(split(lines[0], ':\zs')[2:], '') }}))

nnoremap <silent> <Leader>ff :Files<CR>
nnoremap <silent> <Leader>fl :Lines<CR>
nnoremap <silent> <Leader>fb :BLines<CR>
nnoremap <silent> <Leader>fw :Windows<CR>
nnoremap <silent> <Leader>f: :History:<CR>
nnoremap <silent> <Leader>f/ :History/<CR>
nnoremap <silent> <Leader>fr :Rg<CR>
nnoremap <silent> <Leader>fm :Marks<CR>
nnoremap <silent> <Leader>fc :Colors<CR>
nnoremap <silent> <Leader>ft :BTags<CR>


"""" IndentLine plugin settings
let g:indentLine_char='|'
let g:indentLine_leadingSpaceChar = '·'
let g:indentLine_leadingSpaceEnabled=1

"""" Mundo settings
nnoremap <F5> :MundoToggle<CR>
