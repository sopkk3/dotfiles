local opts = { buffer = true, noremap = true, silent = true }

if vim.fs.find({'pom.xml'}, { upward = true })[1] then
  vim.keymap.set('n', '<leader>cc', ':!mvn clean install<CR>', opts)
elseif vim.fs.find({'settings.gradle'}, { upward = true })[1] then
  vim.keymap.set('n', '<leader>cc', ':!gradle build<CR>', opts)
end

vim.opt_local.commentstring = [[// %s]]

local workspace_dir = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local home = os.getenv "HOME"
-- https://github.com/eclipse-jdtls/eclipse.jdt.ls#installation
-- https://projectlombok.org/download
local config = {
  cmd = {
    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xmx1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
    '-javaagent:' .. home .. '/build/lombok/1.18.28/lombok.jar',
    '-jar', home .. '/build/jdtls/1.39.0/plugins/org.eclipse.equinox.launcher_1.6.900.v20240613-2009.jar',
    '-configuration', home .. '/build/jdtls/1.39.0/config_mac',
    '-data', vim.fn.expand('/tmp/jdtls-workspace') .. workspace_dir,
  },

  root_dir = require('jdtls.setup').find_root({'.git', 'pom.xml', 'settings.gradle'}),

  -- https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  settings = {
    java = {
    }
  },

  -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
  init_options = {
    bundles = {}
  },

}

require('jdtls').start_or_attach(config)
