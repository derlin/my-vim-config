scriptencoding utf-8


" for theme colors
set t_Co=256
colorscheme kolor


set nocompatible

" tabs and such
set number
" set paste
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

" to avoid Press enter to continue:
set cmdheight=2

" enable backup
set backupdir=~/.vim/backup//
set backup
set directory=~/.vim/backup//
set noswapfile


" enable persistant undo
set undofile                " Save undo's after file closes
set undodir=~/.vim/undo     " where to save undo histories
set undolevels=1000         " How many undos
set undoreload=10000        " number of lines to save for undo

filetype plugin indent on
set cindent
set autoindent
set smartindent

" ctags list
let Tlist_Ctags_Cmd = "/usr/bin/ctags"
let Tlist_WinWidth = 50
map <F4> :TlistToggle<cr>
map <F3> :!/usr/bin/ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

map <F1> :call LAutoRefactor()<CR>

" search 
set incsearch " incremental with highlight
set incsearch
set noignorecase
set infercase

" backspace : classic usage
set backspace=indent,eol,start

" include vimrc from home, if any
" if filereadable(expand("~/.vim/vimrc"))
"    source ~/.vim/vimrc
" endif

" syntax
if has("syntax")
    syntax on
endif
set showmatch " show matching braces

" automatic reload of files with outside changes
set autoread

" statusbar
set laststatus=2
set statusline=
set statusline+=%0*\[%n]                                  "buffernr
set statusline+=%0*\ %<%F\                                "File+path
set statusline+=%0*\ %y\                                  "FileType
set statusline+=%0*\ %{''.(&fenc!=''?&fenc:&enc).''}      "Encoding
set statusline+=%0*\ %{(&bomb?\",BOM\":\"\")}\            "Encoding2
set statusline+=%0*\ %{&ff}\                              "FileFormat (dos/unix..) 
set statusline+=%0*\ %=\ row:%l/%L\ (%3p%%)\              "Rownumber/total (%)
set statusline+=%0*\ col:%3c\                             "Colnr
set statusline+=%1*\ \ %m%r%w\ %P\ \                      "Modified? Readonly? Top/bot.

hi StatusLine term=reverse ctermfg=white ctermbg=black
hi User1 ctermfg=white ctermbg=black

" Windows
nmap <silent> <space><Up> :wincmd k<CR>
nmap <silent> <space><Down> :wincmd j<CR>
nmap <silent> <space><Left> :wincmd h<CR>
nmap <silent> <space><Right> :wincmd l<CR>

" Tabs
nmap ,t :tabnew<cr>
nmap ,w :tabclose<cr>
nmap <C-Left> :tabprevious <CR>
nmap <C-Right> :tabnext <CR>
nmap <silent> <A-Left> :execute 'silent! tabmove ' . (tabpagenr()-2)<CR>
nmap <silent> <A-Right> :execute 'silent! tabmove ' . (tabpagenr())<CR>

" shortcuts
" insert new line without entering insert mode (space + enter)
nnoremap <space><ENTER> o<ESC>
" paste the last yanked (and not deleted) content with control+p
nnoremap <C-p> "0p
" paste above line the last yanked (and not deleted) content using
" ctrl+"<"+p
nnoremap <lt><C-P> "0P
" copy
map <C-c> :w !xsel -i -b<CR>
" map <C-c> "+ygv   this does not work since my vim is compiled without the clipboard support
" select all
map <C-a> ggVG
" toggle undo tree view
nnoremap  <F5>  :UndotreeToggle<cr> 
" toggle paste
map <F2> :set paste!<Bar>set paste?<CR>

" dropdown spellchecker: use \s when the cursor is on the mispelled word
:nnoremap \s a<C-X><C-S>

" permettre l'insertion d'un unique char via s 
function! RepeatChar(char, count)
       return repeat(a:char, a:count)
endfunction
nnoremap s :<C-U>exec "normal i".RepeatChar(nr2char(getchar()), v:count1)<CR>
nnoremap S :<C-U>exec "normal a".RepeatChar(nr2char(getchar()), v:count1)<CR>


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



" custom functions
" replace the //... comments by /* ... */
if !exists(":ExpandComments")
   function ExpandComments()
       %s#//\(.*\)$#/\*\1 \*/#g
   endfunction
endif

" add spaces inside parentheses
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


