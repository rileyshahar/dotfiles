return {
    -- remove trailing whitespace and lines
    -- reverse the file, remove starting newlines, reverse again, remove trailing whitespace
    formatCommand = "tac | sed -e '/./,$!d' | tac | sed 's/[ \t]*$//'",
    formatStdin = true
}
