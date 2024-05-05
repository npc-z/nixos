let mapleader = " "      " 定义<leader>键

inoremap jj <Esc>
nnoremap j jzz
nnoremap k kzz

nnoremap <leader>w :w<cr>
nnoremap <leader>q :q<cr>

set foldmethod=marker

function SqlUp()
  :%s/\<select\>/SELECT/g
  :%s/\<distinct\>/DISTINCT/g
  :%s/\<on\>/ON/g
  :%s/\<as\>/AS/g
  :%s/\<count\>/COUNT/g
  :%s/\<sum\>/SUM/g
  :%s/\<if\>/IF/g
  :%s/\<else\>/ELSE/g
  :%s/\<is\>/IS/g
  :%s/\<not\>/NOT/g
  :%s/\<else\>/ELSE/g
  :%s/\<and\>/AND/g
  :%s/\<from\>/FROM/g
  :%s/\<join\>/JOIN/g
  :%s/\<where\>/WHERE/g
  :%s/\<between\>/BETWEEN/g
  :%s/\<group by\>/GROUP BY/g
  :%s/\<order by\>/ORDER BY/g
  :%s/\<null\>/NULL/g
  :%s/\<any_value\>/ANY_VALUE/g
  :%s/\<max\>/MAX/g
  :%s/\<having\>/HAVING/g
  :%s/\<case\>/CASE/g
  :%s/\<when\>/WHEN/g
  :%s/\<table\>/TABLE/g
  :%s/\<left\>/LEFT/g
  :%s/\<outer\>/OUTER/g
  :%s/\<end\>/END/g
  :%s/\<insert\>/INSERT/g
  :%s/\<overwrite\>/OVERWRITE/g
  :%s/\<union\>/UNION/g
  :%s/\<with\>/WITH/g
  echo "fk"
  return
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  __   __   __     __    __     ______   ______     ______     ______
" /\ \ / /  /\ \   /\ "-./  \   /\  ___\ /\  __ \   /\  ___\   /\__  _\
" \ \ \"/   \ \ \  \ \ \-./\ \  \ \  __\ \ \  __ \  \ \___  \  \/_/\ \/
"  \ \__|    \ \_\  \ \_\ \ \_\  \ \_\    \ \_\ \_\  \/\_____\    \ \_\
"   \/_/      \/_/   \/_/  \/_/   \/_/     \/_/\/_/   \/_____/     \/_/
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 通用设置
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible         " 设置不兼容原始vi模式
filetype on              " 设置开启文件类型侦测
filetype plugin on       " 设置加载对应文件类型的插件
set noeb                 " 关闭错误的提示
syntax enable            " 开启语法高亮功能
syntax on                " 自动语法高亮
set t_Co=256             " 开启256色支持
set vb t_vb=             " 设置不要响铃
set cmdheight=1          " 设置命令行的高度
set showcmd              " select模式下显示选中的行数
set textwidth=0          " 设置禁止自动断行
set ruler                " 总是显示光标位置
set laststatus=2         " 总是显示状态栏
set number               " 开启行号显示
set relativenumber       " 展示相对行号
set cursorline           " 高亮显示当前行
set whichwrap+=<,>,h,l   " 设置光标键跨行
set ttimeoutlen=0        " 设置<ESC>键响应时间
set virtualedit=block,onemore   " 允许光标出现在最后一个字符的后面
set noshowmode           " 设置不打开底部insert
set hidden               " 设置允许在未保存切换buffer
set background=dark      " 设置背景默认黑色
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 代码缩进和排版
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set autoindent           " 设置自动缩进
set cindent              " 设置使用C/C++语言的自动缩进方式
set cinoptions=g0,:0,N-s,(0    " 设置C/C++语言的具体缩进方式
set smartindent          " 智能的选择对其方式
filetype indent on       " 自适应不同语言的智能缩进
set noexpandtab          " 设置禁止空格替换tab,tab党
set tabstop=4            " 设置编辑时制表符占用空格数
set shiftwidth=4         " 设置格式化时制表符占用空格数
set softtabstop=4        " 设置4个空格为制表符
set smarttab             " 在行和段开始处使用制表符
set nowrap               " 禁止折行
set backspace=2          " 使用回车键正常处理indent,eol,start等
set sidescroll=10        " 设置向右滚动字符数
set nofoldenable         " 禁用折叠代码
set list lcs=tab:¦\      " 设置默认开启对齐线
set sidescroll=0         " 设置向右滑动距离
set sidescrolloff=4      " 设置右部距离
" set scrolloff=5          " 设置底部距离

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 代码补全
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set wildmenu                             " vim自身命名行模式智能补全
set completeopt=menuone,preview,noselect " 补全时不显示窗口，只显示补全列表
set omnifunc=syntaxcomplete#Complete     " 设置全能补全
set shortmess+=c                         " 设置补全静默
set cpt+=kspell                          " 设置补全单词

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 搜索设置
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set hlsearch            " 高亮显示搜索结果
set incsearch           " 开启实时搜索功能
set ignorecase          " 搜索时大小写不敏感
set smartcase           " 搜索智能匹配大小写

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 缓存设置
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nobackup            " 设置不备份
set noswapfile          " 禁止生成临时文件
set autoread            " 文件在vim之外修改过，自动重新读入
set autowrite           " 设置自动保存
set confirm             " 在处理未保存或只读文件的时候，弹出确认

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 编码设置
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set langmenu=zh_CN.UTF-8
set helplang=cn
set termencoding=utf-8
set encoding=utf8
set fileencodings=utf8,ucs-bom,gbk,cp936,gb2312,gb18030

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" gvim/macvim设置
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("gui_running")
	set guifont=DroidSansMono\ Nerd\ Font\ Regular\ 14      " 设置字体
	set guioptions-=m           " 隐藏菜单栏
	set guioptions-=T           " 隐藏工具栏
	set guioptions-=L           " 隐藏左侧滚动条
	set guioptions-=r           " 隐藏右侧滚动条
	set guioptions-=b           " 隐藏底部滚动条
	set showtabline=0           " 隐藏Tab栏
	set guicursor=n-v-c:ver5    " 设置光标为竖线
	" set guifont=Droid\ Sans\ Mono\ Nerd\ Font\ Complete:h14 " set fonts in macvim
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-buffer
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" load vim default plugin
runtime macros/matchit.vim

" check version
if !has('patch-8.0.1453')
	echom "WARNING:vim is too old,so it can support some feature!"|finish
endif


" 插入模式下的光标移动
imap <c-j> <down>
imap <c-k> <up>
imap <c-l> <right>
imap <c-h> <left>

" map enter
func! s:Enter()
	let ch=getline('.')[col('.')-1]|let last=getline('.')[col('.')-2]
	if ch=='}'&&last=='{'
		let str=matchstr(getline('.'),"^\\s*")
		call append(line('.'),str.ch)
		return "\<del>\<cr>"
	endif
	return "\<cr>"
endfunc
inoremap <silent><cr> <c-r>=<sid>Enter()<cr>

" 插入移动
inoremap <c-e> <end>
inoremap <c-a> <c-o>^
inoremap <c-d> <del>
inoremap <c-f> <c-o>w
inoremap <expr><c-b> <sid>CtrlB()
func! s:CtrlB()
	if pumvisible()|return "\<c-n>"
	elseif getline('.')[col('.')-2]==nr2char(9)
		let s:pos=col('.')|let s:result=""
		while s:pos!=0|let s:result=s:result."\<bs>"|let s:pos-=1|endwhile
		let s:result=s:result."\<c-n>"
		return s:result
	else
		return "\<c-o>b"
	endif
endfunc


" 复制当前选中到系统剪切板
vnoremap <leader><leader>y "+y
nnoremap <leader><leader>y "+y
"将系统剪切板内容粘贴到vim
nnoremap <leader><leader>p "+p
nnoremap <leader><leader>P "+P
vnoremap <leader><leader>p "+p
vnoremap <leader><leader>P "+P

" set pair baket
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
cnoremap ( ()<left>
cnoremap [ []<left>
cnoremap { {}<left>

" yank and paste
nnoremap <leader>p "0p
vnoremap <leader>p "0p
nnoremap <leader>P "0P
vnoremap <leader>P "0P

" cmd emacs model
cnoremap <c-a> <home>
cnoremap <c-e> <end>
cnoremap <c-d> <del>
cnoremap <c-h> <left>
cnoremap <c-l> <right>
cnoremap <c-b> <s-left>
cnoremap <c-f> <s-right>

" set statusline {{{
function GetMode()
	let m = mode()|let s:str=''|let s:color='#9ECE6A'
	if m == 'R'|let s:color='#F7768E'|let s:str= 'Replace'
	elseif m == 'v'|let s:color='#F7768E'|let s:str= 'Visual'
	elseif m == 'i'|let s:color='#7AA2F7'|let s:str= 'Insert'
	elseif m == 't'|let s:color='#7AA2F7'|let s:str= 'Terminal'
	else|let s:color='#9ECE6A'|let s:str= 'Normal'
	endif
	exec 'highlight User3 font=#000000 guifg=#1a1b26 guibg='.s:color
	exec 'highlight User4 font=#000000 guifg='.s:color.' guibg=#232433'
	redraw|return s:str
endfunction

let g:status_git_branch=""
func! GitBranchShow(chan,msg)
	let g:status_git_branch=" ".a:msg." |"
endfunc
if g:status_git_branch==""
	call job_start("git rev-parse --abbrev-ref HEAD",{"out_cb":"GitBranchShow"})
endif

set statusline=%3*\ %{GetMode()}
set statusline+=%4*\ %{g:status_git_branch}\ %F\ \|%m%r%h%w%=
set statusline+=%3*\ %Y\ |
set statusline+=%3*¦%{\"\".(\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\"+\":\"\").\"\"}¦
set statusline+=%5*☰\ %l/%-L¦%3p%%¦:%v\ ¦
"}}}

" highlight define,you can change self {{{
highlight User1 font=#000000 guifg=#1a1b26 guibg=#9ECE6A
highlight User2 font=#000000 guifg=#9ECE6A guibg=#232433
highlight User3 font=#000000 guifg=#1a1b26 guibg=#9ECE6A
highlight User4 font=#000000 guifg=#9ECE6A guibg=#232433
highlight User5 font=#000000 guifg=#1a1b26 guibg=#7AA2F7
highlight User6 font=#000000 guifg=#7AA2F7 guibg=#232433
"}}}

" set netrw {{{
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 15
set fillchars=vert:\⎜
nnoremap <leader>n :Lexplore<cr> " set netrw
highlight VertSplit guibg=#1a1b26 guifg=#232433
"}}}


" set tabline {{{
let s:tab_after=""
func! TabLine(direct)
	let s:tab_result=""|let flag=0
	if a:direct|return s:tab_after|else|let s:tab_after=""|endif
	for buf in getbufinfo({'buflisted':1})
		let s:name=buf.name
		if strridx(buf.name,"/")!=-1|let s:name=strpart(buf.name,strridx(buf.name,"/")+1)|endif
		if buf.name!=expand('%:p')
			if flag==0|let s:tab_result=s:tab_result."\ ".s:name|else|let s:tab_after=s:tab_after."\ ".s:name|endif
		else
			let flag=1
		endif
	endfor
	redrawt
	return s:tab_result
endfunc
func! TabLineSet()
	if &modified|let tab="%2* %0.32(%{TabLine(0)}%)%5*\ %t%6*%2*%<%{TabLine(1)}%r%h%w%=%6*\ %5* buffer"
	else|let tab="%2* %0.32(%{TabLine(0)}%)%1*\ %t%2*%2*%<%{TabLine(1)}%r%h%w%=%2*\ %1* buffer"
	endif
	return tab
endfunc
set tabline=%!TabLineSet()
set showtabline=2
"}}}

" set gcc enable {{{
func! s:Commentary(line) abort
	let s:num=a:line
	let line=getline(s:num)
	let uncomment=2
	let [l, r] = split( substitute(substitute(substitute(
				\ &commentstring, '^$', '%s', ''), '\S\zs%s',' %s', '') ,'%s\ze\S', '%s ', ''), '%s', 1)
	let line = matchstr(getline(s:num),'\S.*\s\@<!')
	if l[-1:] ==# ' ' && stridx(line,l) == -1 && stridx(line,l[0:-2]) == 0|let l = l[:-2]|endif
	if r[0] ==# ' ' && line[-strlen(r):] != r && line[1-strlen(r):] == r[1:]|let r = r[1:]|endif
	if len(line) && (stridx(line,l) || line[strlen(line)-strlen(r) : -1] != r)|let uncomment = 0|endif
	let line=getline(s:num)
	let [l, r] = split( substitute(substitute(substitute(
				\ &commentstring, '^$', '%s', ''), '\S\zs%s',' %s', '') ,'%s\ze\S', '%s ', ''), '%s', 1)
	if strlen(r) > 2 && l.r !~# '\\'
		let line = substitute(line,
					\'\M' . substitute(l, '\ze\S\s*$', '\\zs\\d\\*\\ze', '') . '\|' . substitute(r, '\S\zs', '\\zs\\d\\*\\ze', ''),
					\'\=substitute(submatch(0)+1-uncomment,"^0$\\|^-\\d*$","","")','g')
	endif
	if uncomment
		let line = substitute(line,'\S.*\s\@<!','\=submatch(0)[strlen(l):-strlen(r)-1]','')
	else
		let line = substitute(line,'^\%('.matchstr(getline(s:num),'^\s*').'\|\s*\)\zs.*\S\@<=','\=l.submatch(0).r','')
	endif
	call setline(s:num,line)
endfunc
" visual gcc
func! s:VisualComment() abort
	for temp in range(min([line('.'),line('v')]),max([line('.'),line('v')]))
		call s:Commentary(temp)
	endfor
endfunc
nnoremap <silent><nowait>gcc :call <sid>Commentary(line('.'))<cr>
xnoremap <silent><nowait>gc  :call <sid>VisualComment()<cr>
"}}}

" vim sourround {{{
let g:pair_map={'(':')','[':']','{':'}','"':'"',"'":"'",'<':'>','`':'`',}
func! s:AddSourround()
	let s:ch=nr2char(getchar())|let s:col=col('.')|let pos=getcurpos()
	norm! gv"sy
	let s:str = @s
	for k in keys(g:pair_map)
		if s:ch==k||s:ch==g:pair_map[k]
			execute ":s/^\\(.\\{".(col('.')-1)."\\}\\)".escape(s:str, '~"\.^$[]*')."/\\1".k.s:str.g:pair_map[k]."/"
			call setpos('.', pos)
			return
		endif
	endfor
	echo s:ch.' unknow pair'
endfunc
func! s:DelSourround()
	let s:ch=nr2char(getchar())
	if getline('.')[col('.')-1]!=s:ch|echo 'not begin with'.s:ch|return|endif
	for k in keys(g:pair_map)
		if s:ch==k|execute 'normal! xf'.g:pair_map[k].'x'|return|endif
	endfor
endfunc
func! s:ChangeSourround()
	let s:ch=nr2char(getchar())|let s:two=nr2char(getchar())
	let pos=getcurpos()
	if getline('.')[col('.')-1]!=s:ch|echo 'not begin with'.s:ch|return|endif
	execute 'normal! r'.s:two.'f'.g:pair_map[s:ch].'r'.g:pair_map[s:two]
	call setpos('.',pos)
endfunc
xnoremap <silent>S  :<c-u>call <sid>AddSourround()<cr>
nnoremap <silent>ds :call <sid>DelSourround()<cr>
nnoremap <silent>cs :call <sid>ChangeSourround()<cr>
"}}}




" tokyonight color inside,donnot change it {{{
set termguicolors
let g:tokyonight_style = 'night' " available: night, storm
let s:t_Co = exists('&t_Co') && !empty(&t_Co) && &t_Co > 1 ? &t_Co : 2
let s:tmux = executable('tmux') && $TMUX !=# ''
let g:colors_name = 'tokyonight'|let s:configuration = {}
let s:configuration.style = get(g:, 'tokyonight_style', 'night')
let s:configuration.transparent_background = get(g:, 'tokyonight_transparent_background', 0)
let s:configuration.menu_selection_background = get(g:, 'tokyonight_menu_selection_background', 'green')
let s:configuration.disable_italic_comment = get(g:, 'tokyonight_disable_italic_comment', 0)
let s:configuration.enable_italic = get(g:, 'tokyonight_enable_italic', 0)
let s:configuration.cursor = get(g:, 'tokyonight_cursor', 'auto')
let s:configuration.current_word = get(g:, 'tokyonight_current_word', get(g:, 'tokyonight_transparent_background', 0) == 0 ? 'grey background' : 'bold')
if s:configuration.style ==# 'night'
	let s:palette = {
				\ 'black':      ['#06080a',   '237',  'DarkGrey'],
				\ 'bg0':        ['#1a1b26',   '235',  'Black'],
				\ 'bg1':        ['#232433',   '236',  'DarkGrey'],
				\ 'bg2':        ['#2a2b3d',   '236',  'DarkGrey'],
				\ 'bg3':        ['#32344a',   '237',  'DarkGrey'],
				\ 'bg4':        ['#3b3d57',   '237',  'Grey'],
				\ 'bg_red':     ['#ff7a93',   '203',  'Red'],
				\ 'diff_red':   ['#803d49',   '52',   'DarkRed'],
				\ 'bg_green':   ['#b9f27c',   '107',  'Green'],
				\ 'diff_green': ['#618041',   '22',   'DarkGreen'],
				\ 'bg_blue':    ['#7da6ff',   '110',  'Blue'],
				\ 'diff_blue':  ['#3e5380',   '17',   'DarkBlue'],
				\ 'fg':         ['#a9b1d6',   '250',  'White'],
				\ 'red':        ['#F7768E',   '203',  'Red'],
				\ 'orange':     ['#FF9E64',   '215',  'Orange'],
				\ 'yellow':     ['#E0AF68',   '179',  'Yellow'],
				\ 'green':      ['#9ECE6A',   '107',  'Green'],
				\ 'blue':       ['#7AA2F7',   '110',  'Blue'],
				\ 'purple':     ['#ad8ee6',   '176',  'Magenta'],
				\ 'grey':       ['#444B6A',   '246',  'LightGrey'],
				\ 'none':       ['NONE',      'NONE', 'NONE']
				\ }
elseif s:configuration.style ==# 'storm'
	let s:palette = {
				\ 'black':      ['#06080a',   '237',  'DarkGrey'],
				\ 'bg0':        ['#24283b',   '235',  'Black'],
				\ 'bg1':        ['#282d42',   '236',  'DarkGrey'],
				\ 'bg2':        ['#2f344d',   '236',  'DarkGrey'],
				\ 'bg3':        ['#333954',   '237',  'DarkGrey'],
				\ 'bg4':        ['#3a405e',   '237',  'Grey'],
				\ 'bg_red':     ['#ff7a93',   '203',  'Red'],
				\ 'diff_red':   ['#803d49',   '52',   'DarkRed'],
				\ 'bg_green':   ['#b9f27c',   '107',  'Green'],
				\ 'diff_green': ['#618041',   '22',   'DarkGreen'],
				\ 'bg_blue':    ['#7da6ff',   '110',  'Blue'],
				\ 'diff_blue':  ['#3e5380',   '17',   'DarkBlue'],
				\ 'fg':         ['#a9b1d6',   '250',  'White'],
				\ 'red':        ['#F7768E',   '203',  'Red'],
				\ 'orange':     ['#FF9E64',   '215',  'Orange'],
				\ 'yellow':     ['#E0AF68',   '179',  'Yellow'],
				\ 'green':      ['#9ECE6A',   '107',  'Green'],
				\ 'blue':       ['#7AA2F7',   '110',  'Blue'],
				\ 'purple':     ['#ad8ee6',   '176',  'Magenta'],
				\ 'grey':       ['#444B6A',   '246',  'LightGrey'],
				\ 'none':       ['NONE',      'NONE', 'NONE']
				\ }
endif
if (has('termguicolors') && &termguicolors) || has('gui_running')  " guifg guibg gui cterm guisp
	function! s:HL(group, fg, bg, ...)
		let hl_string = [ 'highlight', a:group, 'guifg=' . a:fg[0], 'guibg=' . a:bg[0], ]
		if a:0 >= 1
			if a:1 ==# 'undercurl'
				if !s:tmux|call add(hl_string, 'gui=undercurl')
				else|call add(hl_string, 'gui=underline')
				endif
				call add(hl_string, 'cterm=underline')
			else|call add(hl_string, 'gui=' . a:1)|call add(hl_string, 'cterm=' . a:1)
			endif
		else|call add(hl_string, 'gui=NONE')|call add(hl_string, 'cterm=NONE')
		endif
		if a:0 >= 2|call add(hl_string, 'guisp=' . a:2[0])|endif
		execute join(hl_string, ' ')
	endfunction
elseif s:t_Co >= 256
	function! s:HL(group, fg, bg, ...)
		let hl_string = [ 'highlight', a:group, 'ctermfg=' . a:fg[1], 'ctermbg=' . a:bg[1]]
		if a:0 >= 1
			if a:1 ==# 'undercurl'|call add(hl_string, 'cterm=underline')
			else|call add(hl_string, 'cterm=' . a:1)
			endif
		else|call add(hl_string, 'cterm=NONE')
		endif
		execute join(hl_string, ' ')
	endfunction
else  " ctermfg ctermbg cterm
	function! s:HL(group, fg, bg, ...)
		let hl_string = [ 'highlight', a:group, 'ctermfg=' . a:fg[2], 'ctermbg=' . a:bg[2]]
		if a:0 >= 1
			if a:1 ==# 'undercurl'|call add(hl_string, 'cterm=underline')
			else|call add(hl_string, 'cterm=' . a:1)
			endif
		else|call add(hl_string, 'cterm=NONE')
		endif
		execute join(hl_string, ' ')
	endfunction
endif
if s:configuration.transparent_background
	call s:HL('Normal', s:palette.fg, s:palette.none)
	call s:HL('Terminal', s:palette.fg, s:palette.none)
	call s:HL('EndOfBuffer', s:palette.bg0, s:palette.none)
	call s:HL('FoldColumn', s:palette.grey, s:palette.none)
	call s:HL('Folded', s:palette.grey, s:palette.none)
	call s:HL('SignColumn', s:palette.fg, s:palette.none)
	call s:HL('ToolbarLine', s:palette.fg, s:palette.none)
else
	call s:HL('Normal', s:palette.fg, s:palette.bg0)
	call s:HL('Terminal', s:palette.fg, s:palette.bg0)
	call s:HL('EndOfBuffer', s:palette.bg0, s:palette.bg0)
	call s:HL('FoldColumn', s:palette.grey, s:palette.bg1)
	call s:HL('Folded', s:palette.grey, s:palette.bg1)
	call s:HL('SignColumn', s:palette.fg, s:palette.bg1)
	call s:HL('ToolbarLine', s:palette.fg, s:palette.bg2)
endif
call s:HL('ColorColumn', s:palette.none, s:palette.bg1)
call s:HL('Conceal', s:palette.grey, s:palette.none)
if s:configuration.cursor ==# 'auto'|call s:HL('Cursor', s:palette.none, s:palette.none, 'reverse')
elseif s:configuration.cursor ==# 'red'|call s:HL('Cursor', s:palette.bg0, s:palette.red)
elseif s:configuration.cursor ==# 'green'|call s:HL('Cursor', s:palette.bg0, s:palette.green)
elseif s:configuration.cursor ==# 'blue'|call s:HL('Cursor', s:palette.bg0, s:palette.blue)
endif
highlight! link vCursor Cursor
highlight! link iCursor Cursor
highlight! link lCursor Cursor
highlight! link CursorIM Cursor
call s:HL('CursorColumn', s:palette.none, s:palette.bg1)
call s:HL('CursorLine', s:palette.none, s:palette.bg1)
call s:HL('LineNr', s:palette.grey, s:palette.none)
if &relativenumber == 1 && &cursorline == 0|call s:HL('CursorLineNr', s:palette.fg, s:palette.none)
else|call s:HL('CursorLineNr', s:palette.fg, s:palette.bg1)
endif
call s:HL('DiffAdd', s:palette.none, s:palette.diff_green)
call s:HL('DiffChange', s:palette.none, s:palette.diff_blue)
call s:HL('DiffDelete', s:palette.none, s:palette.diff_red)
call s:HL('DiffText', s:palette.none, s:palette.none, 'reverse')
call s:HL('Directory', s:palette.green, s:palette.none)
call s:HL('ErrorMsg', s:palette.red, s:palette.none, 'bold,underline')
call s:HL('WarningMsg', s:palette.yellow, s:palette.none, 'bold')
call s:HL('ModeMsg', s:palette.fg, s:palette.none, 'bold')
call s:HL('MoreMsg', s:palette.blue, s:palette.none, 'bold')
call s:HL('IncSearch', s:palette.bg0, s:palette.bg_red)
call s:HL('Search', s:palette.bg0, s:palette.bg_green)
call s:HL('MatchParen', s:palette.none, s:palette.bg4)
call s:HL('NonText', s:palette.bg4, s:palette.none)
call s:HL('Whitespace', s:palette.bg4, s:palette.none)
call s:HL('SpecialKey', s:palette.bg4, s:palette.none)
call s:HL('Pmenu', s:palette.fg, s:palette.bg2)
call s:HL('PmenuSbar', s:palette.none, s:palette.bg2)
if s:configuration.menu_selection_background ==# 'blue'
	call s:HL('PmenuSel', s:palette.bg0, s:palette.bg_blue)
	call s:HL('WildMenu', s:palette.bg0, s:palette.bg_blue)
elseif s:configuration.menu_selection_background ==# 'green'
	call s:HL('PmenuSel', s:palette.bg0, s:palette.bg_green)
	call s:HL('WildMenu', s:palette.bg0, s:palette.bg_green)
elseif s:configuration.menu_selection_background ==# 'red'
	call s:HL('PmenuSel', s:palette.bg0, s:palette.bg_red)
	call s:HL('WildMenu', s:palette.bg0, s:palette.bg_red)
endif
call s:HL('PmenuThumb', s:palette.none, s:palette.grey)
call s:HL('Question', s:palette.yellow, s:palette.none)
call s:HL('SpellBad', s:palette.red, s:palette.none, 'undercurl', s:palette.red)
call s:HL('SpellCap', s:palette.yellow, s:palette.none, 'undercurl', s:palette.yellow)
call s:HL('SpellLocal', s:palette.blue, s:palette.none, 'undercurl', s:palette.blue)
call s:HL('SpellRare', s:palette.purple, s:palette.none, 'undercurl', s:palette.purple)
call s:HL('StatusLine', s:palette.fg, s:palette.bg3)
call s:HL('StatusLineTerm', s:palette.fg, s:palette.bg3)
call s:HL('StatusLineNC', s:palette.grey, s:palette.bg1)
call s:HL('StatusLineTermNC', s:palette.grey, s:palette.bg1)
call s:HL('TabLine', s:palette.fg, s:palette.bg4)
call s:HL('TabLineFill', s:palette.grey, s:palette.bg1)
call s:HL('TabLineSel', s:palette.bg0, s:palette.bg_red)
call s:HL('VertSplit', s:palette.black, s:palette.none)
call s:HL('Visual', s:palette.none, s:palette.bg3)
call s:HL('VisualNOS', s:palette.none, s:palette.bg3, 'underline')
call s:HL('QuickFixLine', s:palette.blue, s:palette.none, 'bold')
call s:HL('Debug', s:palette.yellow, s:palette.none)
call s:HL('debugPC', s:palette.bg0, s:palette.green)
call s:HL('debugBreakpoint', s:palette.bg0, s:palette.red)
call s:HL('ToolbarButton', s:palette.bg0, s:palette.bg_blue)
call s:HL('Type', s:palette.blue, s:palette.none, 'italic')
call s:HL('Structure', s:palette.blue, s:palette.none, 'italic')
call s:HL('StorageClass', s:palette.blue, s:palette.none, 'italic')
call s:HL('Identifier', s:palette.orange, s:palette.none, 'italic')
call s:HL('Constant', s:palette.orange, s:palette.none, 'italic')
call s:HL('PreProc', s:palette.red, s:palette.none)
call s:HL('PreCondit', s:palette.red, s:palette.none)
call s:HL('Include', s:palette.red, s:palette.none)
call s:HL('Keyword', s:palette.red, s:palette.none)
call s:HL('Define', s:palette.red, s:palette.none)
call s:HL('Typedef', s:palette.red, s:palette.none)
call s:HL('Exception', s:palette.red, s:palette.none)
call s:HL('Conditional', s:palette.red, s:palette.none)
call s:HL('Repeat', s:palette.red, s:palette.none)
call s:HL('Statement', s:palette.red, s:palette.none)
call s:HL('Macro', s:palette.purple, s:palette.none)
call s:HL('Error', s:palette.red, s:palette.none)
call s:HL('Label', s:palette.purple, s:palette.none)
call s:HL('Special', s:palette.purple, s:palette.none)
call s:HL('SpecialChar', s:palette.purple, s:palette.none)
call s:HL('Boolean', s:palette.purple, s:palette.none)
call s:HL('String', s:palette.yellow, s:palette.none)
call s:HL('Character', s:palette.yellow, s:palette.none)
call s:HL('Number', s:palette.purple, s:palette.none)
call s:HL('Float', s:palette.purple, s:palette.none)
call s:HL('Function', s:palette.green, s:palette.none)
call s:HL('Operator', s:palette.red, s:palette.none)
call s:HL('Title', s:palette.red, s:palette.none, 'bold')
call s:HL('Tag', s:palette.orange, s:palette.none)
call s:HL('Delimiter', s:palette.fg, s:palette.none)
call s:HL('Comment', s:palette.grey, s:palette.none, 'italic')
call s:HL('SpecialComment', s:palette.grey, s:palette.none, 'italic')
call s:HL('Todo', s:palette.blue, s:palette.none, 'italic')
call s:HL('Ignore', s:palette.grey, s:palette.none)
call s:HL('Underlined', s:palette.none, s:palette.none, 'underline')
call s:HL('Fg', s:palette.fg, s:palette.none)
call s:HL('Grey', s:palette.grey, s:palette.none)
call s:HL('Red', s:palette.red, s:palette.none)
call s:HL('Orange', s:palette.orange, s:palette.none)
call s:HL('Yellow', s:palette.yellow, s:palette.none)
call s:HL('Green', s:palette.green, s:palette.none)
call s:HL('Blue', s:palette.blue, s:palette.none)
call s:HL('Purple', s:palette.purple, s:palette.none)
call s:HL('RedItalic', s:palette.red, s:palette.none, 'italic')
call s:HL('BlueItalic', s:palette.blue, s:palette.none, 'italic')
call s:HL('OrangeItalic', s:palette.orange, s:palette.none, 'italic')
let s:terminal = {
			\ 'black':s:palette.black,'red':s:palette.red,'yellow':s:palette.yellow,'green':s:palette.green,
			\ 'cyan':s:palette.orange,'blue':s:palette.blue,'purple':s:palette.purple,'white':s:palette.fg
			\ }
let g:terminal_ansi_colors = [s:terminal.black[0], s:terminal.red[0], s:terminal.green[0], s:terminal.yellow[0],
			\ s:terminal.blue[0], s:terminal.purple[0], s:terminal.cyan[0], s:terminal.white[0], s:terminal.black[0], s:terminal.red[0],
			\ s:terminal.green[0], s:terminal.yellow[0], s:terminal.blue[0], s:terminal.purple[0], s:terminal.cyan[0], s:terminal.white[0]]

