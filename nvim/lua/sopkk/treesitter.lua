if not pcall(require, 'nvim-treesitter') then
  return
end

require'nvim-treesitter.configs'.setup {
  ensure_installed = {
    'bash',
    'dockerfile',
    'go',
    'hcl',
    'java',
    'javascript',
    'json',
    'markdown',
    'python',
    'rust',
    'terraform',
    'toml',
    'typescript',
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false
  },
  indent = {
    enable = true,
  }
}

if not pcall(require, 'treesitter-context') then
  return
end

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
