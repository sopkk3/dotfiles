if not pcall(require, 'lspconfig') then
  return
end

if not pcall(require, 'telescope') then
  return
end

local lspcnf = require 'lspconfig'

require("mason").setup()
require("mason-lspconfig").setup()

-- :h lspconfig-server-configurations
local servers = {
  gopls = true, -- Mason -- go install golang.org/x/tools/gopls@latest
  pyright = true, -- Mason -- npm i -g pyright
  jsonnet_ls = true, -- Mason -- go install github.com/grafana/jsonnet-language-server@latest
  terraformls = true, -- Mason -- https://github.com/hashicorp/terraform-ls/releases
  groovyls = true, -- Mason
  tsserver = true, -- Mason
  lua_ls = { -- Mason
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
        },
        diagnostics = {
          globals = {'vim', 'use'},
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true),
          checkThirdParty = false,
        },
        telemetry = {
          enable = false,
        },
      },
    },
  },

  rust_analyzer = { -- Mason -- rustup
    cmd = {
      "rustup", "run", "stable", "rust-analyzer",
    }
  },

}

if not pcall(require, 'cmp') then
  return
end

local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-n>'] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
    ['<C-p>'] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-o>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'path' },
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'nvim_lua' },
  },{
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
  experimental = {
    native_menu = false,
  }
}

local setup_server = function(server, config)
  if type(config) ~= "table" then
    config = {}
  end

  config = vim.tbl_deep_extend("force", {
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
  }, config)

  lspcnf[server].setup(config)
end

for server, config in pairs(servers) do
  setup_server(server, config)
end
