return {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
    {
      'nvim-treesitter/nvim-treesitter-context',
      config = function()
        require'treesitter-context'.setup{
          enable = true,
          throttle = true,
          max_lines = 0,
          patterns = {
            default = {
              'function',
              'method',
              'for',
              'while',
              'if',
              'switch',
              'case',
            },
          },
        }
      end,
    },
  },
  init = function()
    vim.o.foldmethod = 'expr'
    vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
    vim.o.foldlevelstart = 99
  end,
  config = function ()
    ---@diagnostic disable-next-line: missing-fields
    require('nvim-treesitter.configs').setup {
      ensure_installed = {
        'bash',
        'dockerfile',
        'go',
        'hcl',
        'java',
        'javascript',
        'json',
        'json5',
        'markdown',
        'markdown_inline',
        'python',
        'rust',
        'terraform',
        'toml',
        'typescript',
        'vimdoc',
        'yaml',
        'sql',
        'groovy',
        'make',
        'gotmpl',
      },
      highlight = {
        enable = true,
        disable = function(_, buf)
          local max_filesize = 2 * 1024 * 1024 -- 2 MB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
        additional_vim_regex_highlighting = false
      },
      indent = {
        enable = false,
      },
      textobjects = {
        move = {
          enable = true,
          set_jumps = true,

          goto_next_start = {
            ["]p"] = "@parameter.inner",
            ["]m"] = "@function.outer",
            ["]i"] = "@block.outer",
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
          },
          goto_previous_start = {
            ["[p"] = "@parameter.inner",
            ["[m"] = "@function.outer",
            ["[i"] = "@block.outer",
          },
          goto_previous_end = {
            ["[M"] = "@function.outer",
          },
        },
      }
    }
  end
}
