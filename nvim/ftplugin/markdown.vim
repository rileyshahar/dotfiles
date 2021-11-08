set linebreak
nnoremap j gj
nnoremap k gk

" compile to a pdf using pandoc
nmap <localleader>m <cmd>!pandoc % -o /tmp/%<.pdf<cr><cr>

" open corresponding pdf file
nmap <localleader>v <cmd>!open /tmp/%<.pdf<cr><cr>
