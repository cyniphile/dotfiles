" Bare URLs: keep the front of the URL, collapse the rest into a single '…'.
" vim-markdown already hides the target of [text](url) links, but a pasted bare
" URL has no display text to fall back on, so shorten it here.
"
" Needs 'conceallevel' >= 1 (set for prose filetypes in init.vim). 'concealcursor'
" is empty, so the line the cursor sits on shows the full URL for editing/yanking.

if !has('conceal')
  finish
endif

" How much of the URL survives, counted from just after the '//'.
let s:keep = get(g:, 'markdown_url_keep', 24)

" 'containedin' attaches this to vim-markdown's mkdInlineURL items (bare,
" parenthesised and <autolink>) without restating them — redefining those
" outranks the code-block regions and shortens URLs inside fences too.
" The pattern anchors on the scheme rather than counting from the match start:
" a contained pattern can be tried from the start of the line, which would make
" the kept prefix depend on how far into the line the URL sits. The lazy tail
" stops before a ')' or '>' that closes the URL, so the delimiter of a
" (parenthesised) or <autolink> form survives — but a ')' in the middle of a URL
" (…/Fold_(higher-order_function)#Examples) is still swallowed by the '…'.
execute 'syn match mkdUrlTail /\vhttps?:\/\/[^] \t]{' . s:keep . '}\zs[^] \t]{-1,}\ze[)>]?%([ \t]|$)/'
      \ . ' contained containedin=mkdInlineURL conceal cchar=…'
