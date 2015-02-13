""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Maintainer: 
"      Lucy Linder
"
" Version: 
"       1.0 - 11/02/15 15:43:36
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
scriptencoding utf-8

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Use Vim defaults instead of 100% vi compatibility
set nocompatible 

" Behave like BASH on filename completion (complete the longest
" and then show a list of options)
set wildmode=longest:full
set wildmenu

" Show the cursor position all the time
set ruler 

" Enable syntax highlighting
syntax enable

" Set color theme
try
    colorscheme desert
    " Or use Kolor theme colors (see https://github.com/zeis/vim-kolor)
    " set t_Co=256
    " colorscheme kolor
catch
endtry

set background=dark
function GuiTabLabel()
    let label = ''
    let bufnrlist = tabpagebuflist(v:lnum)

    " Add '+' if one of the buffers in the tab page is modified
    for bufnr in bufnrlist
        if getbufvar(bufnr, "&modified")
            let label = '+'
            break
        endif
    endfor

    " Append the number of windows in the tab page if more than one
    let wincount = tabpagewinnr(v:lnum, '$')
    if wincount > 1
        let label .= wincount
    endif
    if label != ''
        let label .= ' '
    endif

    " Append the buffer name
    return label . bufname(bufnrlist[tabpagewinnr(v:lnum) - 1])
endfunction


" Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    set guioptions-=e
    set t_Co=256
"    set guitablabel=%M\ %t
endif


" Enable filetype plugins
filetype plugin on
filetype indent on

" Always show the tab line, even when only one tab
set showtabline=2
set guitablabel=%{GuiTabLabel()}            " tab label format
hi TabLine ctermbg=black ctermfg=white      " unselected tab
hi TabLineFill ctermbg=black ctermfg=black  " remaining of the tabline
hi TabLineSel ctermbg=blue ctermfg=white    " selected tab

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8
 
" Use Unix as the standard file type
set ffs=unix,dos,mac

" Set to auto read when a file is changed from the outside
set autoread

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Avoid the "Press enter to continue:" message
set cmdheight=2

" Automatically show line numbers
set number
     
" Remember info about open buffers on close
set viminfo^=%

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

" Suffixes that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc,.png,.jpg


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => backups, history and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" BACKUP
set backupdir=~/.vim/backup   " Save backup in the .vim dir
set directory=~/.vim/backup   
set backup                    " Enable backup
set noswapfile                " Turn off swap files

" enable persistant undo
set undofile                " Save undo's after file closes
set undodir=~/.vim/undo     " where to save undo histories
set undolevels=1000         " How many undos
set undoreload=10000        " number of lines to save for undo

" Sets how many lines of history VIM has to remember
set history=700

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Search and highligh
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Makes search act like search in modern browsers
set incsearch

" Show matching brackets when text indicator is over them
set showmatch

" How many tenths of a second to blink when matching brackets
set mat=2

" Don't ignore case when searching
set ignorecase

" When searching try to be smart about cases 
set smartcase " 
 
" Highlight search results
set hlsearch

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Windows and tabs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Windows: use space+arrow to move around windows
nmap <silent> <space><Up> :wincmd k<CR>    
nmap <silent> <space><Down> :wincmd j<CR>
nmap <silent> <space><Left> :wincmd h<CR>
nmap <silent> <space><Right> :wincmd l<CR>

" Tabs
nmap <leader>t :tabnew<cr>     " ,t to open an new tab
nmap <leader>x :tabclose<cr>   " ,x to close the current tab
" Ctrl+arrow to move around tabs 
nmap <C-Left> :tabprevious <CR>     "
nmap <C-Right> :tabnext <CR>
" Alt+arrow to move tabs around
nmap <silent> <A-Left> :execute 'silent! tabmove ' . (tabpagenr()-2)<CR>
nmap <silent> <A-Right> :execute 'silent! tabmove ' . (tabpagenr())<CR>

" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/


" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Insert new line without entering insert mode with space+enter
nnoremap <space><ENTER> o<ESC>
" Paste the last yanked (and not deleted) content with control+p
nnoremap <C-p> "0p

" Paste above line the last yanked (and not deleted) content using
" ctrl+"<"+p
nnoremap <lt><C-P> "0P

" Copy shortcut (ctrl+c)
" Note: map <C-c> "+ygv  does not work since my vim is compiled without the clipboard support
map <C-c> :w !xsel -i -b<CR>

" Select all with ctrl+A
map <C-a> ggVG

" Toggle paste mode with F2
map <F2> :set paste!<Bar>set paste?<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"" undotree: http://www.vim.org/scripts/script.php?script_id=4177
" toggle undo tree view by pressing F5 
nnoremap  <F5>  :UndotreeToggle<cr> 


"" ctags: http://www.vim.org/scripts/script.php?script_id=610 and http://ctags.sourceforge.net/
let Tlist_Ctags_Cmd = "/usr/bin/ctags"
let Tlist_WinWidth = 50
map <F4> :TlistToggle<cr>   " Toggle ctags window with F4
map <F3> :!/usr/bin/ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

" Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=
" TODO

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing: mappings and utils
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk

" For when you forget to sudo.. Really Write the file.
cmap w!! w !sudo tee % >/dev/null

" Insert one char under cursor by pressing ctrl+s
function! RepeatChar(char, count)
       return repeat(a:char, a:count)
endfunction
nnoremap s :<C-U>exec "normal i".RepeatChar(nr2char(getchar()), v:count1)<CR>
nnoremap S :<C-U>exec "normal a".RepeatChar(nr2char(getchar()), v:count1)<CR>

" Move a line of text using ALT+[up|down] or Comamnd+[up|down] on mac
nmap <A-Up>     mz:m-2<cr>`z
nmap <A-Down>   mz:m+<cr>`z
vmap <A-Up>     :m'<-2<cr>`>my`<mzgv`yo`z
vmap <A-Down>   :m'>+<cr>`<my`>mzgv`yo`z

" Remap VIM 0 to first non-blank character
map 0 ^

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4
set softtabstop=4

" Linebreak on 500 characters
set lbr
set tw=500

set ai      "Auto indent
set si      "Smart indent
set wrap    "Wrap lines

" Set tabstop, softtabstop and shiftwidth to the same value
command! -nargs=* Stab call Stab()
function! Stab()
    let l:tabstop = 1 * input('set tabstop = softtabstop = shiftwidth = ')
    if l:tabstop > 0
        let &l:sts = l:tabstop
        let &l:ts = l:tabstop
        let &l:sw = l:tabstop
    endif
    call SummarizeTabs()
endfunction

function! SummarizeTabs()
    try
        echohl ModeMsg
        echon 'tabstop='.&l:ts
        echon ' shiftwidth='.&l:sw
        echon ' softtabstop='.&l:sts
        if &l:et
            echon ' expandtab'
        else
            echon ' noexpandtab'
        endif
    finally
        echohl None
    endtry
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => File types
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" JR
autocmd BufNewFile,BufReadPost *.jr set filetype=jr
autocmd FileType jr set formatoptions+=r

" m2jr
autocmd BufNewFile,BufReadPost *.m set filetype=m2jr
autocmd FileType m2jr set formatoptions+=r

" for makefile, don't expand tabs
autocmd FileType make setlocal noexpandtab

" for git commit, set wrap text and spell check
autocmd FileType gitcommit,html set wrap linebreak nolist nocin spell wrapmargin=0 tw=0 spelllang=en

" for text files
autocmd BufNewFile,BufReadPost *.txt set wrap linebreak nolist nocin

" for asm to expand comments like in c (if set paste, don't work)
autocmd FileType asm set formatoptions+=r

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

" Delete trailing white space on save, useful for Python and CoffeeScript ;)
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Status line
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Reminder -- format markers:
"   %< truncation point
"   %n buffer number
"   %f relative path to file
"   %m modified flag [+] (modified), [-] (unmodifiable) or nothing
"   %r readonly flag [RO]
"   %y filetype [ruby]
"   %= split point for left and right justification
"   %-35. width specification
"   %l current line number
"   %L number of lines in buffer
"   %c current column number
"   %V current virtual column number (-n), if different from %c
"   %P percentage through buffer
"   %) end of width specification
" Finally, %= allows you to split the left- and right-justification.

" Always show the status line
set laststatus=2

" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE  '
    en
    return ''
endfunction


" Format the status line
"set statusline=\ %{HasPaste()}%F%m%h\ %w\ \ [%{getcwd()}%h]\ \ 
"set statusline+=\ \ \  
"set statusline+=\ Line:\ %-3.l/%-3.L               " Line number
"set statusline+=\ (%c\)\ \ \                       " Column
"set statusline+=%=                                 " align right
"set statusline+=\ %{''.(&fenc!=''?&fenc:&enc).''}  " Encoding
"set statusline+=%1*\ \ %r     s                   " Readonly?

"set statusline=
""set statusline+=\[%n]                                  "buffernr
"set statusline=\ %{HasPaste()}
"set statusline+=\ %<%F\                                "File+path
"set statusline+=\ %y\                                  "FileType
"set statusline+=\ %{''.(&fenc!=''?&fenc:&enc).''}      "Encoding
"set statusline+=\ %{(&bomb?\",BOM\":\"\")}\            "Encoding2
"set statusline+=\ %{&ff}\                              "FileFormat (dos/unix..) 
"set statusline+=\ %{&spelllang}\                       "Spellanguage 
"set statusline+=\ %=\ line:%l/%L\                      "Rownumber/total (%)
"set statusline+=\ col:%3c\                            "Colnr
"set statusline+=\ \ %m%r%w\ %P\ \                      "Modified? Readonly? Top/bot.


set statusline=
set statusline+=%0*\ %<%F%m\                             "File+path + modified ?
set statusline+=%0*\ %y\                                 "FileType
set statusline+=%0*\ %{''.(&fenc!=''?&fenc:&enc).''}     "Encoding
set statusline+=%{(&bomb?\",BOM\":\"\")}                 "Encoding2
set statusline+=:%{&ff}\                                 "FileFormat (dos/unix..) 
set statusline+=\ [cwd:%{getcwd()}%h]                    "Current pwd 
set statusline+=\ %=\ Line:%l/%L\ (%3p%%)\               "Rownumber/total (%)
set statusline+=\ col:%c\                                "Colnr
set statusline+=%0*\ \ %r%w\                             "Readonly? Top/bot.

hi StatusLine term=reverse ctermfg=white ctermbg=black
hi User1 ctermfg=white ctermbg=black


" statusbar
"set laststatus=2
"set statusline=
"set statusline+=%0*\ %<%F\                                "File+path
"set statusline+=%0*\ %y\                                  "FileType
"set statusline+=%0*\ %{''.(&fenc!=''?&fenc:&enc).''}      "Encoding
"set statusline+=\ %{(&bomb?\",BOM\":\"\")}\               "Encoding2
"set statusline+=\ %{&ff}\                                 "FileFormat (dos/unix..) 
"set statusline+=\ %=\ Line:%l/%L\ (%3p%%)\                "Rownumber/total (%)
"set statusline+=\ col:%c\                                 "Colnr
"set statusline+=%0*\ \ %m%r%w\                            "Modified? Readonly? Top/bot.

"hi StatusLine term=reverse ctermfg=white ctermbg=black
"hi User1 ctermfg=white ctermbg=black


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" :call ExpandComments will replace the //... comments by /* ... */
if !exists(":ExpandComments")
   function ExpandComments()
       %s#//\(.*\)$#/\*\1 \*/#g
   endfunction
endif

" :call JavaFormat() will add spaces inside parentheses
if !exists(":JavaFormat")
   function JavaFormat()
      %s/(\s*\(\S[^()]*\S\)\s*)/( \1 )/g
   endfunction
endif
function! LRefac(s, r)

    if( ! empty(&ft) )
        exe ':norm mkHml'
        try
            if( &ft =~ '\v(jr)|(c)|(java)|(asm)' )
                let lala = "LuCSalkji_23_1984_f££asdf____"
                exe 'silent! %s/\v^( *\*.*)<' . a:s . '>/\1' . lala . '/Ig'
                exe '%s/\v^([^' . '//|/*' . ']*)<' . a:s . '>/\1' . a:r . '/Ig'
                exe 'silent! %s/\( *\*.*\)\<' . lala . '\>/\1' . a:s . '/Ig'

            elseif( &ft =~ '\v(perl)|(awk)|(sh)|(bash)|(python)' )
                exe '%s/\v^([^' . '#' . ']*)<' . a:s . '>/\1' . a:r . '/g'
            endif
        catch /E486:/
            echo "Pattern not found (".a:s.")"
        endtry
        exe ':norm `lzt`k'

    else
        echo 'Sorry, function not defined for this filetype'
    endif
endfunction
function! LAutoRefactor()
   let curword = expand( "<cword>" )
   let replace = input( "replacement for " . curword . ": " )
   echo "\n"

   if( !empty( replace ) )
        call LRefac( curword, replace )
    else
        echo "canceled"
    endif
    "echo <CR>
endfunction
