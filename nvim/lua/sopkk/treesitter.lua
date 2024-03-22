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
    'markdown_inline',
    'python',
    'rust',
    'terraform',
    'toml',
    'typescript',
    'vimdoc',
    'yaml',
  },
  highlight = {
    enable = true,
    disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,
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
