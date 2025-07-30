local vim,lsp,api,diagnostic = vim,vim.lsp,vim.api,vim.diagnostic
local M = {}

-- coc diagnostic
local function get_coc_diagnostic(diag_type)
  local has_info,info = pcall(vim.api.nvim_buf_get_var,0,'coc_diagnostic_info')
  if not has_info then return end
  if info[diag_type] > 0 then
    return  info[diag_type]
  end
  return ''
end

-- nvim-lspconfig
-- see https://github.com/neovim/nvim-lspconfig
local function get_nvim_lsp_diagnostic(diag_type)

  local clients ={} 

  if vim.lsp.get_clients then
    clients = vim.lsp.get_clients()
  else
    ---@diagnostic disable-next-line: deprecated 
    clients = vim.lsp.buf_get_clients()
  end

  if next(clients(0)) == nil then return '' end
  -- local active_clients = lsp.get_active_clients()
  local active_clients = {}

  if vim.lsp.get_clients then
    active_clients = vim.lsp.get_clients()
  else
    ---@diagnostic disable-next-line: deprecated
    active_clients = vim.lsp.get_active_clients()
  end

  if active_clients then
    local result = diagnostic.get(vim.api.nvim_get_current_buf(), { severity = diag_type })
    if result and #result ~= 0 then return #result .. ' ' end
  end
end

function M.get_diagnostic_error()

  local clients ={} 

  if vim.lsp.get_clients then
    clients = vim.lsp.get_clients()
  else
    ---@diagnostic disable-next-line: deprecated 
    clients = vim.lsp.buf_get_clients()
  end
  if vim.fn.exists('*coc#rpc#start_server') == 1 then
    return get_coc_diagnostic('error')
  elseif not vim.tbl_isempty(clients(0)) then
    return get_nvim_lsp_diagnostic(diagnostic.severity.ERROR)
  end
  return ''
end

function M.get_diagnostic_warn()
  local clients ={} 

  if vim.lsp.get_clients then
    clients = vim.lsp.get_clients()
  else
    ---@diagnostic disable-next-line: deprecated 
    clients = vim.lsp.buf_get_clients()
  end
  if vim.fn.exists('*coc#rpc#start_server') == 1 then
    return get_coc_diagnostic('warning')
  elseif not vim.tbl_isempty(clients(0)) then
    return get_nvim_lsp_diagnostic(diagnostic.severity.WARN)
  end
  return ''
end

function M.get_diagnostic_hint()

  local clients ={} 

  if vim.lsp.get_clients then
    clients = vim.lsp.get_clients()
  else
    ---@diagnostic disable-next-line: deprecated 
    clients = vim.lsp.buf_get_clients()
  end
  if vim.fn.exists('*coc#rpc#start_server') == 1 then
    return get_coc_diagnostic('hint')
  elseif not vim.tbl_isempty(clients(0)) then
    return get_nvim_lsp_diagnostic(diagnostic.severity.HINT)
  end
  return ''
end

function M.get_diagnostic_info()
  local clients ={} 

  if vim.lsp.get_clients then
    clients = vim.lsp.get_clients()
  else
    ---@diagnostic disable-next-line: deprecated 
    clients = vim.lsp.buf_get_clients()
  end
  if vim.fn.exists('*coc#rpc#start_server') == 1 then
    return get_coc_diagnostic('information')
  elseif not vim.tbl_isempty(clients(0)) then
    return get_nvim_lsp_diagnostic(diagnostic.severity.INFO)
  end
  return ''
end

return M
