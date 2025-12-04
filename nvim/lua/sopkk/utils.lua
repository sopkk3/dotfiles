local M = {}

function  M.print_out(obj)
  print(obj.stdout)
  print(obj.stderr)
end

function M.make_async(args)
  local target = args.fargs[1] or false
  local command = {'make'}
  if target then
    table.insert(command, target)
  end
  vim.system(command, { text = true }, M.print_out) -- timeout can be set (ms)
end

return M
