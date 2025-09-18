-- :h lspconfig-server-configurations
local servers = {
  gopls = true,       -- Mason -- go install golang.org/x/tools/gopls@latest
  pyright = {     -- Mason -- npm i -g pyright
    settings = {
      python = {
        pythonPath = '.venv/bin/python',
      },
    }
  },
  jsonnet_ls = true,  -- Mason -- go install github.com/grafana/jsonnet-language-server@latest
  terraformls = true, -- Mason -- https://github.com/hashicorp/terraform-ls/releases
  groovyls = {        -- Mason | cmd: .local/share/nvim/mason/packages/groovy-language-server
    cmd = { 'groovy-language-server' },
  },
  ts_ls = true,  -- Mason
  yamlls = true, -- Mason -- https://github.com/redhat-developer/yaml-language-server
  lua_ls = {     -- Mason
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
        },
        diagnostics = {
          globals = { 'vim', 'use' },
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file('', true),
          checkThirdParty = false,
        },
        telemetry = {
          enable = false,
        },
      },
    },
  },

  rust_analyzer = { -- Mason -- rustup component add rust-analyzer
    cmd = {
      'rustup', 'run', 'stable', 'rust-analyzer',
    }
  },

}

return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/nvim-cmp',
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
  },
  config = function()
    local cmp = require('cmp')
    local fzf = require('fzf-lua')
    local lspkind = require('lspkind')

    for server, config in pairs(servers) do
      if type(config) ~= 'table' then
        config = {}
      end

      config = vim.tbl_deep_extend('force', {
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
      }, config)

      vim.lsp.enable(server)

      vim.diagnostic.config({ virtual_text = true, underline = false, float = { border = 'rounded' } })
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          local bufopts = { noremap = true, silent = true, buffer = ev.buf }

          -- :h vim.lsp
          vim.keymap.set('n', 'K', function() vim.lsp.buf.hover({ border = 'rounded' }) end, bufopts)
          vim.keymap.set('n', 'gd', fzf.lsp_definitions, bufopts)
          vim.keymap.set('n', 'gT', vim.lsp.buf.type_definition, bufopts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
          vim.keymap.set('n', '<leader>gr', fzf.lsp_references)
          vim.keymap.set('n', 'gF', function()
            vim.lsp.buf.format { async = true }
          end, bufopts)
          vim.keymap.set('n', '<leader>cg', fzf.lsp_document_diagnostics, bufopts)
          vim.keymap.set('n', '<leader>cG', fzf.lsp_workspace_diagnostics, bufopts)
          vim.keymap.set('n', '[g', function() vim.diagnostic.jump({ count = -1, float = true }) end, bufopts)
          vim.keymap.set('n', ']g', function() vim.diagnostic.jump({ count = 1, float = true }) end, bufopts)
          vim.keymap.set('i', '<C-s>', function() vim.lsp.buf.signature_help({ border = 'rounded' }) end, bufopts)
        end,
      })

      cmp.setup {
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        preselect = cmp.PreselectMode.None,
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-l>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<C-e>'] = cmp.mapping.abort(),
        }),
        sources = cmp.config.sources({
          { name = 'path' },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer', keyword_length = 5,
            option = {
              get_bufnrs = function()
                local bufs = {}
                for _, win in ipairs(vim.api.nvim_list_wins()) do
                  bufs[vim.api.nvim_win_get_buf(win)] = true
                end
                return vim.tbl_keys(bufs)
              end
            }
          },
        }),
        formatting = {
          format = lspkind.cmp_format({
            mode = 'symbol_text',
            menu = {
              buffer = '[buf]',
              nvim_lsp = '[LSP]',
              nvim_lua = '[api]',
              path = '[path]',
              luasnip = '[snip]',
            },
          })
        },
        experimental = {
          native_menu = false,
        }
      }
    end

    cmp.setup.cmdline({ '/', '?' }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer', keyword_length = 4 }
      }
    })

    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'path' }
      }, {
        { name = 'cmdline' }
      }),
      matching = { disallow_symbol_nonprefix_matching = false }
    })

    lspkind.init {
      symbol_map = {
        Method = '',
        Function = 'f(x)',
        Field = '',
        Variable = '',
        Class = '',
        Property = '',
        Keyword = '',
        File = '',
        Folder = '',
        Constant = '',
        Struct = '',
        Operator = '',
        Text = '',
      },
    }
  end
}
