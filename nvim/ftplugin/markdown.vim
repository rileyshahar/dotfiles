set linebreak
nnoremap j gj
nnoremap k gk

" compile to a pdf using pandoc
setlocal makeprg=pandoc\ %\ -o\ /tmp/%<.pdf
nmap <localleader>m <cmd>make<cr><cr>

" open corresponding pdf file
nmap <localleader>v <cmd>!open /tmp/%<.pdf<cr><cr>
