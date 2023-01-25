if not pcall(require, 'lspconfig') then
  return
end

local lspcnf = require 'lspconfig'

vim.keymap.set('n', '<leader>LR', ':LspRestart<CR>')

local workspace_dir = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local home = os.getenv "HOME"

-- TODO: root patterns could fix late initialization of the servers
-- :h lspconfig-server-configurations
local servers = {
  gopls = true, -- go install golang.org/x/tools/gopls@latest
  pyright = true, -- npm i -g pyright
  jsonnet_ls = true, -- go install github.com/grafana/jsonnet-language-server@latest
  terraformls = true, -- https://github.com/hashicorp/terraform-ls/releases
  sumneko_lua = { -- homebrew https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#sumneko_lua
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
  }

  -- yamlls = {    -- npm i -g yaml-language-server@latest
  --   yaml = {
  --     schemas = {
  --       ["https://raw.githubusercontent.com/quantumblacklabs/kedro/develop/static/jsonschema/kedro-catalog-0.17.json"]= "conf/**/*catalog*",
  --       ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*"
  --     }
  --   }
  -- },

}

local setup_server = function(server, config)
  if type(config) ~= "table" then
    config = {}
  end

  config = vim.tbl_deep_extend("force", {
    -- capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
    on_attach = function()
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, {buffer = 0})
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {buffer = 0})
      vim.keymap.set('n', 'gT', vim.lsp.buf.type_definition, {buffer = 0})
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {buffer = 0})
      vim.keymap.set('n', 'gr', vim.lsp.buf.rename, {buffer = 0})
      vim.keymap.set('n', '<leader>ga', vim.lsp.buf.code_action, {buffer = 0})
      vim.keymap.set('n', '[g', vim.diagnostic.goto_prev, {buffer = 0})
      vim.keymap.set('n', ']g', vim.diagnostic.goto_next, {buffer = 0})
    end,
  }, config)

  lspcnf[server].setup(config)
end

for server, config in pairs(servers) do
  setup_server(server, config)
end

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
  mapping = {
    ['<C-n>'] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
    ['<C-p>'] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-g>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },
  sources = {
    { name = 'nvim_lua' },
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'buffer', keyword_length = 5 },
    { name = "luasnip" },
  },
  experimental = {
    native_menu = false,
  }
}
