vim.bo.makeprg = "pandoc -d default % -f markdown -o /tmp/%<.pdf"

vim.bo.shiftwidth = 2
map("<localleader>v", "<cmd>!open /tmp/%<.pdf<cr><cr>")

-- do magic to work with environments and commands in latex.
-- taken (almost) verbatim from https://github.com/kylechui/nvim-surround/discussions/53#discussioncomment-5585321
local function tex_find_environment()
  local cfg = require("nvim-surround.config")
  if vim.g.loaded_nvim_treesitter then
    local selection = cfg.get_selection {
      node = "generic_environment",
      -- query = {
      --   capture = "@block.outer",
      --   type = "textobjects",
      -- }
      -- NOTE: ^query doesn't seem to work very reliably with LaTeX environments
    }
    if selection then
      return selection
    end
  end
  return cfg.get_selection([[\begin%b{}.-\end%b{}]])
  -- NOTE: ^this does not correctly handle \begin{}-\end{} pairs in all cases
  --        (hence we use treesitter if available)
end

local surround_opts = {
  surrounds = {
    ["c"] = {
      add = function()
        local cmd = vim.fn.input({ prompt = "Command: " })
        if cmd then
          return { { "\\" .. cmd .. "{" }, { "}" } }
        end
      end,
      find = [=[\[^\{}%[%]]-%b{}]=],
      delete = [[^(\[^\{}]-{)().-(})()$]],
      change = {
        target = [[^\([^\{}]-)()%b{}()()$]],
        replacement = function()
          local cfg = require("nvim-surround.config")
          local cmd = cfg.get_input("Command: ")
          if cmd then
            return { { cmd }, { "" } }
          end
        end
      },
    },
    ["C"] = {
      add = function()
        local cmd, opts = vim.fn.input({ prompt = "Command: " }), vim.fn.input({ prompt = "Options: " })
        if cmd and opts then
          return { { "\\" .. cmd .. "[" .. opts .. "]{" }, { "}" } }
        end
      end,
      find = [[\[^\{}]-%b[]%b{}]],
      delete = [[^(\[^\{}]-%b[]{)().-(})()$]],
      change = {
        target = [[^\([^\{}]-)()%[(.*)()%]%b{}$]],
        replacement = function()
          local cfg = require("nvim-surround.config")
          local cmd, opts = cfg.get_input("Command: "), cfg.get_input("Options: ")
          if cmd and opts then
            return { { cmd }, { opts } }
          end
        end
      },
    },
    ["e"] = {
      add = function()
        local env = vim.fn.input({ prompt = "Environment: " })
        if env then
          return { { "\\begin{" .. env .. "}" }, { "\\end{" .. env .. "}" } }
        end
      end,
      find = tex_find_environment,
      delete = [[^(\begin%b{})().*(\end%b{})()$]],
      change = {
        target = [[^\begin{(.-)()%}.*\end{(.-)()}$]],
        replacement = function()
          local env = vim.fn.input({ prompt = "Environment: " })
          if env then
            return { { env }, { env } }
          end
        end,
      }
    },
    ["E"] = {
      add = function()
        local env, opts = vim.fn.input({ prompt = "Environment: " }), vim.fn.input({ prompt = "Options: " })
        if env and opts then
          return { { "\\begin{" .. env .. "}[" .. opts .. "]" }, { "\\end{" .. env .. "}" } }
        end
      end,
      find = tex_find_environment,
      delete = [[^(\begin%b{}%b[])().*(\end%b{})()$]],
      change = {
        target = [[^\begin%b{}%[(.-)()()()%].*\end%b{}$]],
        replacement = function()
          local env = vim.fn.input({ prompt = "Environment: " })
          if env then
            return { { env }, { "" } }
          end
        end,
      }
    },
  },
}

require("nvim-surround").buffer_setup(surround_opts)
