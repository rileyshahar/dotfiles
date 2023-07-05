vim.o.textwidth = 80

-- compile to a pdf using pandoc
vim.bo.makeprg = "norg2pdf % /tmp/%<.pdf"

require("mini.surround").setup({
  custom_surroundings = {
    l = {
      output = function()
        local text = string.gmatch(vim.fn.getreg("+"), "[^\n]+")()
        return {
          left = "[",
          right = "]{" .. text .. "}",
        }
      end,
      input = { "%[().-()%]%{.*%}" },
    }
  }
})
