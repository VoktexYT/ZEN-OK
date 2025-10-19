-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.lsp.handlers["textDocument/inlayHint"] = function(...)
  local ok, result = pcall(vim.lsp.handlers["textDocument/inlayHint"], ...)
  if not ok then
    -- ignore error
    return
  end
  return result
end
