set linebreak
set textwidth=80

" compile to a pdf using pandoc
nmap <localleader>m <cmd>!pandoc -d default % -o /tmp/%<.pdf<cr><cr>

" open corresponding pdf file
nmap <localleader>v <cmd>!open /tmp/%<.pdf<cr><cr>
