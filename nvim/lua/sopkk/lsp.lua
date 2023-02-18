if not pcall(require, 'lspconfig') then
  return
end

local lspcnf = require 'lspconfig'

local workspace_dir = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local home = os.getenv "HOME"

require("mason").setup()
require("mason-lspconfig").setup()

-- :h lspconfig-server-configurations
local servers = {
  gopls = true, -- Mason -- go install golang.org/x/tools/gopls@latest
  pyright = true, -- Mason -- npm i -g pyright
  jsonnet_ls = true, -- Mason -- go install github.com/grafana/jsonnet-language-server@latest
  terraformls = true, -- Mason -- https://github.com/hashicorp/terraform-ls/releases
  groovyls = true,
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

  jdtls = { -- https://github.com/eclipse/eclipse.jdt.ls#installation
    cmd = {
      'java',
      '-Declipse.application=org.eclipse.jdt.ls.core.id1',
      '-Dosgi.bundles.defaultStartLevel=4',
      '-Declipse.product=org.eclipse.jdt.ls.core.product',
      '-Dlog.level=ALL',
      '-javaagent:' .. home .. '/build/jdtls/lombok.jar',
      '-noverify',
      '-jar', home .. '/build/jdtls/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar',
      '-configuration', home .. '/build/jdtls/config_mac',
      '-data', vim.fn.expand('/tmp/jdtls-workspace') .. workspace_dir,
    },
    vmargs = { -- https://github.com/williamboman/nvim-lsp-installer/blob/main/lua/nvim-lsp-installer/servers/jdtls/README.md
      "-XX:+UseParallelGC",
      "-XX:GCTimeRatio=4",
      "-XX:AdaptiveSizePolicyWeight=90",
      "-Dsun.zip.disableMemoryMapping=true",
      "-Djava.import.generatesMetadataFilesAtProjectRoot=false",
      "-Xmx1G",
      "-Xms100m",
    },
  },

  rust_analyzer = { -- Mason -- rustup
    cmd = {
      "rustup", "run", "stable", "rust-analyzer",
    }
  },

  -- yamlls = {    -- npm i -g yaml-language-server@latest
  --   yaml = {
  --     schemas = {
  --       ["https://raw.githubusercontent.com/quantumblacklabs/kedro/develop/static/jsonschema/kedro-catalog-0.17.json"]= "conf/**/*catalog*",
  --       ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*"
  --     }
  --   }
  -- },

}

if not pcall(require, 'cmp') then
  return
end
-- cmpletion
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
    ['<C-g>'] = cmp.mapping.complete(),
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
    on_attach = function(client, bufnr)
      local bufopts = { noremap=true, silent=true, buffer=bufnr }
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
      vim.keymap.set('n', 'gT', vim.lsp.buf.type_definition, bufopts)
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
      vim.keymap.set('n', 'gR', vim.lsp.buf.rename, bufopts)
      vim.keymap.set('i', '<C-l>', vim.lsp.buf.signature_help, bufopts)
      vim.keymap.set('n', 'gF', vim.lsp.buf.format, bufopts)
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
      vim.keymap.set('n', '[g', vim.diagnostic.goto_prev, bufopts)
      vim.keymap.set('n', ']g', vim.diagnostic.goto_next, bufopts)
    end,
  }, config)

  lspcnf[server].setup(config)
end

for server, config in pairs(servers) do
  setup_server(server, config)
end
