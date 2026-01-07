return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    -- cargo install --locked tree-sitter-cli
    config = function ()
      require('nvim-treesitter').setup({
        install_dir = vim.fn.stdpath('data') .. '/site',
      })
      local parsers = {
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
        'helm',
      }
      local group = vim.api.nvim_create_augroup('TreesitterSetup', { clear = true })
      local ts = require('nvim-treesitter')
      ts.install(parsers)

      vim.api.nvim_create_autocmd('FileType', {
        group = group,
        desc = "Enable treesitter",
        callback = function(event)
          local lang = vim.treesitter.language.get_lang(event.match) or event.match
          if vim.list_contains(ts.get_installed(),vim.treesitter.language.get_lang(lang)) then
            vim.treesitter.start()
          end
        end,
      })
    end
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('nvim-treesitter-textobjects').setup({
        select = {
          lookahead = true,
        },
        move = {
          set_jumps = true,
        },
      })
      vim.keymap.set('n', ']p', function() require('nvim-treesitter-textobjects.move').goto_next_start('@parameter.inner', 'textobjects') end)
      vim.keymap.set('n', ']m', function() require('nvim-treesitter-textobjects.move').goto_next_start('@function.outer', 'textobjects') end)
      vim.keymap.set('n', ']i', function() require('nvim-treesitter-textobjects.move').goto_next_start('@block.outer', 'textobjects') end)

      vim.keymap.set('n', '[p', function() require('nvim-treesitter-textobjects.move').goto_previous_start('@parameter.inner', 'textobjects') end)
      vim.keymap.set('n', '[m', function() require('nvim-treesitter-textobjects.move').goto_previous_start('@function.outer', 'textobjects') end)
      vim.keymap.set('n', '[i', function() require('nvim-treesitter-textobjects.move').goto_previous_start('@block.outer', 'textobjects') end)

      vim.keymap.set('n', '[M', function() require('nvim-treesitter-textobjects.move').goto_previous_end('@function.outer', 'textobjects') end)
      vim.keymap.set('n', ']M', function() require('nvim-treesitter-textobjects.move').goto_next_end('@function.outer', 'textobjects') end)
    end
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
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
  }
}
