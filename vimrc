syntax on
set nocompatible
set tabstop=4
set shiftwidth=4
set expandtab
set nu
set smarttab autoindent
set smartcase

filetype plugin on

if has("autocmd")
    au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
        \| exe "normal! g'\"" | endif
endif

" Comment this line out if pathogen is not installed
execute pathogen#infect()

" Open nerdtree if vim starts with no files
" autocmd vimenter * if !argc() | NERDTree | endif

map <C-n> :NERDTreeToggle<CR>

map <C-p> :CtrlP<CR>
set wildignore+=*.zip,*.swp,*.class,*.pyc,*.o,*.so

" Python settings
autocmd Filetype python set smartindent
autocmd Filetype python set expandtab
autocmd Filetype python set tabstop=2
autocmd Filetype python set shiftwidth=2

" Auto insert closing brace and indent in java
autocmd FileType java imap { {<C-O>:call WeirdMap()<Enter>6<C-O>:call ResetMap()<Enter>

function! WeirdMap()
	if !empty(matchstr(split(getline('.')),")\$"))
		imap 6 <Enter>}<Left><Enter><Up><Tab>
	elseif len(split(getline('.'))) == 1
		imap 6 <Enter>}<Left><Enter><Up><Tab>
	elseif !empty(matchstr(getline('.'), " class "))
		imap 6 <Enter>}<Left><Enter><Up><Tab>
	elseif !empty(matchstr(getline('.'), " interface "))
		imap 6 <Enter>}<Left><Enter><Up><Tab>
	else
		imap 6 <Left><Right>
	endif
endfunction

function! ResetMap()
	imap 6 6
endfunction

function! JavaDoc() " :call JavaDoc() on a method sig
	let startLine = line('.')
	let indentString = ''
	let spc = ' '
	let i = 0
	let splitLine = split(getline(startLine))
	while i < indent('.')
		let indentString = indentString . spc
		let i += 1
	endwhile
	let i = 1
	let hasRet = 1
	let lines = [indentString . '/**', indentString . ' * ' . 'Description.']
	while i < len(splitLine)
		let stringm = matchstr(splitLine[i], '\zs\w\+\ze[),]')
		if !empty(stringm)
			call add(lines, indentString . ' * @param ' . stringm)
		elseif !empty(matchstr(splitLine[i], 'void'))
			let hasRet = 0
		endif
		let i += 1
	endwhile
	if hasRet
		call add(lines, indentString . ' * @return')
	endif
	call add(lines, indentString . ' */')
	exec append(startLine - 1, lines)
	exec startLine + 1
endfunction


autocmd FileType java imap <silent> <C-D><C-D> <C-O>:call InsertDoc()<Enter>
function! InsertDoc() " :call JavaDoc() on a method sig
	let startLine = line('.')
	let indentString = ''
	let spc = ' '
	let i = 0
	let splitLine = split(getline(startLine))
	while i < indent('.')
		let indentString = indentString . spc
		let i += 1
	endwhile
	let i = 1
	let hasRet = 1
	let lines = [indentString . '/**', indentString . ' * ', indentString . ' */']
	exec append(startLine - 1, lines)
	exec startLine + 1
    exec 'normal'.99.'|'
endfunction


function! MyFoldLevel( lineNumber )
    let thisLine = getline( a:lineNumber )
    if ( thisLine =~ '\%(^\s*/\*\*\s*$\)\|{' )
        return "a1"
    elseif ( thisLine =~ '\%(^\s*\*/\s*$\)\|}' )
        return "s1"
    endif
    return '='
endfunction

autocmd FileType java setlocal foldexpr=MyFoldLevel(v:lnum)
autocmd FileType java setlocal foldmethod=expr
